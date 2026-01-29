import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

class VChip extends StatelessWidget {
  final String label;
  final VoidCallback? onDeleted;

  const VChip({
    super.key,
    required this.label,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border.all(color: vc.outline),
        borderRadius: context.vRadius.borderRadius(VRadiusSize.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (onDeleted != null) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onDeleted,
              child: const Icon(Icons.close, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}
