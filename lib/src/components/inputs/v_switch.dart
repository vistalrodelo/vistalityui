import 'dart:math' show min;

import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

/// A themed switch with optional label.
class VSwitch extends StatelessWidget {
  /// Current switch value.
  final bool value;

  /// Called when the switch toggles.
  final ValueChanged<bool>? onChanged;

  /// Whether the switch is enabled.
  final bool enabled;

  /// Optional label text.
  final String? label;

  /// Optional custom label widget.
  final Widget? child;

  /// Optional active thumb color override.
  ///
  /// When not provided, the primary color from [VColors] is used.
  final Color? activeColor;

  /// Radius token or identifier resolved by [VRadius].
  final Object? radius;

  /// Explicit radius override when not using a token.
  final double? radiusValue;

  /// Creates a [VSwitch].
  const VSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.label,
    this.child,
    this.activeColor,
    this.radius,
    this.radiusValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);
    final borderRadius = context.vRadius.resolveBorderRadius(
      radius: radius,
      radiusValue: radiusValue,
    );
    final isInteractive = enabled && onChanged != null;
    const trackWidth = 52.0;
    const trackHeight = 32.0;
    const thumbPadding = 3.0;
    const animationDuration = Duration(milliseconds: 140);
    final thumbSize = trackHeight - thumbPadding * 2;
    final thumbRadius = BorderRadius.circular(min(borderRadius.topLeft.x, thumbSize / 2));
    final resolvedActiveColor = activeColor ?? vc.primary;
    final trackColor = value
        ? resolvedActiveColor.withValues(alpha: enabled ? 0.26 : 0.16)
        : cs.surfaceContainerHighest.withValues(alpha: enabled ? 1 : 0.75);
    final borderColor = value
        ? resolvedActiveColor.withValues(alpha: enabled ? 0.9 : 0.5)
        : cs.outline.withValues(alpha: enabled ? 0.7 : 0.45);
    final thumbColor = enabled
        ? (value ? resolvedActiveColor : cs.surface)
        : cs.surfaceContainerHigh;

    final switcher = Semantics(
      toggled: value,
      enabled: isInteractive,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: isInteractive ? () => onChanged?.call(!value) : null,
          child: AnimatedContainer(
            duration: animationDuration,
            curve: Curves.easeOutCubic,
            width: trackWidth,
            height: trackHeight,
            decoration: BoxDecoration(
              color: trackColor,
              borderRadius: borderRadius,
              border: Border.all(color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(thumbPadding),
              child: AnimatedAlign(
                duration: animationDuration,
                curve: Curves.easeOutCubic,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: thumbSize,
                  height: thumbSize,
                  decoration: BoxDecoration(
                    color: thumbColor,
                    borderRadius: thumbRadius,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final labelWidget = child ?? (label != null ? Text(label!) : null);
    if (labelWidget == null) return switcher;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        switcher,
        const SizedBox(width: 8),
        labelWidget,
      ],
    );
  }
}
