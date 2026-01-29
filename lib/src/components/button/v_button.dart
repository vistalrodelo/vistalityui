import 'package:flutter/material.dart';
import '../../foundation/v_intent.dart';
import '../../foundation/v_radius.dart';
import 'v_button_style.dart';

enum VButtonSize { sm, md, lg }
enum VButtonVariant { solid, ghost, text }

class VButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  final VIntent intent;
  final VButtonSize size;
  final Object? radius;
  final double? radiusValue;
  final VButtonVariant variant;

  final Widget? leading;
  final Widget? trailing;

  final bool fullWidth;
  final bool loading;

  const VButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.intent = VIntent.primary,
    this.size = VButtonSize.md,
    this.radius,
    this.radiusValue,
    this.variant = VButtonVariant.solid,
    this.leading,
    this.trailing,
    this.fullWidth = false,
    this.loading = false,
  });

  bool get enabled => onPressed != null && !loading;

  EdgeInsets get _padding {
    switch (size) {
      case VButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case VButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
      case VButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = context.vRadius.resolveBorderRadius(
      radius: this.radius,
      radiusValue: radiusValue,
    );
    final style = VButtonStyle.resolve(
      context: context,
      intent: intent,
      variant: variant,
      enabled: enabled,
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: Material(
        color: style.background,
        borderRadius: radius,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: radius,
          child: Container(
            padding: _padding,
            decoration: BoxDecoration(
              border: Border.all(color: style.border),
              borderRadius: radius,
            ),
            alignment: Alignment.center,
            child: _buildContent(style),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(VButtonStyle style) {
    if (loading) {
      return SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: style.foreground,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            color: style.foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );
  }
}
