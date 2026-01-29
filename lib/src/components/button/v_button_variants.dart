import 'package:flutter/material.dart';
import '../../foundation/v_intent.dart';
import 'v_button.dart';

class VPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const VPrimaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return VButton(label: label, intent: VIntent.primary, onPressed: onPressed);
  }
}

class VSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const VSecondaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return VButton(label: label, intent: VIntent.secondary, onPressed: onPressed);
  }
}

class VGhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const VGhostButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return VButton(
      label: label,
      intent: VIntent.secondary,
      variant: VButtonVariant.ghost,
      onPressed: onPressed,
    );
  }
}

class VDestructiveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const VDestructiveButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return VButton(label: label, intent: VIntent.danger, onPressed: onPressed);
  }
}

class VLoadingButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const VLoadingButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return VButton(label: label, loading: true, onPressed: onPressed);
  }
}

class VDisabledButton extends StatelessWidget {
  final String label;
  const VDisabledButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return VButton(label: label, onPressed: null);
  }
}
