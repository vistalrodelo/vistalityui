import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

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

  /// Creates a [VFab].
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
