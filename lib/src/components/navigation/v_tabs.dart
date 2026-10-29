import 'package:flutter/material.dart';

import '../../foundation/v_intent.dart';
import '../../foundation/v_intent_colors.dart';
import '../../foundation/v_radius.dart';

/// One page in a [VTabs] control.
class VTabItem {
  /// Tab label.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Content shown when this tab is selected.
  final Widget child;

  /// Creates a [VTabItem].
  const VTabItem({
    required this.label,
    required this.child,
    this.icon,
  });
}

/// Accessible tab list that shows the selected tab's child below the labels.
class VTabs extends StatefulWidget {
  /// Tabs to display. Must not be empty.
  final List<VTabItem> tabs;

  /// Initially selected index.
  final int initialIndex;

  /// Called when the selected index changes.
  final ValueChanged<int>? onChanged;

  /// Creates a [VTabs].
  const VTabs({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onChanged,
  });

  @override
  State<VTabs> createState() => _VTabsState();
}

class _VTabsState extends State<VTabs> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.tabs.isEmpty
        ? 0
        : widget.initialIndex.clamp(0, widget.tabs.length - 1);
  }

  @override
  void didUpdateWidget(VTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabs.isEmpty) {
      _index = 0;
    } else if (_index >= widget.tabs.length) {
      _index = widget.tabs.length - 1;
    }
  }

  void _select(int index) {
    if (index == _index) return;
    setState(() => _index = index);
    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tabs.isEmpty) return const SizedBox.shrink();
    final palette = context.vIntentColors(VIntent.primary);
    final radius = context.vRadius.borderRadius(VRadiusSize.sm);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < widget.tabs.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _TabButton(
                    item: widget.tabs[i],
                    selected: i == _index,
                    radius: radius,
                    palette: palette,
                    onPressed: () => _select(i),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        widget.tabs[_index].child,
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final VTabItem item;
  final bool selected;
  final BorderRadius radius;
  final VIntentColors palette;
  final VoidCallback onPressed;

  const _TabButton({
    required this.item,
    required this.selected,
    required this.radius,
    required this.palette,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: Material(
        color: selected ? palette.container : Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onPressed,
          borderRadius: radius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: selected ? palette.border : scheme.outlineVariant,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.icon != null) ...[
                  Icon(item.icon, size: 18, color: selected ? palette.background : scheme.onSurface),
                  const SizedBox(width: 6),
                ],
                Text(
                  item.label,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? palette.onContainer : scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
