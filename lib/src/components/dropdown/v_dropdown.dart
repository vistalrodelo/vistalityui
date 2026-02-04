import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

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
class VDropdown<T> extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);
    final borderRadius = context.vRadius.resolveBorderRadius(
      radius: radius,
      radiusValue: radiusValue,
    );

    final border = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: vc.outline),
    );

    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item.value,
              child: item.child ?? Text(item.label),
            ),
          )
          .toList(),
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        isDense: true,
        filled: filled,
        fillColor: enabled ? cs.surface : cs.surface.withValues(alpha: 0.4),
        contentPadding:
            contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: vc.primary, width: 2),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: vc.error),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: vc.error, width: 2),
        ),
      ),
    );
  }
}
