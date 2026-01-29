import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../foundation/v_radius.dart';

class VOtpInput extends StatefulWidget {
  final List<TextEditingController>? controllers;
  final List<FocusNode>? focusNodes;
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool autoSubmit;
  final bool enabled;
  final double size;

  const VOtpInput({
    super.key,
    this.controllers,
    this.focusNodes,
    this.length = 4,
    this.onChanged,
    this.onCompleted,
    this.autoSubmit = false,
    this.enabled = true,
    this.size = 48,
  }) : assert(length > 0);

  @override
  State<VOtpInput> createState() => _VOtpInputState();
}

class _VOtpInputState extends State<VOtpInput> {
  final List<TextEditingController> _ownedControllers = [];
  final List<FocusNode> _ownedFocusNodes = [];
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  @override
  void didUpdateWidget(covariant VOtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.length != widget.length ||
        oldWidget.controllers != widget.controllers ||
        oldWidget.focusNodes != widget.focusNodes) {
      _syncControllers();
    }
  }

  @override
  void dispose() {
    for (final c in _ownedControllers) {
      c.dispose();
    }
    for (final f in _ownedFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _syncControllers() {
    for (final c in _ownedControllers) {
      c.dispose();
    }
    for (final f in _ownedFocusNodes) {
      f.dispose();
    }
    _ownedControllers.clear();
    _ownedFocusNodes.clear();

    final providedControllers = widget.controllers ?? const <TextEditingController>[];
    final providedFocusNodes = widget.focusNodes ?? const <FocusNode>[];

    _controllers = List<TextEditingController>.from(providedControllers);
    _focusNodes = List<FocusNode>.from(providedFocusNodes);

    while (_controllers.length < widget.length) {
      final controller = TextEditingController();
      _controllers.add(controller);
      _ownedControllers.add(controller);
    }
    while (_focusNodes.length < widget.length) {
      final node = FocusNode();
      _focusNodes.add(node);
      _ownedFocusNodes.add(node);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.length, (index) {
        final controller = _controllers[index];
        final focusNode = _focusNodes[index];
        final isLast = index == widget.length - 1;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: widget.enabled,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 1,
              textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: context.vRadius.defaultBorderRadius(),
                ),
              ),
              onSubmitted: (_) {
                if (isLast) {
                  _maybeSubmit();
                } else {
                  _moveNext(context, focusNode);
                }
              },
              onChanged: (value) {
                final text = _controllers.take(widget.length).map((c) => c.text).join();
                widget.onChanged?.call(text);
                if (value.isNotEmpty) {
                  if (isLast) {
                    _maybeSubmit();
                  } else {
                    _moveNext(context, focusNode);
                  }
                }
              },
            ),
          ),
        );
      }),
    );
  }

  void _moveNext(BuildContext context, FocusNode? node) {
    if (node != null) {
      node.nextFocus();
    } else {
      FocusScope.of(context).nextFocus();
    }
  }

  void _maybeSubmit() {
    if (!widget.autoSubmit) return;
    final text = _controllers.take(widget.length).map((c) => c.text).join();
    if (text.length == widget.length) {
      widget.onCompleted?.call(text);
    }
  }
}
