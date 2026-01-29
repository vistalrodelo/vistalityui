import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

class VSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final bool enabled;

  const VSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);

    return Slider(
      value: value.clamp(min, max),
      min: min,
      max: max,
      divisions: divisions,
      onChanged: enabled ? onChanged : null,
      activeColor: vc.primary,
      inactiveColor: cs.onSurface.withOpacity(0.12),
    );
  }
}
