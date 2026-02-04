import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

/// A styled accordion built on top of `ExpansionTile`.
class VAccordion extends StatelessWidget {
  /// Header text shown in the accordion tile.
  final String title;

  /// The widget displayed when the accordion is expanded.
  final Widget child;

  /// Whether the accordion starts expanded.
  final bool initiallyExpanded;

  /// Optional leading widget shown before the title.
  final Widget? leading;

  /// Creates a [VAccordion] with a title and expandable content.
  const VAccordion({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);
    final radius = context.vRadius.defaultBorderRadius();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: vc.outline),
        borderRadius: radius,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: ExpansionTile(
          leading: leading,
          title: Text(title),
          initiallyExpanded: initiallyExpanded,
          collapsedBackgroundColor: cs.surface,
          backgroundColor: cs.surface,
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          children: [child],
        ),
      ),
    );
  }
}
