// lib/theme/theme.dart
import 'package:flutter/material.dart';
import '../foundation/v_colors.dart';
import '../foundation/v_radius.dart';

/// Builds a Material 3 theme using a seed color, radius defaults, and fonts.
ThemeData buildTheme(
  Color seed, {
  Brightness brightness = Brightness.light,
  Object defaultRadius = VRadiusSize.md,
  String? fontFamily,
  List<String>? fontFamilyFallback,
  String? defaultFontFamily,
  TextTheme Function(TextTheme base)? textThemeBuilder,
}) {
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
  // In light mode, force the seed to be used as the primary color directly.
  // In dark mode, keep the full Material 3 scheme derived from the seed so
  // colors follow the default Material behavior for dark themes.
  final ColorScheme adjustedScheme;
  if (brightness == Brightness.light) {
    final primary = seed;
    final onPrimary =
        primary.computeLuminance() > 0.55 ? Colors.black : Colors.white;
    adjustedScheme = scheme.copyWith(
      primary: primary,
      onPrimary: onPrimary,
    );
  } else {
    adjustedScheme = scheme;
  }
  final vRadius = _buildVRadius(defaultRadius);
  final dialogShape = RoundedRectangleBorder(
    borderRadius: vRadius.defaultBorderRadius(),
  );
  final resolvedFontFamily = fontFamily ?? defaultFontFamily;
  final baseTheme = ThemeData(
    useMaterial3: true,
    colorScheme: adjustedScheme,
    dialogTheme: DialogThemeData(shape: dialogShape),
    datePickerTheme: DatePickerThemeData(shape: dialogShape),
    timePickerTheme: TimePickerThemeData(shape: dialogShape),
    extensions: [
      VColors.fromScheme(adjustedScheme),
      vRadius,
    ],
  );
  ThemeData themed = baseTheme;
  if (resolvedFontFamily != null || fontFamilyFallback != null) {
    themed = themed.copyWith(
      textTheme: themed.textTheme.apply(
        fontFamily: resolvedFontFamily,
        fontFamilyFallback: fontFamilyFallback,
      ),
      primaryTextTheme: themed.primaryTextTheme.apply(
        fontFamily: resolvedFontFamily,
        fontFamilyFallback: fontFamilyFallback,
      ),
    );
  }
  if (textThemeBuilder != null) {
    themed = themed.copyWith(
      textTheme: textThemeBuilder(themed.textTheme),
      primaryTextTheme: textThemeBuilder(themed.primaryTextTheme),
    );
  }
  return themed;
}

VRadius _buildVRadius(Object defaultRadius) {
  if (defaultRadius is num) {
    return VRadius(
      defaultSize: VRadiusSize.md,
      none: 0,
      sm: 6,
      md: defaultRadius.toDouble(),
      lg: 16,
    );
  }
  final size = defaultRadius is VRadiusSize ? defaultRadius : VRadiusSize.md;
  return VRadius(
    defaultSize: size,
    none: 0,
    sm: 6,
    md: 10,
    lg: 16,
  );
}