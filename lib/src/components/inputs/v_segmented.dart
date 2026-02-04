import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

/// Segment option definition for [VSegmented].
class VSegmentOption<T> {
  /// Underlying value for the segment.
  final T value;

  /// Label text shown when [child] is not provided.
  final String label;

  /// Optional custom widget for the segment.
  final Widget? child;

  /// Creates a [VSegmentOption].
  const VSegmentOption({
    required this.value,
    required this.label,
    this.child,
  });
}

/// Segmented control for choosing one option.
class VSegmented<T> extends StatelessWidget {
  /// Currently selected value.
  final T value;

  /// Called when a segment is selected.
  final ValueChanged<T>? onChanged;

  /// Options to display.
  final List<VSegmentOption<T>> options;

  /// Whether the control is enabled.
  final bool enabled;

  /// Creates a [VSegmented].
  const VSegmented({
    super.key,
    required this.value,
    required this.onChanged,
    required this.options,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);

    return SegmentedButton<T>(
      segments: options
          .map(
            (opt) => ButtonSegment<T>(
              value: opt.value,
              label: opt.child ?? Text(opt.label),
            ),
          )
          .toList(),
      selected: {value},
      onSelectionChanged: enabled
          ? (values) {
              if (values.isNotEmpty) onChanged?.call(values.first);
            }
          : null,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return vc.primary;
          return cs.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return vc.onPrimary;
          return cs.onSurface;
        }),
        side: WidgetStateProperty.all(BorderSide(color: vc.outline)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: context.vRadius.defaultBorderRadius(),
          ),
        ),
      ),
    );
  }
}
