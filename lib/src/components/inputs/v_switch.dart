import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

/// A themed switch with optional label.
class VSwitch extends StatelessWidget {
  /// Current switch value.
  final bool value;

  /// Called when the switch toggles.
  final ValueChanged<bool>? onChanged;

  /// Whether the switch is enabled.
  final bool enabled;

  /// Optional label text.
  final String? label;

  /// Optional custom label widget.
  final Widget? child;

  /// Optional active thumb color override.
  ///
  /// When not provided, the primary color from [VColors] is used.
  final Color? activeColor;

  /// Creates a [VSwitch].
  const VSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.label,
    this.child,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);

    final switcher = Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeThumbColor: activeColor ?? vc.primary,
      inactiveThumbColor: cs.onSurface.withValues(alpha: 0.4),
      inactiveTrackColor: cs.onSurface.withValues(alpha: 0.12),
    );

    final labelWidget = child ?? (label != null ? Text(label!) : null);
    if (labelWidget == null) return switcher;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        switcher,
        const SizedBox(width: 8),
        labelWidget,
      ],
    );
  }
}
