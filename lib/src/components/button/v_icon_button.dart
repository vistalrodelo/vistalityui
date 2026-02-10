import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

/// A themed icon-only button.
class VIconButton extends StatelessWidget {
  /// Icon to display.
  final IconData icon;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Tooltip shown on long-press/hover.
  final String? tooltip;

  /// Icon size in logical pixels.
  final double size;

  /// Whether the button is enabled.
  final bool enabled;

  /// Optional color override for the icon when enabled.
  ///
  /// When not provided, the primary color from [VColors] is used.
  final Color? color;

  /// Creates a [VIconButton].
  const VIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 24,
    this.enabled = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);
    return IconButton(
      icon: Icon(icon, size: size),
      tooltip: tooltip,
      color: color ?? vc.primary,
      disabledColor: cs.onSurface.withValues(alpha: 0.38),
      onPressed: enabled ? onPressed : null,
    );
  }
}
