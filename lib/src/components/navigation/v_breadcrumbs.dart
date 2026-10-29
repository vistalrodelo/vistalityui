import 'package:flutter/material.dart';

/// One segment in a [VBreadcrumbs] trail.
class VBreadcrumbItem {
  /// Visible label.
  final String label;

  /// Called when the crumb is tapped. The current page usually leaves this null.
  final VoidCallback? onTap;

  /// Creates a [VBreadcrumbItem].
  const VBreadcrumbItem({required this.label, this.onTap});
}

/// Horizontal trail of tappable ancestors and a current page.
class VBreadcrumbs extends StatelessWidget {
  /// Crumbs from the root to the current page.
  final List<VBreadcrumbItem> items;

  /// Creates a [VBreadcrumbs].
  const VBreadcrumbs({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final last = i == items.length - 1;
      children.add(
        item.onTap == null || last
            ? Text(
                item.label,
                style: TextStyle(
                  fontWeight: last ? FontWeight.w700 : FontWeight.w500,
                  color: last ? scheme.onSurface : scheme.onSurfaceVariant,
                ),
              )
            : InkWell(
                onTap: item.onTap,
                child: Text(
                  item.label,
                  style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600),
                ),
              ),
      );
      if (!last) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(Icons.chevron_right, size: 18, color: scheme.onSurfaceVariant),
          ),
        );
      }
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}
