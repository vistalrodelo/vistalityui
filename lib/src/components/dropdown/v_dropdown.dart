import 'package:flutter/material.dart';
import '../../foundation/v_control_sizes.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';
import '../textbox/v_textbox.dart';

/// Dropdown item definition for [VDropdown].
class VDropdownItem<T> {
  /// Underlying value for the item.
  final T value;

  /// Label text shown when [child] is not provided.
  final String label;

  /// Optional custom widget for the item.
  final Widget? child;

  /// Creates a [VDropdownItem].
  const VDropdownItem({
    required this.value,
    required this.label,
    this.child,
  });
}

/// A styled dropdown form field.
class VDropdown<T> extends StatefulWidget {
  /// Items available in the dropdown.
  final List<VDropdownItem<T>> items;

  /// Currently selected value.
  final T? value;

  /// Called when the selection changes.
  final ValueChanged<T?>? onChanged;

  /// Label text displayed above the field.
  final String? label;

  /// Hint text displayed when no selection is made.
  final String? hint;

  /// Error text shown below the field.
  final String? errorText;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is filled.
  final bool filled;

  /// Radius token or identifier resolved by [VRadius].
  final Object? radius;

  /// Explicit radius override when not using a token.
  final double? radiusValue;

  /// Padding inside the field.
  final EdgeInsetsGeometry? contentPadding;

  /// Optional height override for the control.
  final double? controlHeight;

  /// Whether to show error text below the control.
  final bool showErrorText;

  /// Creates a [VDropdown].
  const VDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
    this.hint,
    this.errorText,
    this.enabled = true,
    this.filled = true,
    this.radius,
    this.radiusValue,
    this.contentPadding,
    this.controlHeight,
    this.showErrorText = true,
  });

  @override
  State<VDropdown<T>> createState() => _VDropdownState<T>();
}

class _VDropdownState<T> extends State<VDropdown<T>> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _labelForValue(widget.value));
  }

  @override
  void didUpdateWidget(covariant VDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.items != widget.items) {
      _controller.text = _labelForValue(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _labelForValue(T? value) {
    if (value == null) return '';
    final match = widget.items
        .where((item) => item.value == value)
        .map((item) => item.label)
        .toList();
    return match.isEmpty ? value.toString() : match.first;
  }

  Future<void> _openMenu(BuildContext context) async {
    if (!widget.enabled) return;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final box = context.findRenderObject() as RenderBox;
    final topLeft = box.localToGlobal(Offset.zero, ancestor: overlay);
    final menuWidth = box.size.width;
    final position = RelativeRect.fromRect(
      Rect.fromLTWH(
        topLeft.dx,
        topLeft.dy + box.size.height,
        menuWidth,
        box.size.height,
      ),
      Offset.zero & overlay.size,
    );

    final selected = await showMenu<T>(
      context: context,
      position: position,
      constraints: BoxConstraints.tightFor(width: menuWidth),
      items: widget.items
          .map(
            (item) => PopupMenuItem<T>(
              value: item.value,
              child: SizedBox(
                width: menuWidth,
                child: item.child ?? Text(item.label),
              ),
            ),
          )
          .toList(),
    );

    if (selected != null) {
      widget.onChanged?.call(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);
    final borderRadius = context.vRadius.resolveBorderRadius(
      radius: widget.radius,
      radiusValue: widget.radiusValue,
    );

    final border = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: vc.outline),
    );

    final resolvedHeight =
        widget.controlHeight ?? VControlSizes.fieldHeight;
    return SizedBox(
      height: resolvedHeight,
      child: VTextBox(
        controller: _controller,
        label: widget.label,
        hint: widget.hint,
        errorText: widget.errorText,
        showErrorText: widget.showErrorText,
        enabled: widget.enabled,
        readOnly: true,
        filled: widget.filled,
        radius: widget.radius,
        radiusValue: widget.radiusValue,
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        controlHeight: resolvedHeight,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        onTap: () => _openMenu(context),
      ),
    );
  }
}
