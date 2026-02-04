import 'package:flutter/material.dart';

/// Expansion panel item data.
class VExpansionItem {
  /// Header text for the panel.
  final String header;

  /// Body widget shown when expanded.
  final Widget body;

  /// Whether the panel is expanded.
  final bool expanded;

  /// Creates a [VExpansionItem].
  const VExpansionItem({
    required this.header,
    required this.body,
    this.expanded = false,
  });
}

/// Expansion panel list built from [VExpansionItem]s.
class VExpansionPanelList extends StatelessWidget {
  /// Items to display.
  final List<VExpansionItem> items;

  /// Called when a panel is toggled.
  final ValueChanged<int>? onToggle;

  /// Creates a [VExpansionPanelList].
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
