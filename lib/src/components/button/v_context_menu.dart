import 'package:flutter/material.dart';

/// Item definition for [VContextMenu].
class VContextMenuItem {
  /// Label shown in the context menu.
  final String label;

  /// Called when this item is selected.
  final VoidCallback? onSelected;

  /// Creates a [VContextMenuItem].
  const VContextMenuItem({required this.label, this.onSelected});
}

/// Wraps a child and shows a context menu on right click/long press.
class VContextMenu extends StatelessWidget {
  /// Widget that triggers the context menu.
  final Widget child;

  /// Menu items to display.
  final List<VContextMenuItem> items;

  /// Creates a [VContextMenu].
  const VContextMenu({
    super.key,
    required this.child,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) {
        _showMenu(context, details.globalPosition);
      },
      onLongPressStart: (details) {
        _showMenu(context, details.globalPosition);
      },
      child: child,
    );
  }

  void _showMenu(BuildContext context, Offset position) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu<int>(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: List.generate(items.length, (index) {
        final item = items[index];
        return PopupMenuItem<int>(
          value: index,
          child: Text(item.label),
        );
      }),
    ).then((selected) {
      if (selected == null) return;
      items[selected].onSelected?.call();
    });
  }
}
