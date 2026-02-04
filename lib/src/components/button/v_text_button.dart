import 'package:flutter/material.dart';
import 'v_button.dart';

/// Text-only button variant using [VButtonVariant.text].
class VTextActionButton extends StatelessWidget {
  /// Button label text.
  final String label;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is enabled.
  final bool enabled;

  /// Creates a [VTextActionButton].
  const VTextActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return VButton(
      label: label,
      onPressed: enabled ? onPressed : null,
      variant: VButtonVariant.text,
    );
  }
}
