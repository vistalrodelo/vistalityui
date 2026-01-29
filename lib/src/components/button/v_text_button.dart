import 'package:flutter/material.dart';
import 'v_button.dart';

class VTextActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

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
