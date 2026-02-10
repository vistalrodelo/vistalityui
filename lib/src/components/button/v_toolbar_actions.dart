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

  /// Optional color override applied to the overflow menu icon.
  ///
  /// When not provided, the primary color from [VColors] is used.
  final Color? overflowColor;

  /// Creates a [VToolbarActions] row.
  const VToolbarActions({
    super.key,
    required this.actions,
    this.spacing = 8,
    this.alignment = MainAxisAlignment.start,
    this.overflowItems,
    this.overflowColor,
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
      children.add(
        VOverflowMenu(
          items: overflowItems!,
          iconColor: overflowColor,
        ),
      );
    }

    return Row(
      mainAxisAlignment: alignment,
      children: children,
    );
  }
}
