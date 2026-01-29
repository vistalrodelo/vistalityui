import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

class VRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;

  final bool enabled;
  final double size;
  final String? label;
  final Widget? child;

  const VRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.enabled = true,
    this.size = 20,
    this.label,
    this.child,
  });

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);

    final borderColor = _selected ? vc.primary : vc.outline;
    final fillColor = _selected ? vc.primary : Colors.transparent;
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
          color: enabled ? fillColor : cs.onSurface.withOpacity(0.12),
          border: Border.all(
            color: enabled ? borderColor : cs.onSurface.withOpacity(0.38),
          ),
        ),
        child: _selected
            ? Center(
                child: Container(
                  width: size * 0.4,
                  height: size * 0.4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: enabled ? dotColor : cs.onSurface.withOpacity(0.38),
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
