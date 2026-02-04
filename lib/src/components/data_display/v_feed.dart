import 'package:flutter/material.dart';

/// Feed item data for [VFeed].
class VFeedItem {
  /// Item title.
  final String title;

  /// Item body text.
  final String body;

  /// Optional time label.
  final String? time;

  /// Creates a [VFeedItem].
  const VFeedItem({
    required this.title,
    required this.body,
    this.time,
  });
}

/// Simple feed list built with [ListTile].
class VFeed extends StatelessWidget {
  /// Items to display in the feed.
  final List<VFeedItem> items;

  /// Creates a [VFeed].
  const VFeed({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.title),
          subtitle: Text(item.body),
          trailing: item.time == null ? null : Text(item.time!),
        );
      },
    );
  }
}
