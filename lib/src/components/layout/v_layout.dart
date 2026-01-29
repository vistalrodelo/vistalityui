import 'package:flutter/material.dart';
import '../../foundation/v_radius.dart';

class VBox extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Border? border;
  final List<BoxShadow>? shadow;
  final Object? radius;
  final double? radiusValue;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  const VBox({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.color,
    this.border,
    this.shadow,
    this.radius,
    this.radiusValue,
    this.width,
    this.height,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = context.vRadius.resolveBorderRadius(
      radius: radius,
      radiusValue: radiusValue,
    );

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: color,
        border: border,
        borderRadius: borderRadius,
        boxShadow: shadow,
      ),
      child: child,
    );
  }
}

class VPadding extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget child;
  const VPadding({super.key, required this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}

class VSpacer extends StatelessWidget {
  final double size;
  const VSpacer(this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size);
  }
}

class VDivider extends StatelessWidget {
  final double thickness;
  final Color? color;
  const VDivider({super.key, this.thickness = 1, this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: thickness, color: color);
  }
}

class VRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const VRow({
    super.key,
    required this.children,
    this.spacing = 0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _withSpacing(children, spacing, Axis.horizontal),
    );
  }
}

class VColumn extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const VColumn({
    super.key,
    required this.children,
    this.spacing = 0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _withSpacing(children, spacing, Axis.vertical),
    );
  }
}

class VWrap extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  const VWrap({
    super.key,
    required this.children,
    this.spacing = 0,
    this.runSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: spacing, runSpacing: runSpacing, children: children);
  }
}

class VStack extends StatelessWidget {
  final List<Widget> children;
  final AlignmentGeometry alignment;
  const VStack({
    super.key,
    required this.children,
    this.alignment = AlignmentDirectional.topStart,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: alignment, children: children);
  }
}

class VGrid extends StatelessWidget {
  final List<Widget> children;
  final int columns;
  final double spacing;
  final double runSpacing;
  final double childAspectRatio;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const VGrid({
    super.key,
    required this.children,
    required this.columns,
    this.spacing = 12,
    this.runSpacing = 12,
    this.childAspectRatio = 1,
    this.physics,
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: runSpacing,
      childAspectRatio: childAspectRatio,
      physics: physics,
      shrinkWrap: shrinkWrap,
      children: children,
    );
  }
}

class VAspect extends StatelessWidget {
  final double ratio;
  final Widget child;
  const VAspect({super.key, required this.ratio, required this.child});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: ratio, child: child);
  }
}

class VSafeArea extends StatelessWidget {
  final Widget child;
  const VSafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: child);
  }
}

class VCenter extends StatelessWidget {
  final Widget child;
  const VCenter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(child: child);
  }
}

class VAlign extends StatelessWidget {
  final AlignmentGeometry alignment;
  final Widget child;
  const VAlign({super.key, required this.alignment, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(alignment: alignment, child: child);
  }
}

class VConstrainedBox extends StatelessWidget {
  final BoxConstraints constraints;
  final Widget child;
  const VConstrainedBox({super.key, required this.constraints, required this.child});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(constraints: constraints, child: child);
  }
}

class VScrollView extends StatelessWidget {
  final Axis direction;
  final Widget child;
  const VScrollView({super.key, this.direction = Axis.vertical, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(scrollDirection: direction, child: child);
  }
}

List<Widget> _withSpacing(List<Widget> children, double spacing, Axis axis) {
  if (spacing <= 0) return children;
  final spaced = <Widget>[];
  for (var i = 0; i < children.length; i++) {
    spaced.add(children[i]);
    if (i != children.length - 1) {
      spaced.add(
        SizedBox(
          width: axis == Axis.horizontal ? spacing : 0,
          height: axis == Axis.vertical ? spacing : 0,
        ),
      );
    }
  }
  return spaced;
}
