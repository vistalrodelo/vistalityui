import 'package:flutter/material.dart';
import '../../foundation/v_control_sizes.dart';
import '../../foundation/v_intent.dart';
import '../../foundation/v_radius.dart';
import 'v_button_style.dart';

/// Predefined size presets for [VButton].
enum VButtonSize {
  /// Small size.
  sm,

  /// Medium size.
  md,

  /// Large size.
  lg,
}

/// Visual variants available for [VButton].
enum VButtonVariant {
  /// Solid background button.
  solid,

  /// Ghost button with outline.
  ghost,

  /// Text-only button.
  text,
}

/// A styled button with intent, sizing, and variants.
class VButton extends StatelessWidget {
  /// Button label text.
  final String label;

  /// Callback invoked when the button is tapped.
  final VoidCallback? onPressed;

  /// Semantic intent used for color styling.
  final VIntent intent;

  /// Size preset that controls padding and density.
  final VButtonSize size;

  /// Radius token or identifier resolved by [VRadius].
  final Object? radius;

  /// Explicit radius override when not using a token.
  final double? radiusValue;

  /// Optional background color override.
  ///
  /// When provided, this takes precedence over the resolved background color
  /// from [intent] and [variant].
  final Color? backgroundColor;

  /// Optional foreground (text/icon) color override.
  ///
  /// When provided, this takes precedence over the resolved foreground color
  /// from [intent] and [variant].
  final Color? foregroundColor;

  /// Optional border color override.
  ///
  /// When provided, this takes precedence over the resolved border color
  /// from [intent] and [variant].
  final Color? borderColor;

  /// Visual variant that drives background/border styles.
  final VButtonVariant variant;

  /// Optional leading widget shown before the label.
  final Widget? leading;

  /// Optional trailing widget shown after the label.
  final Widget? trailing;

  /// Whether the button stretches to fill available width.
  final bool fullWidth;

  /// Optional height override for the button.
  final double? height;

  /// Whether to show a loading spinner and disable the button.
  final bool loading;

  /// Creates a [VButton] with styling and size options.
  const VButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.intent = VIntent.primary,
    this.size = VButtonSize.md,
    this.radius,
    this.radiusValue,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.variant = VButtonVariant.solid,
    this.leading,
    this.trailing,
    this.fullWidth = false,
    this.height,
    this.loading = false,
  });

  /// Whether the button is interactive.
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

  double get _defaultHeight {
    switch (size) {
      case VButtonSize.sm:
        return VControlSizes.buttonSm;
      case VButtonSize.lg:
        return VControlSizes.buttonLg;
      case VButtonSize.md:
        return VControlSizes.buttonMd;
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
      backgroundOverride: backgroundColor,
      foregroundOverride: foregroundColor,
      borderOverride: borderColor,
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: height ?? _defaultHeight),
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
