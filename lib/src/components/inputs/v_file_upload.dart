import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import '../button/v_button.dart';
import '../../foundation/v_radius.dart';

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
    this.maxPreviewBytes = 2 * 1024 * 1024,
  });

  @override
  State<VFileUpload> createState() => _VFileUploadState();
}

class _VFileUploadState extends State<VFileUpload> {
  List<_SelectedFile> _files = const [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VButton(
          label: widget.label,
          onPressed: widget.enabled ? _pickFiles : null,
        ),
        if (_files.isNotEmpty) ...[
          const SizedBox(height: 8),
          ..._files.map(_buildFileInfo),
        ],
      ],
    );
  }

  Future<void> _pickFiles() async {
    final types = widget.allowedTypes ?? const <XTypeGroup>[];
    final files = widget.allowMultiple
        ? await openFiles(acceptedTypeGroups: types)
        : await _pickSingleFile(types);
    if (files.isEmpty) return;

    final selected = <_SelectedFile>[];
    for (final file in files) {
      final isImage = _isImage(file.name);
      Uint8List? bytes;
      if (isImage) {
        final fileSize = await file.length();
        if (fileSize <= widget.maxPreviewBytes) {
          bytes = await file.readAsBytes();
        }
      }
      int? size;
      try {
        size = await file.length();
      } catch (_) {}
      selected.add(_SelectedFile(file: file, bytes: bytes, size: size));
    }

    setState(() => _files = selected);
    widget.onChanged?.call(files);
  }

  Future<List<XFile>> _pickSingleFile(List<XTypeGroup> types) async {
    final file = await openFile(acceptedTypeGroups: types);
    if (file == null) return const [];
    return [file];
  }

  Widget _buildFileInfo(_SelectedFile file) {
    final isImage = _isImage(file.file.name);
    final size = file.size == null ? 'Unknown' : _formatBytes(file.size!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isImage && file.bytes != null) ...[
            ClipRRect(
              borderRadius: context.vRadius.borderRadius(VRadiusSize.sm),
              child: Image.memory(
                file.bytes!,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.file.name),
                const SizedBox(height: 2),
                Text(
                  '${_extension(file.file.name)} • $size',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }
}

class _SelectedFile {
  final XFile file;
  final Uint8List? bytes;
  final int? size;

  const _SelectedFile({
    required this.file,
    this.bytes,
    this.size,
  });
}
