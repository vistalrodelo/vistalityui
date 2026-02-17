import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

/// Floating action button with themed colors.
class VFab extends StatelessWidget {
  /// Icon displayed in the FAB.
  final IconData icon;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Tooltip shown on long-press/hover.
  final String? tooltip;

  /// Whether the button is enabled.
  final bool enabled;

  /// Optional background color override.
  ///
  /// When not provided, the primary color from [VColors] is used.
  final Color? backgroundColor;

  /// Optional foreground (icon) color override.
  ///
  /// When not provided, the onPrimary color from [VColors] is used.
  final Color? foregroundColor;

  /// Radius token or identifier resolved by [VRadius].
  final Object? radius;

  /// Explicit radius override when not using a token.
  final double? radiusValue;

  /// Creates a [VFab].
  const VFab({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.enabled = true,
    this.backgroundColor,
    this.foregroundColor,
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
    return FloatingActionButton(
      onPressed: enabled ? onPressed : null,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? vc.primary,
      foregroundColor: foregroundColor ?? vc.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: Icon(icon),
    );
  }
}
