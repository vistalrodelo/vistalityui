import 'package:flutter/material.dart';

import '../../foundation/v_intent.dart';
import '../../foundation/v_intent_colors.dart';
import '../../foundation/v_radius.dart';
import '../../foundation/v_spacing.dart';

/// Inline status message with an intent color, optional actions, and dismiss.
class VAlert extends StatelessWidget {
  /// Short heading.
  final String title;

  /// Supporting message.
  final String? message;

  /// Semantic intent that drives color and the default icon.
  final VIntent intent;

  /// Optional icon override.
  final IconData? icon;

  /// Called when the close button is pressed. Hides the button when null.
  final VoidCallback? onClose;

  /// Optional trailing actions.
  final List<Widget> actions;

  /// Creates a [VAlert].
  const VAlert({
    super.key,
    required this.title,
    this.message,
    this.intent = VIntent.info,
    this.icon,
    this.onClose,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.vIntentColors(intent);
    final radius = context.vRadius.defaultBorderRadius();
    return Semantics(
      container: true,
      liveRegion: true,
      label: message == null ? title : '$title. $message',
      child: Material(
        color: palette.container,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: palette.border.withValues(alpha: 0.45)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(VSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon ?? VIntentColors.iconFor(intent), color: palette.background),
              const SizedBox(width: VSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: palette.onContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (message != null) ...[
                      const SizedBox(height: VSpacing.xs),
                      Text(message!, style: TextStyle(color: palette.onContainer)),
                    ],
                    if (actions.isNotEmpty) ...[
                      const SizedBox(height: VSpacing.sm),
                      Wrap(spacing: VSpacing.sm, runSpacing: VSpacing.sm, children: actions),
                    ],
                  ],
                ),
              ),
              if (onClose != null)
                IconButton(
                  tooltip: 'Dismiss',
                  onPressed: onClose,
                  icon: Icon(Icons.close, color: palette.onContainer),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-width status strip with an optional action.
class VBanner extends StatelessWidget {
  /// Banner message.
  final String message;

  /// Semantic intent that drives color and the default icon.
  final VIntent intent;

  /// Optional icon override.
  final IconData? icon;

  /// Optional action label. Shown only when [onAction] is also set.
  final String? actionLabel;

  /// Called when the action button is pressed.
  final VoidCallback? onAction;

  /// Called when the banner is dismissed. Hides the close button when null.
  final VoidCallback? onClose;

  /// Creates a [VBanner].
  const VBanner({
    super.key,
    required this.message,
    this.intent = VIntent.warning,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.vIntentColors(intent);
    return Material(
      color: palette.container,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: VSpacing.lg, vertical: VSpacing.sm),
        child: Row(
          children: [
            Icon(icon ?? VIntentColors.iconFor(intent), color: palette.background),
            const SizedBox(width: VSpacing.sm),
            Expanded(
              child: Text(message, style: TextStyle(color: palette.onContainer)),
            ),
            if (actionLabel != null && onAction != null)
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
            if (onClose != null)
              IconButton(
                tooltip: 'Dismiss',
                onPressed: onClose,
                icon: Icon(Icons.close, color: palette.onContainer),
              ),
          ],
        ),
      ),
    );
  }
}
