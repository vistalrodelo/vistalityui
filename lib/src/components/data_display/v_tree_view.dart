import 'package:flutter/material.dart';

/// Tree node model for [VTreeView].
class VTreeNode {
  /// Node label text.
  final String label;

  /// Child nodes.
  final List<VTreeNode> children;

  /// Whether the node is expanded.
  final bool expanded;

  /// Creates a [VTreeNode].
  const VTreeNode({
    required this.label,
    this.children = const [],
    this.expanded = true,
  });
}

/// Read-only tree view for nested data.
class VTreeView extends StatelessWidget {
  /// Root nodes to display.
  final List<VTreeNode> nodes;

  /// Indent size per depth level.
  final double indent;

  /// Creates a [VTreeView].
  const VTreeView({
    super.key,
    required this.nodes,
    this.indent = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: _buildNodes(nodes, 0));
  }

  List<Widget> _buildNodes(List<VTreeNode> nodes, int depth) {
    final widgets = <Widget>[];
    for (final node in nodes) {
      widgets.add(Padding(
        padding: EdgeInsets.only(left: depth * indent.toDouble(), bottom: 6),
        child: Row(
          children: [
            if (node.children.isNotEmpty)
              Icon(node.expanded ? Icons.expand_more : Icons.chevron_right, size: 16),
            if (node.children.isNotEmpty) const SizedBox(width: 4),
            Text(node.label),
          ],
        ),
      ));
      if (node.expanded && node.children.isNotEmpty) {
        widgets.addAll(_buildNodes(node.children, depth + 1));
      }
    }
    return widgets;
  }
}
