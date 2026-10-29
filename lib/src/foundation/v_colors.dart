import 'package:flutter/material.dart';

/// Theme extension that carries custom color roles for Vistality UI.
@immutable
class VColors extends ThemeExtension<VColors> {
  // Instance fields (not static)
  /// Primary brand color.
  final Color primary;

  /// Foreground color on [primary].
  final Color onPrimary;

  /// Container color for primary surfaces.
  final Color primaryContainer;

  /// Foreground color on [primaryContainer].
  final Color onPrimaryContainer;

  /// Secondary color for accents.
  final Color secondary;

  /// Foreground color on [secondary].
  final Color onSecondary;

  /// Tertiary color for accents.
  final Color tertiary;

  /// Foreground color on [tertiary].
  final Color onTertiary;

  /// Surface color for cards and sheets.
  final Color surface;

  /// Foreground color on [surface].
  final Color onSurface;

  /// Background color for app scaffolds.
  final Color background;

  /// Foreground color on [background].
  final Color onBackground;

  /// Outline color for borders.
  final Color outline;

  /// Error color.
  final Color error;

  /// Foreground color on [error].
  final Color onError;

  /// Container color for error surfaces.
  final Color errorContainer;

  /// Foreground color on [errorContainer].
  final Color onErrorContainer;

  /// Success color for positive status.
  final Color success;

  /// Foreground color on [success].
  final Color onSuccess;

  /// Container color for success surfaces.
  final Color successContainer;

  /// Foreground color on [successContainer].
  final Color onSuccessContainer;

  /// Warning color for cautionary status.
  final Color warning;

  /// Foreground color on [warning].
  final Color onWarning;

  /// Container color for warning surfaces.
  final Color warningContainer;

  /// Foreground color on [warningContainer].
  final Color onWarningContainer;

  /// Informational color for neutral status.
  final Color info;

  /// Foreground color on [info].
  final Color onInfo;

  /// Container color for informational surfaces.
  final Color infoContainer;

  /// Foreground color on [infoContainer].
  final Color onInfoContainer;

  /// Creates a [VColors] palette.
  const VColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.onBackground,
    required this.outline,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    this.success = const Color(0xFF15803D),
    this.onSuccess = const Color(0xFFFFFFFF),
    this.successContainer = const Color(0xFFDCFCE7),
    this.onSuccessContainer = const Color(0xFF14532D),
    this.warning = const Color(0xFFB45309),
    this.onWarning = const Color(0xFFFFFFFF),
    this.warningContainer = const Color(0xFFFEF3C7),
    this.onWarningContainer = const Color(0xFF78350F),
    this.info = const Color(0xFF0369A1),
    this.onInfo = const Color(0xFFFFFFFF),
    this.infoContainer = const Color(0xFFE0F2FE),
    this.onInfoContainer = const Color(0xFF0C4A6E),
  });

  /// Creates a [VColors] palette from a [ColorScheme].
  factory VColors.fromScheme(ColorScheme s) {
    final dark = s.brightness == Brightness.dark;
    return VColors(
      primary: s.primary,
      onPrimary: s.onPrimary,
      primaryContainer: s.primaryContainer,
      onPrimaryContainer: s.onPrimaryContainer,
      secondary: s.secondary,
      onSecondary: s.onSecondary,
      tertiary: s.tertiary,
      onTertiary: s.onTertiary,
      surface: s.surface,
      onSurface: s.onSurface,
      background: s.surface,
      onBackground: s.onSurface,
      outline: s.outline,
      error: s.error,
      onError: s.onError,
      errorContainer: s.errorContainer,
      onErrorContainer: s.onErrorContainer,
      success: dark ? const Color(0xFF4ADE80) : const Color(0xFF15803D),
      onSuccess: dark ? const Color(0xFF052E16) : const Color(0xFFFFFFFF),
      successContainer: dark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7),
      onSuccessContainer: dark ? const Color(0xFFDCFCE7) : const Color(0xFF14532D),
      warning: dark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
      onWarning: dark ? const Color(0xFF451A03) : const Color(0xFFFFFFFF),
      warningContainer: dark ? const Color(0xFF78350F) : const Color(0xFFFEF3C7),
      onWarningContainer: dark ? const Color(0xFFFEF3C7) : const Color(0xFF78350F),
      info: dark ? const Color(0xFF38BDF8) : const Color(0xFF0369A1),
      onInfo: dark ? const Color(0xFF082F49) : const Color(0xFFFFFFFF),
      infoContainer: dark ? const Color(0xFF0C4A6E) : const Color(0xFFE0F2FE),
      onInfoContainer: dark ? const Color(0xFFE0F2FE) : const Color(0xFF0C4A6E),
    );
  }

  /// Creates a [VColors] palette from a seed color and brightness.
  static VColors fromSeed(Color seed, Brightness brightness) =>
      VColors.fromScheme(ColorScheme.fromSeed(seedColor: seed, brightness: brightness));

  @override
  VColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? onSecondary,
    Color? tertiary,
    Color? onTertiary,
    Color? surface,
    Color? onSurface,
    Color? background,
    Color? onBackground,
    Color? outline,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
  }) {
    return VColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      outline: outline ?? this.outline,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    );
  }

  @override
  VColors lerp(ThemeExtension<VColors>? other, double t) {
    if (other is! VColors) return this;
    return VColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      onPrimaryContainer: Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      onErrorContainer: Color.lerp(onErrorContainer, other.onErrorContainer, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
    );
  }
}

/// Convenience accessors for [VColors].
extension VColorsX on BuildContext {
  /// Returns the closest [VColors] from the current theme.
  VColors get vColors =>
      Theme.of(this).extension<VColors>() ??
          VColors.fromScheme(Theme.of(this).colorScheme);
}