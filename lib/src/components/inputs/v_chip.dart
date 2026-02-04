import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

/// A small labeled chip with optional delete action.
enum VChipSize {
  /// Compact chip size.
  sm,

  /// Default chip size.
  md,
}

/// A small labeled chip with optional delete action.
class VChip extends StatelessWidget {
  /// Chip label text.
  final String label;

  /// Called when the delete icon is tapped.
  final VoidCallback? onDeleted;

  /// Size variant for the chip.
  final VChipSize size;

  /// Creates a [VChip].
  const VChip({
    super.key,
    required this.label,
    this.onDeleted,
    this.size = VChipSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);

    final padding = size == VChipSize.sm
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
    final iconSize = size == VChipSize.sm ? 14.0 : 16.0;
    final textStyle = size == VChipSize.sm
        ? theme.textTheme.bodySmall
        : theme.textTheme.bodyMedium;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border.all(color: vc.outline),
        borderRadius: context.vRadius.borderRadius(VRadiusSize.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: textStyle),
          if (onDeleted != null) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onDeleted,
              child: Icon(Icons.close, size: iconSize),
            ),
          ],
        ],
      ),
    );
  }
}
