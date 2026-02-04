import 'package:flutter/material.dart';
import '../../foundation/v_breakpoints.dart';

/// Layout styles supported by [VAutoSizer].
enum VAutoSizerLayout {
  /// Arrange children in a horizontal row.
  row,

  /// Arrange children in a vertical column.
  column,

  /// Wrap children onto multiple lines.
  wrap,
}

/// Responsive layout wrapper that adapts by screen width.
class VAutoSizer extends StatelessWidget {
  /// Widgets to display.
  final List<Widget> children;

  /// Layout used on mobile widths.
  final VAutoSizerLayout mobileLayout;

  /// Layout used on tablet widths.
  final VAutoSizerLayout tabletLayout;

  /// Layout used on web widths.
  final VAutoSizerLayout webLayout;

  /// Spacing between items.
  final double spacing;

  /// Spacing between wrap runs.
  final double runSpacing;

  /// Minimum width per item when using wrap layouts.
  final double? minItemWidth;

  /// Minimum number of columns when auto sizing wrap items.
  final int minColumns;

  /// Maximum number of columns when auto sizing wrap items.
  final int? maxColumns;

  /// Alignment for items when auto sizing wrap items.
  final AlignmentGeometry itemAlignment;

  /// Main axis alignment for row/column layouts.
  final MainAxisAlignment mainAxisAlignment;

  /// Cross axis alignment for row/column layouts.
  final CrossAxisAlignment crossAxisAlignment;

  /// Main axis size for row/column layouts.
  final MainAxisSize mainAxisSize;

  /// Alignment for wrapped items.
  final WrapAlignment wrapAlignment;

  /// Alignment for wrap runs.
  final WrapAlignment runAlignment;

  /// Cross alignment for wrapped items.
  final WrapCrossAlignment wrapCrossAlignment;

  /// Whether to wrap the layout in a scroll view.
  final bool scrollable;

  /// Scroll physics for the scroll view.
  final ScrollPhysics? scrollPhysics;

  /// Creates a responsive [VAutoSizer].
  const VAutoSizer({
    super.key,
    required this.children,
    this.mobileLayout = VAutoSizerLayout.column,
    this.tabletLayout = VAutoSizerLayout.wrap,
    this.webLayout = VAutoSizerLayout.wrap,
    this.spacing = 12,
    this.runSpacing = 12,
    this.minItemWidth,
    this.minColumns = 1,
    this.maxColumns,
    this.itemAlignment = Alignment.topLeft,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.wrapAlignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.wrapCrossAlignment = WrapCrossAlignment.start,
    this.scrollable = true,
    this.scrollPhysics,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final layout = _layoutForWidth(width);
        final content = _buildLayout(layout, width);
        if (!scrollable) return content;

        return SingleChildScrollView(
          scrollDirection: _scrollDirection(layout),
          physics: scrollPhysics,
          child: content,
        );
      },
    );
  }

  VAutoSizerLayout _layoutForWidth(double width) {
    if (width >= VBreakpoints.lg) return webLayout;
    if (width >= VBreakpoints.md) return tabletLayout;
    return mobileLayout;
  }

  Axis _scrollDirection(VAutoSizerLayout layout) {
    switch (layout) {
      case VAutoSizerLayout.row:
        return Axis.horizontal;
      case VAutoSizerLayout.column:
      case VAutoSizerLayout.wrap:
        return Axis.vertical;
    }
  }

  Widget _buildLayout(VAutoSizerLayout layout, double width) {
    switch (layout) {
      case VAutoSizerLayout.row:
        return Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: _withSpacing(children, spacing, Axis.horizontal),
        );
      case VAutoSizerLayout.column:
        return Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: _withSpacing(children, spacing, Axis.vertical),
        );
      case VAutoSizerLayout.wrap:
        final wrapChildren = _wrapChildrenForWidth(width);
        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          alignment: wrapAlignment,
          runAlignment: runAlignment,
          crossAxisAlignment: wrapCrossAlignment,
          children: wrapChildren,
        );
    }
  }

  List<Widget> _wrapChildrenForWidth(double width) {
    if (minItemWidth == null || !width.isFinite) {
      return children;
    }
    final minWidth = minItemWidth!;
    final estimated = ((width + spacing) / (minWidth + spacing)).floor();
    final safeEstimated = estimated.clamp(1, 1000) as int;
    final cappedMax = maxColumns == null ? safeEstimated : maxColumns!;
    final columns = safeEstimated.clamp(minColumns, cappedMax) as int;
    final itemWidth = (width - (columns - 1) * spacing) / columns;

    return children
        .map(
          (child) => SizedBox(
            width: itemWidth,
            child: Align(
              alignment: itemAlignment,
              child: child,
            ),
          ),
        )
        .toList();
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
