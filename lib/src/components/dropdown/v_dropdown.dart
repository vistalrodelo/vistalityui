import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

class VDropdownItem<T> {
  final T value;
  final String label;
  final Widget? child;

  const VDropdownItem({
    required this.value,
    required this.label,
    this.child,
  });
}

class VDropdown<T> extends StatelessWidget {
  final List<VDropdownItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;

  final String? label;
  final String? hint;
  final String? errorText;

  final bool enabled;
  final bool filled;
  final Object? radius;
  final double? radiusValue;
  final EdgeInsetsGeometry? contentPadding;

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
      value: value,
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
        fillColor: enabled ? cs.surface : cs.surface.withOpacity(0.4),
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
