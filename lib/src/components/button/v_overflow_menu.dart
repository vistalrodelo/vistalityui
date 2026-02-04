import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

/// Item definition for [VOverflowMenu].
class VOverflowItem {
  /// Label shown in the overflow menu.
  final String label;

  /// Called when this item is selected.
  final VoidCallback? onSelected;

  /// Creates a [VOverflowItem].
  const VOverflowItem({required this.label, this.onSelected});
}

/// Overflow menu with a list of selectable items.
class VOverflowMenu extends StatelessWidget {
  /// Menu items to display.
  final List<VOverflowItem> items;

  /// Creates a [VOverflowMenu].
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
