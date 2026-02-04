import 'package:flutter/material.dart';

/// GridView with configurable columns and spacing.
class VGridView extends StatelessWidget {
  /// Widgets to display.
  final List<Widget> children;

  /// Number of columns.
  final int columns;

  /// Spacing between columns.
  final double spacing;

  /// Spacing between rows.
  final double runSpacing;

  /// Aspect ratio for grid children.
  final double childAspectRatio;

  /// Scroll physics for the grid.
  final ScrollPhysics? physics;

  /// Whether the grid shrinks to fit content.
  final bool shrinkWrap;

  /// Creates a [VGridView].
  const VGridView({
    super.key,
    required this.children,
    this.columns = 2,
    this.spacing = 12,
    this.runSpacing = 12,
    this.childAspectRatio = 1,
    this.physics,
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: runSpacing,
      childAspectRatio: childAspectRatio,
      physics: physics,
      shrinkWrap: shrinkWrap,
      children: children,
    );
  }
}
