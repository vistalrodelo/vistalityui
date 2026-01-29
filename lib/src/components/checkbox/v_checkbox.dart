import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

class VCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final double size;
  final Object? radius;
  final double? radiusValue;

  const VCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.size = 20,
    this.radius,
    this.radiusValue,
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

    final bgColor = value ? vc.primary : Colors.transparent;
    final borderColor = value ? vc.primary : vc.outline;
    final iconColor = vc.onPrimary;

    return InkWell(
      onTap: enabled ? () => onChanged?.call(!value) : null,
      borderRadius: borderRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: enabled ? bgColor : cs.onSurface.withOpacity(0.12),
          border: Border.all(
            color: enabled ? borderColor : cs.onSurface.withOpacity(0.38),
          ),
          borderRadius: borderRadius,
        ),
        child: value
            ? Icon(
                Icons.check,
                size: size * 0.7,
                color: enabled ? iconColor : cs.onSurface.withOpacity(0.38),
              )
            : null,
      ),
    );
  }
}
