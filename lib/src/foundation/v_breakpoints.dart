import 'package:flutter/material.dart';

/// Named width breakpoints used for responsive layouts.
class VBreakpoints {
  /// Small breakpoint width.
  static const double sm = 480;

  /// Medium breakpoint width.
  static const double md = 768;

  /// Large breakpoint width.
  static const double lg = 1024;

  /// Extra large breakpoint width.
  static const double xl = 1280;

  /// Resolves the closest breakpoint for a given width.
  static double forWidth(double width) {
    if (width >= xl) return xl;
    if (width >= lg) return lg;
    if (width >= md) return md;
    return sm;
  }
}

/// Builder signature for responsive widgets.
typedef VResponsiveBuilder = Widget Function(BuildContext context, double width);

/// Layout helper that passes the available width to [builder].
class VResponsive extends StatelessWidget {
  /// Called with the current max width of the layout.
  final VResponsiveBuilder builder;

  /// Creates a [VResponsive] widget.
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
