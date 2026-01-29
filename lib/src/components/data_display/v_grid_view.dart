import 'package:flutter/material.dart';

class VGridView extends StatelessWidget {
  final List<Widget> children;
  final int columns;
  final double spacing;
  final double runSpacing;
  final double childAspectRatio;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

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
