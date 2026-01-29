import 'package:flutter/material.dart';

class VContextMenuItem {
  final String label;
  final VoidCallback? onSelected;

  const VContextMenuItem({required this.label, this.onSelected});
}

class VContextMenu extends StatelessWidget {
  final Widget child;
  final List<VContextMenuItem> items;

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
