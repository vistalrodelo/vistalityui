import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

/// Timeline item data for [VTimeline].
class VTimelineItem {
  /// Item title.
  final String title;

  /// Item subtitle.
  final String subtitle;

  /// Optional time label.
  final String? time;

  /// Creates a [VTimelineItem].
  const VTimelineItem({
    required this.title,
    required this.subtitle,
    this.time,
  });
}

/// Vertical timeline layout.
class VTimeline extends StatelessWidget {
  /// Items to display in the timeline.
  final List<VTimelineItem> items;

  /// Optional color override for the timeline indicator.
  ///
  /// When not provided, the primary color from [VColors] is used.
  final Color? accentColor;

  /// Creates a [VTimeline].
  const VTimeline({
    super.key,
    required this.items,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);

    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: accentColor ?? vc.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(width: 2, height: 40, color: cs.onSurface.withValues(alpha: 0.12)),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: theme.textTheme.titleSmall),
                    Text(item.subtitle, style: theme.textTheme.bodySmall),
                    if (item.time != null)
                      Text(item.time!, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
