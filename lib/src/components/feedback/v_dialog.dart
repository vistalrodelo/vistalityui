import 'package:flutter/material.dart';

import '../../foundation/v_intent.dart';
import '../../foundation/v_spacing.dart';
import '../button/v_button.dart';

/// Themed dialogs for confirmation and acknowledgement.
class VDialog {
  const VDialog._();

  /// Shows a confirmation dialog.
  ///
  /// Returns `true` when confirmed, `false` when cancelled, and `null` when
  /// dismissed.
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    VIntent confirmIntent = VIntent.primary,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            VButton(
              label: cancelLabel,
              variant: VButtonVariant.ghost,
              intent: VIntent.secondary,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            VButton(
              label: confirmLabel,
              intent: confirmIntent,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  /// Shows a single-action acknowledgement dialog.
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String message,
    String actionLabel = 'OK',
    VIntent intent = VIntent.info,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Padding(
            padding: const EdgeInsets.only(top: VSpacing.xs),
            child: Text(message),
          ),
          actions: [
            VButton(
              label: actionLabel,
              intent: intent,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
