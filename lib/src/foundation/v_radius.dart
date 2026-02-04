import 'dart:ui';

import 'package:flutter/material.dart';

/// Supported radius sizes for rounded corners.
enum VRadiusSize {
  /// No rounding.
  none,

  /// Small radius.
  sm,

  /// Medium radius.
  md,

  /// Large radius.
  lg,
}

/// Theme extension for standard corner radii.
@immutable
class VRadius extends ThemeExtension<VRadius> {
  /// Default radius size token.
  final VRadiusSize defaultSize;

  /// Radius value for [VRadiusSize.none].
  final double none;

  /// Radius value for [VRadiusSize.sm].
  final double sm;

  /// Radius value for [VRadiusSize.md].
  final double md;

  /// Radius value for [VRadiusSize.lg].
  final double lg;

  /// Creates a [VRadius] set with explicit values.
  const VRadius({
    required this.defaultSize,
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
  });

  /// Returns the default radius values.
  factory VRadius.defaults() => const VRadius(
    defaultSize: VRadiusSize.md,
    none: 0,
    sm: 6,
    md: 10,
    lg: 16,
  );

  /// Resolves a numeric radius for a given [VRadiusSize].
  double value(VRadiusSize size) {
    switch (size) {
      case VRadiusSize.none:
        return none;
      case VRadiusSize.sm:
        return sm;
      case VRadiusSize.md:
        return md;
      case VRadiusSize.lg:
        return lg;
    }
  }

  /// Creates a border radius for the given size.
  BorderRadius borderRadius(VRadiusSize size) => BorderRadius.circular(value(size));

  /// Creates a border radius for the default size.
  BorderRadius defaultBorderRadius() => borderRadius(defaultSize);

  /// Creates a border radius for an explicit radius value.
  BorderRadius borderRadiusValue(double radius) => BorderRadius.circular(radius);

  /// Resolves a border radius from a token or explicit value.
  BorderRadius resolveBorderRadius({
    Object? radius,
    double? radiusValue,
  }) {
    if (radiusValue != null) {
      return borderRadiusValue(radiusValue);
    }
    if (radius is VRadiusSize) {
      return borderRadius(radius);
    }
    if (radius is num) {
      return borderRadiusValue(radius.toDouble());
    }
    return defaultBorderRadius();
  }

  @override
  VRadius copyWith({
    VRadiusSize? defaultSize,
    double? none,
    double? sm,
    double? md,
    double? lg,
  }) {
    return VRadius(
      defaultSize: defaultSize ?? this.defaultSize,
      none: none ?? this.none,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
    );
  }

  @override
  VRadius lerp(ThemeExtension<VRadius>? other, double t) {
    if (other is! VRadius) return this;
    return VRadius(
      defaultSize: t < 0.5 ? defaultSize : other.defaultSize,
      none: lerpDouble(none, other.none, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
    );
  }
}

/// Convenience accessors for [VRadius].
extension VRadiusX on BuildContext {
  /// Returns the [VRadius] extension from the current theme.
  VRadius get vRadius =>
      Theme.of(this).extension<VRadius>() ?? VRadius.defaults();
}
