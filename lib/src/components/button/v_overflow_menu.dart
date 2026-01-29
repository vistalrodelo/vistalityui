import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

class VOverflowItem {
  final String label;
  final VoidCallback? onSelected;

  const VOverflowItem({required this.label, this.onSelected});
}

class VOverflowMenu extends StatelessWidget {
  final List<VOverflowItem> items;

  const VOverflowMenu({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);

    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color: vc.primary),
      itemBuilder: (context) {
        return List.generate(items.length, (index) {
          final item = items[index];
          return PopupMenuItem<int>(
            value: index,
            child: Text(item.label),
          );
        });
      },
      onSelected: (index) {
        items[index].onSelected?.call();
      },
    );
  }
}
