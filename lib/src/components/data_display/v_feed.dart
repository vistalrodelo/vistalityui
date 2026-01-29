import 'package:flutter/material.dart';

class VFeedItem {
  final String title;
  final String body;
  final String? time;

  const VFeedItem({
    required this.title,
    required this.body,
    this.time,
  });
}

class VFeed extends StatelessWidget {
  final List<VFeedItem> items;

  const VFeed({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
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
