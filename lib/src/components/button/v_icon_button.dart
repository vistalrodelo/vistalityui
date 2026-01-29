import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

class VIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final bool enabled;

  const VIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 24,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);
    return IconButton(
      icon: Icon(icon, size: size),
      tooltip: tooltip,
      color: vc.primary,
      disabledColor: cs.onSurface.withOpacity(0.38),
      onPressed: enabled ? onPressed : null,
    );
  }
}
