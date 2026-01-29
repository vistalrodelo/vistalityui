import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

class VAccordion extends StatelessWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final Widget? leading;

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
