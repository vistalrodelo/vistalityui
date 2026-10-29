import 'package:flutter/material.dart';

import '../../foundation/v_intent.dart';
import '../../foundation/v_intent_colors.dart';

/// Floating status message shown through the nearest [ScaffoldMessenger].
class VToast {
  const VToast._();

  /// Shows [message] as a floating snack bar colored by [intent].
  static void show(
    BuildContext context, {
    required String message,
    VIntent intent = VIntent.info,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final palette = VIntentColors.resolve(context, intent);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: palette.container,
        content: Row(
          children: [
            Icon(VIntentColors.iconFor(intent), color: palette.background),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message, style: TextStyle(color: palette.onContainer)),
            ),
          ],
        ),
        action: actionLabel == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                textColor: palette.background,
                onPressed: onAction ?? () {},
              ),
      ),
    );
  }
}
