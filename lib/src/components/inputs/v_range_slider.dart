import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

class VRangeSlider extends StatelessWidget {
  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final bool enabled;

  const VRangeSlider({
    super.key,
    required this.values,
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

    return RangeSlider(
      values: RangeValues(
        values.start.clamp(min, max),
        values.end.clamp(min, max),
      ),
      min: min,
      max: max,
      divisions: divisions,
      onChanged: enabled ? onChanged : null,
      activeColor: vc.primary,
      inactiveColor: cs.onSurface.withOpacity(0.12),
    );
  }
}
