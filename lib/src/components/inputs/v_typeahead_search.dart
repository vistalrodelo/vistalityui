import 'dart:async';

import 'package:flutter/material.dart';
import '../textbox/v_textbox.dart';

class VTypeaheadSearchBox extends StatefulWidget {
  final List<String> options;
  final Iterable<String> Function(String query)? optionsBuilder;
  final Future<List<String>> Function(String query)? asyncOptionsBuilder;
  final Duration debounce;
  final String? loadingText;
  final String? emptyText;
  final String? errorText;
  final ValueChanged<String>? onSelected;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final Object? prefixIcon;
  final Object? suffixIcon;

  const VTypeaheadSearchBox({
    super.key,
    required this.options,
    this.optionsBuilder,
    this.asyncOptionsBuilder,
    this.debounce = const Duration(milliseconds: 300),
    this.loadingText = 'Loading...',
    this.emptyText = 'No results',
    this.errorText = 'Failed to load',
    this.onSelected,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<VTypeaheadSearchBox> createState() => _VTypeaheadSearchBoxState();
}

class _VTypeaheadSearchBoxState extends State<VTypeaheadSearchBox> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;
  Timer? _debounceTimer;
  String _lastQuery = '';
  List<String> _asyncOptions = const [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _ownsController = widget.controller == null;
    _ownsFocusNode = widget.focusNode == null;
    if (widget.asyncOptionsBuilder != null) {
      _controller.addListener(_onQueryChanged);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.asyncOptionsBuilder != null) {
      _controller.removeListener(_onQueryChanged);
    }
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      textEditingController: _controller,
      focusNode: _focusNode,
      optionsBuilder: (value) {
        final query = value.text.trim();
        if (query.isEmpty) return const Iterable<String>.empty();
        if (widget.asyncOptionsBuilder != null) {
          return _asyncOptions;
        }
        if (widget.optionsBuilder != null) {
          return widget.optionsBuilder!(query);
        }
        return widget.options.where(
          (opt) => opt.toLowerCase().contains(query.toLowerCase()),
        );
      },
      onSelected: widget.onSelected,
      fieldViewBuilder: (context, controller, focusNode, onSubmit) {
        return VTextBox(
          controller: controller,
          focusNode: focusNode,
          label: widget.label,
          hint: widget.hint ?? 'Search',
          prefixIcon: widget.prefixIcon ?? const Icon(Icons.search),
          suffixIcon: widget.suffixIcon,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => onSubmit(),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        if (widget.asyncOptionsBuilder != null) {
          if (_loading) {
            return _buildHintOverlay(widget.loadingText ?? 'Loading...');
          }
          if (_error != null) {
            return _buildHintOverlay(_error!);
          }
          if (options.isEmpty) {
            return _buildHintOverlay(widget.emptyText ?? 'No results');
          }
        }
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHintOverlay(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 80),
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [Text(text)],
          ),
        ),
      ),
    );
  }

  void _onQueryChanged() {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      setState(() => _asyncOptions = const []);
      return;
    }
    _lastQuery = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounce, () async {
      setState(() {
        _loading = true;
        _error = null;
      });
      final current = _lastQuery;
      try {
        final result = await widget.asyncOptionsBuilder!(current);
        if (!mounted) return;
        if (current != _lastQuery) return;
        setState(() {
          _asyncOptions = result;
          _loading = false;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _error = widget.errorText;
          _asyncOptions = const [];
        });
      }
    });
  }
}
