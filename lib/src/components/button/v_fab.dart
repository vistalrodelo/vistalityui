import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

class VFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool enabled;

  const VFab({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);
    return FloatingActionButton(
      onPressed: enabled ? onPressed : null,
      tooltip: tooltip,
      backgroundColor: vc.primary,
      foregroundColor: vc.onPrimary,
      child: Icon(icon),
    );
  }
}
