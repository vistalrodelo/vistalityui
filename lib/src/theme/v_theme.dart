// lib/theme/theme.dart
import 'package:flutter/material.dart';
import '../foundation/v_colors.dart';
import '../foundation/v_radius.dart';

/// Builds a Material 3 theme using a seed color and radius defaults.
ThemeData buildTheme(
  Color seed, {
  Brightness brightness = Brightness.light,
  Object defaultRadius = VRadiusSize.md,
}) {
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
  final primary = seed;
  final onPrimary =
      primary.computeLuminance() > 0.55 ? Colors.black : Colors.white;
  final adjustedScheme = scheme.copyWith(
    primary: primary,
    onPrimary: onPrimary,
  );
  final vRadius = _buildVRadius(defaultRadius);
  final dialogShape = RoundedRectangleBorder(
    borderRadius: vRadius.defaultBorderRadius(),
  );
  return ThemeData(
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