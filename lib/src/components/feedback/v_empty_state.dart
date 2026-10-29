import 'package:flutter/material.dart';

import '../../foundation/v_spacing.dart';
import '../button/v_button.dart';

/// Placeholder for a list, search, or page with no content.
class VEmptyState extends StatelessWidget {
  /// Short heading.
  final String title;

  /// Supporting explanation.
  final String? message;

  /// Icon shown above the title.
  final IconData icon;

  /// Optional action button label.
  final String? actionLabel;

  /// Called when the action button is pressed.
  final VoidCallback? onAction;

  /// Creates a [VEmptyState].
  const VEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(VSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: scheme.onSurfaceVariant),
          const SizedBox(height: VSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (message != null) ...[
            const SizedBox(height: VSpacing.xs),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: VSpacing.lg),
            VButton(label: actionLabel!, onPressed: onAction),
          ],
        ],
      ),
    );
  }
}
