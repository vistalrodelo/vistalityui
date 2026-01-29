import 'package:flutter/material.dart';

class VExpansionItem {
  final String header;
  final Widget body;
  final bool expanded;

  const VExpansionItem({
    required this.header,
    required this.body,
    this.expanded = false,
  });
}

class VExpansionPanelList extends StatelessWidget {
  final List<VExpansionItem> items;
  final ValueChanged<int>? onToggle;

  const VExpansionPanelList({
    super.key,
    required this.items,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) => onToggle?.call(index),
      children: List.generate(items.length, (index) {
        final item = items[index];
        return ExpansionPanel(
          isExpanded: item.expanded,
          headerBuilder: (context, _) => ListTile(title: Text(item.header)),
          body: item.body,
        );
      }),
    );
  }
}
