import 'dart:ui';

import 'package:flutter/material.dart';

enum VRadiusSize { none, sm, md, lg }

@immutable
class VRadius extends ThemeExtension<VRadius> {
  final VRadiusSize defaultSize;
  final double none;
  final double sm;
  final double md;
  final double lg;

  const VRadius({
    required this.defaultSize,
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
  });

  factory VRadius.defaults() => const VRadius(
    defaultSize: VRadiusSize.md,
    none: 0,
    sm: 6,
    md: 10,
    lg: 16,
  );

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

  BorderRadius borderRadius(VRadiusSize size) => BorderRadius.circular(value(size));
  BorderRadius defaultBorderRadius() => borderRadius(defaultSize);
  BorderRadius borderRadiusValue(double radius) => BorderRadius.circular(radius);

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

extension VRadiusX on BuildContext {
  VRadius get vRadius =>
      Theme.of(this).extension<VRadius>() ?? VRadius.defaults();
}
