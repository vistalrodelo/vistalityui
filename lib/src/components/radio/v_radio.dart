import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

/// A custom radio control with optional label.
class VRadio<T> extends StatelessWidget {
  /// Value represented by this radio option.
  final T value;

  /// Current selected value for the group.
  final T? groupValue;

  /// Called when the radio is selected.
  final ValueChanged<T>? onChanged;

  /// Whether the radio is enabled.
  final bool enabled;

  /// Diameter of the radio control.
  final double size;

  /// Optional label text.
  final String? label;

  /// Optional custom label widget.
  final Widget? child;

  /// Optional color override for the selected state.
  ///
  /// When provided, this color is used for the selected border and fill
  /// instead of the primary color from [VColors].
  final Color? activeColor;

  /// Creates a [VRadio].
  const VRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.enabled = true,
    this.size = 20,
    this.label,
    this.child,
    this.activeColor,
  });

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);

    final primary = activeColor ?? vc.primary;
    final borderColor = _selected ? primary : vc.outline;
    final fillColor = _selected ? primary : Colors.transparent;
    final dotColor = vc.onPrimary;

    final radio = InkWell(
      onTap: enabled ? () => onChanged?.call(value) : null,
      customBorder: const CircleBorder(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? fillColor : cs.onSurface.withValues(alpha: 0.12),
          border: Border.all(
            color: enabled ? borderColor : cs.onSurface.withValues(alpha: 0.38),
          ),
        ),
        child: _selected
            ? Center(
                child: Container(
                  width: size * 0.4,
                  height: size * 0.4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: enabled ? dotColor : cs.onSurface.withValues(alpha: 0.38),
                  ),
                ),
              )
            : null,
      ),
    );

    final labelWidget = child ?? (label != null ? Text(label!) : null);
    if (labelWidget == null) return radio;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        radio,
        const SizedBox(width: 10),
        labelWidget,
      ],
    );
  }
}
