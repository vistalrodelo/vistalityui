import 'package:flutter/material.dart';

/// Type-scale accessors backed by the active [TextTheme].
class VTypography {
  const VTypography._();

  /// Display style used for page titles.
  static TextStyle? display(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall;

  /// Section heading style.
  static TextStyle? heading(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium;

  /// Body copy style.
  static TextStyle? body(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium;

  /// Compact label style.
  static TextStyle? label(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge;

  /// Secondary caption style.
  static TextStyle? caption(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall;
}
