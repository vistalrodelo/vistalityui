import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

/// A themed single-value slider.
class VSlider extends StatelessWidget {
  /// Current slider value.
  final double value;

  /// Called when the value changes.
  final ValueChanged<double>? onChanged;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Optional number of discrete divisions.
  final int? divisions;

  /// Whether the slider is enabled.
  final bool enabled;

  /// Optional active color override for the slider.
  ///
  /// When not provided, the primary color from [VColors] is used.
  final Color? activeColor;

  /// Creates a [VSlider].
  const VSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.enabled = true,
    this.activeColor,
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
      activeColor: activeColor ?? vc.primary,
      inactiveColor: cs.onSurface.withValues(alpha: 0.12),
    );
  }
}
