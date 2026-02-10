import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_intent.dart';
import 'v_button.dart';

/// Resolved colors for a [VButton] variant and intent.
class VButtonStyle {
  /// Background color for the button.
  final Color background;

  /// Foreground (text/icon) color for the button.
  final Color foreground;

  /// Border color for the button.
  final Color border;

  /// Creates a [VButtonStyle] with explicit colors.
  const VButtonStyle({
    required this.background,
    required this.foreground,
    required this.border,
  });

  /// Resolves a [VButtonStyle] based on intent, variant, and state.
  static VButtonStyle resolve({
    required BuildContext context,
    required VIntent intent,
    required VButtonVariant variant,
    required bool enabled,
    Color? backgroundOverride,
    Color? foregroundOverride,
    Color? borderOverride,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);

    if (!enabled) {
      final disabledBackground = cs.onSurface.withValues(alpha: 0.12);
      final disabledForeground = cs.onSurface.withValues(alpha: 0.38);
      final disabledBorder = cs.onSurface.withValues(alpha: 0.12);

      return VButtonStyle(
        background: backgroundOverride ?? disabledBackground,
        foreground: foregroundOverride ?? disabledForeground,
        border: borderOverride ?? disabledBorder,
      );
    }

    final base = () {
      switch (intent) {
        case VIntent.primary:
          return VButtonStyle(
            background: vc.primary,
            foreground: vc.onPrimary,
            border: vc.primary,
          );
        case VIntent.secondary:
          return VButtonStyle(
            background: vc.secondary,
            foreground: vc.onSecondary,
            border: vc.secondary,
          );
        case VIntent.success:
          return VButtonStyle(
            background: vc.tertiary,
            foreground: vc.onTertiary,
            border: vc.tertiary,
          );
        case VIntent.warning:
          return VButtonStyle(
            background: cs.secondaryContainer,
            foreground: cs.onSecondaryContainer,
            border: cs.secondaryContainer,
          );
        case VIntent.danger:
          return VButtonStyle(
            background: vc.error,
            foreground: vc.onError,
            border: vc.error,
          );
      }
    }();

    final resolved = () {
      switch (variant) {
        case VButtonVariant.solid:
          return base;
        case VButtonVariant.ghost:
          return VButtonStyle(
            background: Colors.transparent,
            foreground: base.background,
            border: base.border,
          );
        case VButtonVariant.text:
          return VButtonStyle(
            background: Colors.transparent,
            foreground: base.background,
            border: Colors.transparent,
          );
      }
    }();

    return VButtonStyle(
      background: backgroundOverride ?? resolved.background,
      foreground: foregroundOverride ?? resolved.foreground,
      border: borderOverride ?? resolved.border,
    );
  }
}
