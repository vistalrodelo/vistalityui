import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import '../button/v_button.dart';
import '../../foundation/v_radius.dart';
import 'v_image_cropper.dart';

/// File picker with optional previews.
class VFileUpload extends StatefulWidget {
  /// Label for the upload button.
  final String label;

  /// Whether the picker is enabled.
  final bool enabled;

  /// Whether multiple files can be selected.
  final bool allowMultiple;

  /// Optional list of allowed MIME groups.
  final List<XTypeGroup>? allowedTypes;

  /// Called when files are selected.
  final ValueChanged<List<XFile>>? onChanged;

  /// Whether selected files can be removed.
  final bool allowRemove;

  /// Whether drag-and-drop is enabled.
  final bool allowDrop;

  /// Whether images can be cropped.
  final bool allowCrop;

  /// Height of the preview/drop area.
  final double? height;

  /// Maximum bytes to preview for images.
  final int maxPreviewBytes;

  /// Creates a [VFileUpload].
  const VFileUpload({
    super.key,
    this.label = 'Upload file',
    this.enabled = true,
    this.allowMultiple = false,
    this.allowedTypes,
    this.onChanged,
    this.allowRemove = true,
    this.allowDrop = true,
    this.allowCrop = true,
    this.height,
    this.maxPreviewBytes = 10 * 1024 * 1024,
  });

  @override
  State<VFileUpload> createState() => _VFileUploadState();
}

class _VFileUploadState extends State<VFileUpload> {
  List<_SelectedFile> _files = const [];
  bool _isDragging = false;
  DropzoneViewController? _dropzoneController;
  final Set<String> _activeWebUrls = {};
  static const double _defaultDropHeight = 180;

  @override
  void dispose() {
    _releaseWebUrls(_files);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.allowDrop) {
      final dropArea = kIsWeb ? _buildWebDropArea(context) : _buildDropArea(context);
      return Stack(
        children: [
          dropArea,
          Positioned(
            right: 12,
            bottom: 12,
            child: VButton(
              label: widget.label,
              onPressed: widget.enabled ? _pickFiles : null,
            ),
          ),
        ],
      );
    }
    return VButton(
      label: widget.label,
      onPressed: widget.enabled ? _pickFiles : null,
    );
  }

  Future<void> _pickFiles() async {
    final types = widget.allowedTypes ?? const <XTypeGroup>[];
    final files = widget.allowMultiple
        ? await openFiles(acceptedTypeGroups: types)
        : await _pickSingleFile(types);
    if (files.isEmpty) return;

    await _setFiles(files);
  }

  Future<List<XFile>> _pickSingleFile(List<XTypeGroup> types) async {
    final file = await openFile(acceptedTypeGroups: types);
    if (file == null) return const [];
    return [file];
  }

  void _removeFile(int index) {
    final updated = List<_SelectedFile>.of(_files)..removeAt(index);
    _setSelectedFiles(updated);
  }

  Widget _buildDropArea(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderColor =
        _isDragging ? scheme.primary : Colors.grey.withValues(alpha: 0.4);
    final background = _isDragging
        ? scheme.primary.withValues(alpha: 0.08)
        : Colors.transparent;
    final hasPreview = _files.isNotEmpty;
    return SizedBox(
      height: _dropAreaHeight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: hasPreview ? EdgeInsets.zero : const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: hasPreview
              ? BorderRadius.zero
              : context.vRadius.defaultBorderRadius(),
          border: hasPreview ? null : Border.all(color: borderColor),
          color: background,
        ),
        child: SizedBox.expand(child: _buildDropPreview(context)),
      ),
    );
  }

  Widget _buildWebDropArea(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderColor =
        _isDragging ? scheme.primary : Colors.grey.withValues(alpha: 0.4);
    final background = _isDragging
        ? scheme.primary.withValues(alpha: 0.08)
        : Colors.transparent;
    final hasPreview = _files.isNotEmpty;
    return SizedBox(
      height: _dropAreaHeight,
      child: Stack(
        children: [
          DropzoneView(
            operation: DragOperation.copy,
            cursor: CursorType.grab,
            onCreated: (controller) => _dropzoneController = controller,
            onHover: () => setState(() => _isDragging = true),
            onLeave: () => setState(() => _isDragging = false),
            onDropFile: widget.enabled ? _handleWebDropFile : null,
            onDropFiles: widget.enabled ? _handleWebDropFiles : null,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: hasPreview ? EdgeInsets.zero : const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: hasPreview
                  ? BorderRadius.zero
                  : context.vRadius.defaultBorderRadius(),
              border: hasPreview ? null : Border.all(color: borderColor),
              color: background,
            ),
            child: SizedBox.expand(child: _buildDropPreview(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildDropPreview(BuildContext context) {
    if (_files.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.image_outlined, size: 36, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              !widget.enabled
                  ? 'Upload disabled'
                  : kIsWeb
                      ? 'Drag & drop files here'
                      : 'Choose a file',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    final file = _files.first;
    final isImageFile = _isImage(file.file.name);
    final isImagePreview = isImageFile && file.bytes != null;
    final info = _buildPreviewInfo(context, file);
    return Stack(
      children: [
        if (isImagePreview) _buildImagePreview(context, file)
        else
          _buildFileSummary(context, file),
        if (isImagePreview)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: info,
          ),
        if (isImageFile && _canCropFile(file))
          Positioned(
            top: 4,
            left: 4,
            child: IconButton(
              icon: const Icon(Icons.crop),
              tooltip: 'Crop',
              onPressed: () => _cropImage(0),
            ),
          ),
        if (widget.allowRemove)
          Positioned(
            top: 25,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Remove',
              onPressed: widget.enabled ? () => _removeFile(0) : null,
            ),
          ),
      ],
    );
  }

  Widget _buildImagePreview(BuildContext context, _SelectedFile file) {
    final scheme = Theme.of(context).colorScheme;
    final hasDimensions = file.width != null && file.height != null;
    final aspect = hasDimensions ? file.width! / file.height! : 1.0;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final previewWidth = maxWidth > 360 ? 360.0 : maxWidth;
          final maxHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : _previewHeight;
          final previewHeight = math.min(previewWidth / aspect, maxHeight);
          return Center(
            child: SizedBox(
              width: previewWidth,
              height: previewHeight,
              child: CustomPaint(
                painter: _CheckerboardPainter(
                  light: scheme.surface,
                  dark: scheme.surfaceContainerHighest,
                ),
                child: Image.memory(
                  file.bytes!,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreviewInfo(BuildContext context, _SelectedFile file) {
    final size = file.size == null ? 'Unknown' : _formatBytes(file.size!);
    final dimensions = (file.width != null && file.height != null)
        ? '${file.width}×${file.height}'
        : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 12),
        child: Row(
          children: [
            Expanded(child: Text(file.file.name, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            if (dimensions != null) ...[
              Text(dimensions),
              const SizedBox(width: 8),
            ],
            Text(size),
          ],
        ),
      ),
    );
  }

  Widget _buildFileSummary(BuildContext context, _SelectedFile file) {
    final size = file.size == null ? 'Unknown' : _formatBytes(file.size!);
    final extraCount = _files.length - 1;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(file.file.name, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(
          '${_extension(file.file.name)} • $size',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        if (extraCount > 0) ...[
          const SizedBox(height: 4),
          Text(
            '+$extraCount more file${extraCount == 1 ? '' : 's'}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ],
    );
  }

  Future<void> _setFiles(List<XFile> files) async {
    final selected = <_SelectedFile>[];
    for (final file in files) {
      selected.add(await _buildSelectedFile(file));
    }
    _setSelectedFiles(selected);
  }

  void _setSelectedFiles(List<_SelectedFile> selected) {
    _releaseWebUrlsDiff(_files, selected);
    setState(() => _files = selected);
    widget.onChanged?.call(selected.map((entry) => entry.file).toList());
  }

  Future<_SelectedFile> _buildSelectedFile(XFile file) async {
    final isImage = _isImage(file.name);
    Uint8List? bytes;
    ui.Image? decoded;
    if (isImage) {
      final fileSize = await file.length();
      if (fileSize <= widget.maxPreviewBytes) {
        bytes = await file.readAsBytes();
        try {
          decoded = await _decodeImage(bytes);
        } catch (_) {}
      }
    }
    int? size;
    try {
      size = await file.length();
    } catch (_) {}
    return _SelectedFile(
      file: file,
      bytes: bytes,
      size: size,
      width: decoded?.width,
      height: decoded?.height,
    );
  }

  bool _canCropFile(_SelectedFile file) {
    return widget.allowCrop &&
        widget.enabled &&
        vSupportsImageCrop;
  }

  Future<void> _cropImage(int index) async {
    final file = _files[index];
    if (!_canCropFile(file)) return;
    final sourcePath = kIsWeb ? await _resolveWebSourcePath(file) : file.file.path;
    if (sourcePath == null || sourcePath.isEmpty) return;
    if (!mounted) return;
    final updatedFile = await vCropImage(
      file: file.file,
      context: context,
      sourcePath: sourcePath,
    );
    if (updatedFile == null) return;
    final updatedSelected = await _buildSelectedFile(updatedFile);
    final updatedList = List<_SelectedFile>.of(_files);
    updatedList[index] = updatedSelected;
    _setSelectedFiles(updatedList);
  }

  Future<String?> _resolveWebSourcePath(_SelectedFile file) async {
    if (file.webUrl != null) return file.webUrl;
    Uint8List bytes;
    if (file.bytes != null) {
      bytes = file.bytes!;
    } else {
      try {
        bytes = await file.file.readAsBytes();
      } catch (_) {
        return null;
      }
    }
    final mime = file.file.mimeType ?? _guessMimeType(file.file.name);
    final base64Data = base64Encode(bytes);
    return 'data:$mime;base64,$base64Data';
  }

  Future<ui.Image> _decodeImage(Uint8List bytes) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, completer.complete);
    return completer.future;
  }

  void _handleWebDropFile(DropzoneFileInterface file) {
    _handleWebDrop([file]);
  }

  void _handleWebDropFiles(List<DropzoneFileInterface>? files) {
    if (files == null || files.isEmpty) return;
    _handleWebDrop(files);
  }

  Future<void> _handleWebDrop(List<DropzoneFileInterface> files) async {
    if (_dropzoneController == null) return;
    final selected = <_SelectedFile>[];
    for (final file in files) {
      final built = await _buildWebSelectedFile(file);
      if (_matchesAllowedTypes(built.file)) {
        selected.add(built);
      } else {
        _releaseWebUrl(built.webUrl);
      }
    }
    if (selected.isEmpty) {
      setState(() => _isDragging = false);
      return;
    }
    final accepted = widget.allowMultiple ? selected : [selected.first];
    if (!widget.allowMultiple && selected.length > 1) {
      for (final extra in selected.skip(1)) {
        _releaseWebUrl(extra.webUrl);
      }
    }
    _setSelectedFiles(accepted);
    setState(() => _isDragging = false);
  }

  Future<_SelectedFile> _buildWebSelectedFile(
    DropzoneFileInterface file,
  ) async {
    final controller = _dropzoneController!;
    final name = await controller.getFilename(file);
    final mimeType = await controller.getFileMIME(file);
    final data = await controller.getFileData(file);
    final url = await controller.createFileUrl(file);
    _activeWebUrls.add(url);
    final xfile = XFile.fromData(
      data,
      name: name,
      mimeType: mimeType,
    );
    ui.Image? decoded;
    if (_isImage(name)) {
      try {
        decoded = await _decodeImage(data);
      } catch (_) {}
    }
    return _SelectedFile(
      file: xfile,
      bytes: _isImage(name) ? data : null,
      size: data.length,
      width: decoded?.width,
      height: decoded?.height,
      webUrl: url,
    );
  }

  void _releaseWebUrls(List<_SelectedFile> files) {
    for (final file in files) {
      _releaseWebUrl(file.webUrl);
    }
  }

  void _releaseWebUrlsDiff(
    List<_SelectedFile> previous,
    List<_SelectedFile> next,
  ) {
    final nextUrls =
        next.map((file) => file.webUrl).whereType<String>().toSet();
    for (final file in previous) {
      final url = file.webUrl;
      if (url != null && !nextUrls.contains(url)) {
        _releaseWebUrl(url);
      }
    }
  }

  void _releaseWebUrl(String? url) {
    if (url == null) return;
    if (_activeWebUrls.remove(url)) {
      _dropzoneController?.releaseFileUrl(url);
    }
  }

  bool _matchesAllowedTypes(XFile file) {
    final allowed = widget.allowedTypes;
    if (allowed == null || allowed.isEmpty) return true;
    final ext = _extension(file.name).toLowerCase();
    final allowedExts = <String>{};
    final allowedMimes = <String>{};
    for (final group in allowed) {
      if (group.extensions != null) {
        allowedExts.addAll(group.extensions!.map((e) => e.toLowerCase()));
      }
      if (group.mimeTypes != null) {
        allowedMimes.addAll(group.mimeTypes!.map((m) => m.toLowerCase()));
      }
    }
    final matchesExtension =
        allowedExts.isNotEmpty && allowedExts.contains(ext);
    final mimeType = file.mimeType?.toLowerCase();
    final matchesMime =
        mimeType != null && allowedMimes.isNotEmpty && allowedMimes.contains(mimeType);
    if (allowedExts.isEmpty && allowedMimes.isEmpty) return true;
    return matchesExtension || matchesMime;
  }

  bool _isImage(String name) {
    final ext = _extension(name).toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext);
  }

  String _extension(String name) {
    final parts = name.split('.');
    if (parts.length <= 1) return 'file';
    return parts.last;
  }

  String _guessMimeType(String name) {
    final ext = _extension(name).toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      default:
        return 'application/octet-stream';
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  double get _dropAreaHeight => widget.height ?? _defaultDropHeight;

  double get _previewHeight {
    final height = _dropAreaHeight - 32;
    return height < 80 ? 80 : height;
  }
}

class _SelectedFile {
  final XFile file;
  final Uint8List? bytes;
  final int? size;
  final int? width;
  final int? height;
  final String? webUrl;

  const _SelectedFile({
    required this.file,
    this.bytes,
    this.size,
    this.width,
    this.height,
    this.webUrl,
  });
}

class _CheckerboardPainter extends CustomPainter {
  final Color light;
  final Color dark;
  final double _squareSize = 8;

  const _CheckerboardPainter({
    required this.light,
    required this.dark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintLight = Paint()..color = light;
    final paintDark = Paint()..color = dark;
    for (double y = 0; y < size.height; y += _squareSize) {
      for (double x = 0; x < size.width; x += _squareSize) {
        final isDark =
            ((x / _squareSize).floor() + (y / _squareSize).floor()) % 2 == 0;
        canvas.drawRect(
          Rect.fromLTWH(x, y, _squareSize, _squareSize),
          isDark ? paintDark : paintLight,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CheckerboardPainter oldDelegate) {
    return oldDelegate.light != light || oldDelegate.dark != dark;
  }
}
