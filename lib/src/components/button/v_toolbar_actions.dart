import 'package:flutter/material.dart';
import 'v_overflow_menu.dart';

/// Horizontal toolbar row with optional overflow actions.
class VToolbarActions extends StatelessWidget {
  /// Primary action widgets to display.
  final List<Widget> actions;

  /// Spacing between actions.
  final double spacing;

  /// Alignment for the row.
  final MainAxisAlignment alignment;

  /// Optional overflow items appended at the end.
  final List<VOverflowItem>? overflowItems;

  /// Creates a [VToolbarActions] row.
  const VToolbarActions({
    super.key,
    required this.actions,
    this.spacing = 8,
    this.alignment = MainAxisAlignment.start,
    this.overflowItems,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < actions.length; i++) {
      children.add(actions[i]);
      if (i != actions.length - 1) {
        children.add(SizedBox(width: spacing));
      }
    }
    if (overflowItems != null && overflowItems!.isNotEmpty) {
      if (children.isNotEmpty) children.add(SizedBox(width: spacing));
      children.add(VOverflowMenu(items: overflowItems!));
    }

    return Row(
      mainAxisAlignment: alignment,
      children: children,
    );
  }
}
