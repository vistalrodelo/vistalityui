import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

class VTimelineItem {
  final String title;
  final String subtitle;
  final String? time;

  const VTimelineItem({
    required this.title,
    required this.subtitle,
    this.time,
  });
}

class VTimeline extends StatelessWidget {
  final List<VTimelineItem> items;

  const VTimeline({super.key, required this.items});

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
                    color: vc.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(width: 2, height: 40, color: cs.onSurface.withOpacity(0.12)),
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
