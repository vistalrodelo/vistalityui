import 'package:flutter/material.dart';
import '../../foundation/v_radius.dart';

/// Container helper with optional padding, margin, and radius.
class VBox extends StatelessWidget {
  /// Child widget inside the box.
  final Widget? child;

  /// Inner padding of the box.
  final EdgeInsetsGeometry? padding;

  /// Outer margin of the box.
  final EdgeInsetsGeometry? margin;

  /// Background color of the box.
  final Color? color;

  /// Border for the box.
  final Border? border;

  /// Shadow list for the box.
  final List<BoxShadow>? shadow;

  /// Radius token or identifier resolved by [VRadius].
  final Object? radius;

  /// Explicit radius override when not using a token.
  final double? radiusValue;

  /// Fixed width for the box.
  final double? width;

  /// Fixed height for the box.
  final double? height;

  /// Alignment for the child.
  final AlignmentGeometry? alignment;

  /// Creates a [VBox].
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

/// Wrapper around [Padding].
class VPadding extends StatelessWidget {
  /// Padding to apply.
  final EdgeInsetsGeometry padding;

  /// Child widget.
  final Widget child;

  /// Creates a [VPadding].
  const VPadding({super.key, required this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}

/// Square spacer with identical width and height.
class VSpacer extends StatelessWidget {
  /// Size for both width and height.
  final double size;

  /// Creates a [VSpacer].
  const VSpacer(this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size);
  }
}

/// Horizontal divider with optional thickness and color.
class VDivider extends StatelessWidget {
  /// Thickness of the divider.
  final double thickness;

  /// Divider color.
  final Color? color;

  /// Creates a [VDivider].
  const VDivider({super.key, this.thickness = 1, this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: thickness, color: color);
  }
}

/// Row with optional spacing between children.
class VRow extends StatelessWidget {
  /// Widgets to display in a row.
  final List<Widget> children;

  /// Spacing between children.
  final double spacing;

  /// Main axis alignment.
  final MainAxisAlignment mainAxisAlignment;

  /// Cross axis alignment.
  final CrossAxisAlignment crossAxisAlignment;

  /// Main axis size.
  final MainAxisSize mainAxisSize;

  /// Creates a [VRow].
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

/// Column with optional spacing between children.
class VColumn extends StatelessWidget {
  /// Widgets to display in a column.
  final List<Widget> children;

  /// Spacing between children.
  final double spacing;

  /// Main axis alignment.
  final MainAxisAlignment mainAxisAlignment;

  /// Cross axis alignment.
  final CrossAxisAlignment crossAxisAlignment;

  /// Main axis size.
  final MainAxisSize mainAxisSize;

  /// Creates a [VColumn].
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

/// Wrapper around [Wrap] with spacing controls.
class VWrap extends StatelessWidget {
  /// Widgets to display.
  final List<Widget> children;

  /// Spacing between children.
  final double spacing;

  /// Spacing between runs.
  final double runSpacing;

  /// Creates a [VWrap].
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

/// Stack with configurable alignment.
class VStack extends StatelessWidget {
  /// Widgets to overlay.
  final List<Widget> children;

  /// Alignment for the stack.
  final AlignmentGeometry alignment;

  /// Creates a [VStack].
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

/// Grid view with fixed column count.
class VGrid extends StatelessWidget {
  /// Widgets to display in the grid.
  final List<Widget> children;

  /// Number of columns.
  final int columns;

  /// Spacing between columns.
  final double spacing;

  /// Spacing between rows.
  final double runSpacing;

  /// Aspect ratio for grid children.
  final double childAspectRatio;

  /// Scroll physics for the grid.
  final ScrollPhysics? physics;

  /// Whether the grid shrinks to fit content.
  final bool shrinkWrap;

  /// Creates a [VGrid].
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

/// Wrapper around [AspectRatio].
class VAspect extends StatelessWidget {
  /// Desired aspect ratio.
  final double ratio;

  /// Child widget.
  final Widget child;

  /// Creates a [VAspect].
  const VAspect({super.key, required this.ratio, required this.child});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: ratio, child: child);
  }
}

/// Wrapper around [SafeArea].
class VSafeArea extends StatelessWidget {
  /// Child widget.
  final Widget child;

  /// Creates a [VSafeArea].
  const VSafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: child);
  }
}

/// Wrapper around [Center].
class VCenter extends StatelessWidget {
  /// Child widget.
  final Widget child;

  /// Creates a [VCenter].
  const VCenter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(child: child);
  }
}

/// Wrapper around [Align].
class VAlign extends StatelessWidget {
  /// Alignment to apply.
  final AlignmentGeometry alignment;

  /// Child widget.
  final Widget child;

  /// Creates a [VAlign].
  const VAlign({super.key, required this.alignment, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(alignment: alignment, child: child);
  }
}

/// Wrapper around [ConstrainedBox].
class VConstrainedBox extends StatelessWidget {
  /// Constraints to apply.
  final BoxConstraints constraints;

  /// Child widget.
  final Widget child;

  /// Creates a [VConstrainedBox].
  const VConstrainedBox({super.key, required this.constraints, required this.child});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(constraints: constraints, child: child);
  }
}

/// Wrapper around [SingleChildScrollView].
class VScrollView extends StatelessWidget {
  /// Scroll direction.
  final Axis direction;

  /// Child widget.
  final Widget child;

  /// Creates a [VScrollView].
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
