import 'package:flutter/material.dart';

class VButtonGroup extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const VButtonGroup({
    super.key,
    required this.children,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: children,
    );
  }
}
