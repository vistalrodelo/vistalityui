import 'package:flutter/material.dart';

import '../../foundation/v_intent.dart';
import '../../foundation/v_intent_colors.dart';
import '../../foundation/v_spacing.dart';

/// Determinate or indeterminate progress with an optional label.
class VProgress extends StatelessWidget {
  /// Progress from 0 to 1. Null shows an indeterminate indicator.
  final double? value;

  /// Semantic intent used for the indicator color.
  final VIntent intent;

  /// Optional caption shown beside or below the indicator.
  final String? label;

  /// Whether to render a linear bar. Circular when false.
  final bool linear;

  /// Creates a [VProgress].
  const VProgress({
    super.key,
    this.value,
    this.intent = VIntent.primary,
    this.label,
    this.linear = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.vIntentColors(intent);
    final clamped = value?.clamp(0.0, 1.0).toDouble();
    final indicator = linear
        ? LinearProgressIndicator(
            value: clamped,
            color: palette.background,
            backgroundColor: palette.container,
            minHeight: 8,
            borderRadius: BorderRadius.circular(99),
          )
        : SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              value: clamped,
              color: palette.background,
              backgroundColor: palette.container,
              strokeWidth: 3,
            ),
          );
    final percent = clamped == null ? null : '${(clamped * 100).round()}%';
    return Semantics(
      label: label ?? 'Progress',
      value: percent,
      child: linear
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label != null || percent != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: VSpacing.xs),
                    child: Row(
                      children: [
                        if (label != null) Expanded(child: Text(label!)),
                        if (percent != null) Text(percent),
                      ],
                    ),
                  ),
                indicator,
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                indicator,
                if (label != null) ...[
                  const SizedBox(width: VSpacing.sm),
                  Text(label!),
                ],
              ],
            ),
    );
  }
}

/// Animated placeholder used while content is loading.
class VSkeleton extends StatefulWidget {
  /// Width of the placeholder. Expands when null.
  final double? width;

  /// Height of the placeholder.
  final double height;

  /// Corner radius. Uses a pill when null and [height] is small.
  final double radius;

  /// Creates a [VSkeleton].
  const VSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius = 8,
  });

  @override
  State<VSkeleton> createState() => _VSkeletonState();
}

class _VSkeletonState extends State<VSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08);
    final highlight = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.16);
    return Semantics(
      label: 'Loading',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Color.lerp(base, highlight, _controller.value),
              borderRadius: BorderRadius.circular(widget.radius),
            ),
          );
        },
      ),
    );
  }
}
