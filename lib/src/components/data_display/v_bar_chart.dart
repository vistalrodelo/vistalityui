import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundation/v_intent.dart';
import '../../foundation/v_intent_colors.dart';
import '../../foundation/v_spacing.dart';

/// One bar in a [VBarChart].
class VBarChartItem {
  /// Category label drawn under the bar.
  final String label;

  /// Non-negative bar value.
  final double value;

  /// Optional bar color. Defaults to the chart intent color.
  final Color? color;

  /// Creates a [VBarChartItem].
  const VBarChartItem({
    required this.label,
    required this.value,
    this.color,
  });
}

/// Compact horizontal bar chart with no extra dependencies.
class VBarChart extends StatelessWidget {
  /// Bars to draw.
  final List<VBarChartItem> items;

  /// Chart height, including labels.
  final double height;

  /// Intent used when an item does not set [VBarChartItem.color].
  final VIntent intent;

  /// Creates a [VBarChart].
  const VBarChart({
    super.key,
    required this.items,
    this.height = 180,
    this.intent = VIntent.primary,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(child: Text('No data')),
      );
    }
    final palette = context.vIntentColors(intent);
    final maxValue = items.fold<double>(0, (max, item) => math.max(max, item.value));
    final scale = maxValue <= 0 ? 1.0 : maxValue;
    return Semantics(
      label: 'Bar chart',
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final item in items)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: VSpacing.xs),
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor: (item.value / scale).clamp(0.0, 1.0),
                            widthFactor: 0.62,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: item.color ?? palette.background,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: VSpacing.xs),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
