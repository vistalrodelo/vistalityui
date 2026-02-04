import 'package:flutter/material.dart';

/// ListView with consistent spacing between items.
class VListView extends StatelessWidget {
  /// Widgets to display.
  final List<Widget> children;

  /// Spacing between items.
  final double spacing;

  /// Scroll physics for the list.
  final ScrollPhysics? physics;

  /// Whether the list shrinks to fit content.
  final bool shrinkWrap;

  /// Creates a [VListView].
  const VListView({
    super.key,
    required this.children,
    this.spacing = 8,
    this.physics,
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: children.length,
      separatorBuilder: (_, _) => SizedBox(height: spacing),
      itemBuilder: (_, index) => children[index],
    );
  }
}
