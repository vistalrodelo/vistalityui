import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

/// Star rating control.
class VRating extends StatelessWidget {
  /// Current rating value.
  final int value;

  /// Called when the rating changes.
  final ValueChanged<int>? onChanged;

  /// Maximum rating value.
  final int max;

  /// Icon size.
  final double size;

  /// Whether the control is enabled.
  final bool enabled;

  /// Creates a [VRating].
  const VRating({
    super.key,
    required this.value,
    required this.onChanged,
    this.max = 5,
    this.size = 24,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max, (index) {
        final filled = index < value;
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tightFor(width: size, height: size),
          icon: Icon(
            filled ? Icons.star : Icons.star_border,
            size: size,
            color: filled ? vc.primary : cs.onSurface.withValues(alpha: 0.4),
          ),
          onPressed: enabled ? () => onChanged?.call(index + 1) : null,
        );
      }),
    );
  }
}
