import 'package:flutter/material.dart';

import '../../foundation/v_intent.dart';
import '../../foundation/v_intent_colors.dart';

/// Page control for a known number of pages.
///
/// [page] and [pageCount] are 1-based.
class VPagination extends StatelessWidget {
  /// Current page, starting at 1.
  final int page;

  /// Total number of pages. Must be at least 1.
  final int pageCount;

  /// Called with the newly selected 1-based page.
  final ValueChanged<int>? onPageChanged;

  /// Creates a [VPagination].
  const VPagination({
    super.key,
    required this.page,
    required this.pageCount,
    this.onPageChanged,
  }) : assert(pageCount >= 1, 'pageCount must be at least 1'),
       assert(page >= 1 && page <= pageCount, 'page must be within pageCount');

  @override
  Widget build(BuildContext context) {
    final palette = context.vIntentColors(VIntent.primary);
    final pages = _window(page, pageCount);
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _PageButton(
          icon: Icons.chevron_left,
          tooltip: 'Previous page',
          enabled: page > 1 && onPageChanged != null,
          onPressed: () => onPageChanged?.call(page - 1),
        ),
        for (final entry in pages)
          if (entry == null)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('…'),
            )
          else
            _PageButton(
              label: '$entry',
              selected: entry == page,
              palette: palette,
              enabled: onPageChanged != null,
              onPressed: () => onPageChanged?.call(entry),
            ),
        _PageButton(
          icon: Icons.chevron_right,
          tooltip: 'Next page',
          enabled: page < pageCount && onPageChanged != null,
          onPressed: () => onPageChanged?.call(page + 1),
        ),
      ],
    );
  }
}

List<int?> _window(int page, int pageCount) {
  if (pageCount <= 7) {
    return [for (var i = 1; i <= pageCount; i++) i];
  }
  final pages = <int?>[1];
  var start = page - 1;
  var end = page + 1;
  if (page <= 3) {
    start = 2;
    end = 4;
  } else if (page >= pageCount - 2) {
    start = pageCount - 3;
    end = pageCount - 1;
  }
  if (start > 2) pages.add(null);
  for (var i = start; i <= end; i++) {
    pages.add(i);
  }
  if (end < pageCount - 1) pages.add(null);
  pages.add(pageCount);
  return pages;
}

class _PageButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String? tooltip;
  final bool selected;
  final bool enabled;
  final VIntentColors? palette;
  final VoidCallback onPressed;

  const _PageButton({
    this.label,
    this.icon,
    this.tooltip,
    this.selected = false,
    required this.enabled,
    this.palette,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = selected ? palette!.background : Colors.transparent;
    final foreground = selected ? palette!.foreground : scheme.onSurface;
    final button = IconButton(
      tooltip: tooltip ?? (label == null ? null : 'Page $label'),
      onPressed: enabled ? onPressed : null,
      style: IconButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
        minimumSize: const Size(36, 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: icon != null ? Icon(icon, size: 18) : Text(label!),
    );
    return button;
  }
}
