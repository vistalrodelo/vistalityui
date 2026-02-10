import 'package:flutter/material.dart';
import '../../foundation/v_intent.dart';
import 'v_button.dart';

/// Convenience button for the primary intent.
class VPrimaryButton extends StatelessWidget {
  /// Button label text.
  final String label;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional foreground (text/icon) color override.
  final Color? foregroundColor;

  /// Optional border color override.
  final Color? borderColor;

  /// Creates a [VPrimaryButton].
  const VPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return VButton(
      label: label,
      intent: VIntent.primary,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
    );
  }
}

/// Convenience button for the secondary intent.
class VSecondaryButton extends StatelessWidget {
  /// Button label text.
  final String label;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional foreground (text/icon) color override.
  final Color? foregroundColor;

  /// Optional border color override.
  final Color? borderColor;

  /// Creates a [VSecondaryButton].
  const VSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return VButton(
      label: label,
      intent: VIntent.secondary,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
    );
  }
}

/// Convenience button for the ghost variant.
class VGhostButton extends StatelessWidget {
  /// Button label text.
  final String label;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional foreground (text/icon) color override.
  final Color? foregroundColor;

  /// Optional border color override.
  final Color? borderColor;

  /// Creates a [VGhostButton].
  const VGhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return VButton(
      label: label,
      intent: VIntent.secondary,
      variant: VButtonVariant.ghost,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
    );
  }
}

/// Convenience button for the danger intent.
class VDestructiveButton extends StatelessWidget {
  /// Button label text.
  final String label;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional foreground (text/icon) color override.
  final Color? foregroundColor;

  /// Optional border color override.
  final Color? borderColor;

  /// Creates a [VDestructiveButton].
  const VDestructiveButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return VButton(
      label: label,
      intent: VIntent.danger,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
    );
  }
}

/// Convenience button that shows a loading spinner.
class VLoadingButton extends StatelessWidget {
  /// Button label text.
  final String label;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Creates a [VLoadingButton].
  const VLoadingButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return VButton(label: label, loading: true, onPressed: onPressed);
  }
}

/// Convenience button in a disabled state.
class VDisabledButton extends StatelessWidget {
  /// Button label text.
  final String label;

  /// Creates a [VDisabledButton].
  const VDisabledButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return VButton(label: label, onPressed: null);
  }
}
