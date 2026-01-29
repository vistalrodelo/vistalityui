import 'package:flutter/material.dart';

class VBreakpoints {
  static const double sm = 480;
  static const double md = 768;
  static const double lg = 1024;
  static const double xl = 1280;

  static double forWidth(double width) {
    if (width >= xl) return xl;
    if (width >= lg) return lg;
    if (width >= md) return md;
    return sm;
  }
}

typedef VResponsiveBuilder = Widget Function(BuildContext context, double width);

class VResponsive extends StatelessWidget {
  final VResponsiveBuilder builder;
  const VResponsive({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, constraints.maxWidth);
      },
    );
  }
}
