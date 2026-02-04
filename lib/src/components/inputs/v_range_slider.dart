import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

/// A themed range slider with two handles.
class VRangeSlider extends StatelessWidget {
  /// Current range values.
  final RangeValues values;

  /// Called when the range changes.
  final ValueChanged<RangeValues>? onChanged;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Optional number of discrete divisions.
  final int? divisions;

  /// Whether the slider is enabled.
  final bool enabled;

  /// Creates a [VRangeSlider].
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
      inactiveColor: cs.onSurface.withValues(alpha: 0.12),
    );
  }
}
