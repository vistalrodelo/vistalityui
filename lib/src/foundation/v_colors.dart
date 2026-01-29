import 'package:flutter/material.dart';

@immutable
class VColors extends ThemeExtension<VColors> {
  // Instance fields (not static)
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  final Color secondary;
  final Color onSecondary;
  final Color tertiary;
  final Color onTertiary;

  final Color surface;
  final Color onSurface;
  final Color background;
  final Color onBackground;
  final Color outline;

  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;

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
  });

  factory VColors.fromScheme(ColorScheme s) => VColors(
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
    background: s.background,
    onBackground: s.onSurface,
    outline: s.outline,
    error: s.error,
    onError: s.onError,
    errorContainer: s.errorContainer,
    onErrorContainer: s.onErrorContainer,
  );

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
    );
  }
}

extension VColorsX on BuildContext {
  VColors get vColors =>
      Theme.of(this).extension<VColors>() ??
          VColors.fromScheme(Theme.of(this).colorScheme);
}