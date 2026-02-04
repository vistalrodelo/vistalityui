import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';
import '../button/v_button.dart';
import '../checkbox/v_checkbox.dart';
import '../../foundation/v_intent.dart';

/// Multi-select item definition for [VMultiSelectDropdown].
class VMultiSelectItem<T> {
  /// Underlying value for the item.
  final T value;

  /// Label text shown when [child] is not provided.
  final String label;

  /// Optional custom widget for the item.
  final Widget? child;

  /// Creates a [VMultiSelectItem].
  const VMultiSelectItem({
    required this.value,
    required this.label,
    this.child,
  });
}

/// A multi-select dropdown using a dialog and checkboxes.
class VMultiSelectDropdown<T> extends StatelessWidget {
  /// Items available in the dropdown.
  final List<VMultiSelectItem<T>> items;

  /// Currently selected values.
  final List<T> values;

  /// Called when the selection changes.
  final ValueChanged<List<T>>? onChanged;

  /// Label text displayed above the field.
  final String? label;

  /// Hint text displayed when no selection is made.
  final String? hint;

  /// Error text shown below the field.
  final String? errorText;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is filled.
  final bool filled;

  /// Radius token or identifier resolved by [VRadius].
  final Object? radius;

  /// Explicit radius override when not using a token.
  final double? radiusValue;

  /// Padding inside the field.
  final EdgeInsetsGeometry? contentPadding;

  /// Creates a [VMultiSelectDropdown].
  const VMultiSelectDropdown({
    super.key,
    required this.items,
    required this.values,
    required this.onChanged,
    this.label,
    this.hint,
    this.errorText,
    this.enabled = true,
    this.filled = true,
    this.radius,
    this.radiusValue,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);
    final borderRadius = context.vRadius.resolveBorderRadius(
      radius: radius,
      radiusValue: radiusValue,
    );

    final border = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: vc.outline),
    );

    final selectedLabels = items
        .where((item) => values.contains(item.value))
        .map((item) => item.label)
        .toList();

    return InkWell(
      onTap: enabled ? () => _openSheet(context) : null,
      borderRadius: borderRadius,
      child: InputDecorator(
        isFocused: false,
        isEmpty: selectedLabels.isEmpty,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: errorText,
          filled: filled,
          fillColor: enabled ? cs.surface : cs.surface.withValues(alpha: 0.4),
          contentPadding:
              contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(color: vc.primary, width: 2),
          ),
          errorBorder: border.copyWith(
            borderSide: BorderSide(color: vc.error),
          ),
          focusedErrorBorder: border.copyWith(
            borderSide: BorderSide(color: vc.error, width: 2),
          ),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          selectedLabels.isEmpty ? '' : selectedLabels.join(', '),
          style: TextStyle(color: cs.onSurface),
        ),
      ),
    );
  }

  void _openSheet(BuildContext context) {
    final initial = List<T>.from(values);

    final sheetRadius = context.vRadius.resolveBorderRadius(
      radius: radius,
      radiusValue: radiusValue,
    );

    showDialog<void>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final cs = theme.colorScheme;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: sheetRadius),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          clipBehavior: Clip.antiAlias,
          child: StatefulBuilder(
            builder: (ctx, setState) {
              return LayoutBuilder(
                builder: (ctx, constraints) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 520),
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: Container(
                  color: cs.surface,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (label != null) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            label!,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          children: items.map((item) {
                            final checked = initial.contains(item.value);
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (checked) {
                                    initial.remove(item.value);
                                  } else {
                                    initial.add(item.value);
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 4,
                                ),
                                child: Row(
                                  children: [
                                    VCheckbox(
                                      value: checked,
                                      onChanged: (v) {
                                        setState(() {
                                          if (v) {
                                            initial.add(item.value);
                                          } else {
                                            initial.remove(item.value);
                                          }
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(child: item.child ?? Text(item.label)),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          VButton(
                            label: 'Clear',
                            intent: VIntent.secondary,
                            size: VButtonSize.sm,
                            onPressed: () {
                              initial.clear();
                              setState(() {});
                            },
                          ),
                          const Spacer(),
                          VButton(
                            label: 'Cancel',
                            intent: VIntent.secondary,
                            size: VButtonSize.sm,
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                          const SizedBox(width: 8),
                          VButton(
                            label: 'Apply',
                            size: VButtonSize.sm,
                            onPressed: onChanged == null
                                ? null
                                : () {
                                    onChanged!(List<T>.from(initial));
                                    Navigator.of(ctx).pop();
                                  },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
