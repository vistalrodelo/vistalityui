import 'package:flutter/material.dart';

import 'v_colors.dart';
import 'v_intent.dart';

/// Foreground, background, and container colors for one [VIntent].
@immutable
class VIntentColors {
  /// Solid fill color.
  final Color background;

  /// Content color drawn on [background].
  final Color foreground;

  /// Border color for outlined treatments.
  final Color border;

  /// Tinted surface used by alerts, banners, and toasts.
  final Color container;

  /// Content color drawn on [container].
  final Color onContainer;

  /// Creates an explicit intent palette.
  const VIntentColors({
    required this.background,
    required this.foreground,
    required this.border,
    required this.container,
    required this.onContainer,
  });

  /// Resolves [intent] from the current theme.
  static VIntentColors resolve(BuildContext context, VIntent intent) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = theme.extension<VColors>() ?? VColors.fromScheme(scheme);
    switch (intent) {
      case VIntent.primary:
        return VIntentColors(
          background: colors.primary,
          foreground: colors.onPrimary,
          border: colors.primary,
          container: colors.primaryContainer,
          onContainer: colors.onPrimaryContainer,
        );
      case VIntent.secondary:
        return VIntentColors(
          background: colors.secondary,
          foreground: colors.onSecondary,
          border: colors.secondary,
          container: scheme.secondaryContainer,
          onContainer: scheme.onSecondaryContainer,
        );
      case VIntent.success:
        return VIntentColors(
          background: colors.success,
          foreground: colors.onSuccess,
          border: colors.success,
          container: colors.successContainer,
          onContainer: colors.onSuccessContainer,
        );
      case VIntent.warning:
        return VIntentColors(
          background: colors.warning,
          foreground: colors.onWarning,
          border: colors.warning,
          container: colors.warningContainer,
          onContainer: colors.onWarningContainer,
        );
      case VIntent.danger:
        return VIntentColors(
          background: colors.error,
          foreground: colors.onError,
          border: colors.error,
          container: colors.errorContainer,
          onContainer: colors.onErrorContainer,
        );
      case VIntent.info:
        return VIntentColors(
          background: colors.info,
          foreground: colors.onInfo,
          border: colors.info,
          container: colors.infoContainer,
          onContainer: colors.onInfoContainer,
        );
    }
  }

  /// Default icon for [intent] when the caller does not supply one.
  static IconData iconFor(VIntent intent) {
    switch (intent) {
      case VIntent.primary:
        return Icons.campaign_outlined;
      case VIntent.secondary:
        return Icons.circle_outlined;
      case VIntent.success:
        return Icons.check_circle_outline;
      case VIntent.warning:
        return Icons.warning_amber_outlined;
      case VIntent.danger:
        return Icons.error_outline;
      case VIntent.info:
        return Icons.info_outline;
    }
  }
}

/// Convenience lookup for [VIntentColors].
extension VIntentColorsX on BuildContext {
  /// Returns the palette for [intent].
  VIntentColors vIntentColors(VIntent intent) => VIntentColors.resolve(this, intent);
}
