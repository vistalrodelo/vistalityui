import 'package:flutter/material.dart';

/// Wraps buttons with consistent spacing.
class VButtonGroup extends StatelessWidget {
  /// Buttons or widgets to display in the group.
  final List<Widget> children;

  /// Spacing between buttons.
  final double spacing;

  /// Creates a [VButtonGroup].
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
