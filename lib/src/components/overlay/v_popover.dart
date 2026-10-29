import 'package:flutter/material.dart';

import '../../foundation/v_radius.dart';

/// Anchored surface that opens when [child] is tapped.
class VPopover extends StatelessWidget {
  /// Control that opens the popover.
  final Widget child;

  /// Content shown inside the popover.
  final Widget content;

  /// Optional heading inside the popover.
  final String? title;

  /// Maximum width of the popover panel.
  final double maxWidth;

  /// Creates a [VPopover].
  const VPopover({
    super.key,
    required this.child,
    required this.content,
    this.title,
    this.maxWidth = 280,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = context.vRadius.defaultBorderRadius();
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(scheme.surface),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: scheme.outlineVariant),
          ),
        ),
      ),
      builder: (context, controller, child) {
        return InkWell(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: child,
        );
      },
      menuChildren: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(title!, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                ],
                content,
              ],
            ),
          ),
        ),
      ],
      child: child,
    );
  }
}

/// Tooltip with the library's default delay and message.
class VTooltip extends StatelessWidget {
  /// Message shown on hover and long press.
  final String message;

  /// Widget the tooltip is attached to.
  final Widget child;

  /// Creates a [VTooltip].
  const VTooltip({
    super.key,
    required this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      waitDuration: const Duration(milliseconds: 400),
      child: child,
    );
  }
}
