import 'package:flutter/material.dart';

class VListView extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

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
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (_, index) => children[index],
    );
  }
}
