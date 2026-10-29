import 'package:flutter/material.dart';

import '../../foundation/v_colors.dart';

/// Count or dot indicator anchored to [child].
class VBadge extends StatelessWidget {
  /// Widget the badge is attached to.
  final Widget child;

  /// Count to display. Values above 99 render as `99+`. Ignored when [dot] is true.
  final int? count;

  /// Whether to show a dot instead of a count.
  final bool dot;

  /// Badge color. Defaults to the theme error color.
  final Color? color;

  /// Label color. Defaults to [Colors.white].
  final Color? labelColor;

  /// Whether the badge is visible.
  final bool show;

  /// Creates a [VBadge].
  const VBadge({
    super.key,
    required this.child,
    this.count,
    this.dot = false,
    this.color,
    this.labelColor,
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return child;
    final visible = dot || (count != null && count! > 0);
    if (!visible) return child;
    final colors = context.vColors;
    final background = color ?? colors.error;
    final foreground = labelColor ?? colors.onError;
    final label = dot ? null : (count! > 99 ? '99+' : '$count');
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: -6,
          top: -6,
          child: Semantics(
            label: dot ? 'Notification' : '$count notifications',
            child: Container(
              constraints: BoxConstraints(minWidth: dot ? 10 : 18, minHeight: dot ? 10 : 18),
              padding: dot ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(99),
              ),
              alignment: Alignment.center,
              child: label == null
                  ? const SizedBox(width: 10, height: 10)
                  : Text(
                      label,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
