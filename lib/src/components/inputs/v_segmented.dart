import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

class VSegmentOption<T> {
  final T value;
  final String label;
  final Widget? child;

  const VSegmentOption({
    required this.value,
    required this.label,
    this.child,
  });
}

class VSegmented<T> extends StatelessWidget {
  final T value;
  final ValueChanged<T>? onChanged;
  final List<VSegmentOption<T>> options;
  final bool enabled;

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
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return vc.primary;
          return cs.surface;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return vc.onPrimary;
          return cs.onSurface;
        }),
        side: MaterialStateProperty.all(BorderSide(color: vc.outline)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: context.vRadius.defaultBorderRadius(),
          ),
        ),
      ),
    );
  }
}
