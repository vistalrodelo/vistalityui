import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

class VSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final String? label;
  final Widget? child;

  const VSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.label,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);

    final switcher = Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: vc.primary,
      inactiveThumbColor: cs.onSurface.withOpacity(0.4),
      inactiveTrackColor: cs.onSurface.withOpacity(0.12),
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
