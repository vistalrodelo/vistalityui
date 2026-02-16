import 'dart:math' show atan2, cos, pi, sin, sqrt;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../textbox/v_textbox.dart';
import '../button/v_button.dart';

// --- Color helpers (internal) ---

String _colorToHex6(Color c) {
  return (c.toARGB32() & 0xFFFFFF)
      .toRadixString(16)
      .padLeft(6, '0')
      .toUpperCase();
}

Color? _parseHex(String input) {
  final s = input.trim().replaceFirst(RegExp(r'^#'), '');
  if (s.length != 6) return null;
  final n = int.tryParse(s, radix: 16);
  if (n == null) return null;
  return Color(n | 0xFF000000);
}

void _rgbToHsv(int r, int g, int b, List<double> outHsv) {
  final rr = r / 255, gg = g / 255, bb = b / 255;
  final mx = rr > gg ? (rr > bb ? rr : bb) : (gg > bb ? gg : bb);
  final mn = rr < gg ? (rr < bb ? rr : bb) : (gg < bb ? gg : bb);
  final d = mx - mn;
  final s = mx == 0 ? 0.0 : d / mx;
  final v = mx;
  double h = 0;
  if (d != 0) {
    if (mx == rr) {
      h = (gg - bb) / d + (gg < bb ? 6 : 0);
    } else if (mx == gg) {
      h = (bb - rr) / d + 2;
    } else {
      h = (rr - gg) / d + 4;
    }
    h /= 6;
  }
  outHsv[0] = h * 360;
  outHsv[1] = s;
  outHsv[2] = v;
}

Color _hsvToColor(double h, double s, double v) {
  h = h % 360;
  if (h < 0) h += 360;
  final c = v * s;
  final x = c * (1 - ((h / 60) % 2 - 1).abs());
  final m = v - c;
  double r = 0, g = 0, b = 0;
  if (h < 60) {
    r = c;
    g = x;
    b = 0;
  } else if (h < 120) {
    r = x;
    g = c;
    b = 0;
  } else if (h < 180) {
    r = 0;
    g = c;
    b = x;
  } else if (h < 240) {
    r = 0;
    g = x;
    b = c;
  } else if (h < 300) {
    r = x;
    g = 0;
    b = c;
  } else {
    r = c;
    g = 0;
    b = x;
  }
  final rv = ((r + m).clamp(0.0, 1.0) * 255).round();
  final gv = ((g + m).clamp(0.0, 1.0) * 255).round();
  final bv = ((b + m).clamp(0.0, 1.0) * 255).round();
  return Color.fromRGBO(rv, gv, bv, 1.0);
}

/// Default six common colors shown in the color wheel picker.
/// First three are primary colors (red, yellow, blue),
/// last three are secondary colors (orange, green, purple).
const List<Color> kVColorWheelCommonColors = [
  Color(0xFFFF0000), // Red
  Color(0xFFFFFF00), // Yellow
  Color(0xFF0000FF), // Blue
  Color(0xFFFF9900), // Orange
  Color(0xFF00FF00), // Green
  Color(0xFF800080), // Purple
];

// --- Painters (internal) ---

class _HollowCircumcirclePainter extends CustomPainter {
  _HollowCircumcirclePainter({
    required this.center,
    required this.innerRadius,
    required this.hollowColor,
  });

  final double center;
  final double innerRadius;
  final Color hollowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(center, center);
    final circlePath =
        Path()..addOval(Rect.fromCircle(center: c, radius: innerRadius));
    final sqrt3 = sqrt(3);
    final trianglePath = Path()
      ..moveTo(center + innerRadius, center)
      ..lineTo(center - innerRadius / 2, center - innerRadius * sqrt3 / 2)
      ..lineTo(center - innerRadius / 2, center + innerRadius * sqrt3 / 2)
      ..close();
    final hollowPath =
        Path.combine(PathOperation.difference, circlePath, trianglePath);
    canvas.drawPath(hollowPath, Paint()..color = hollowColor);
  }

  @override
  bool shouldRepaint(covariant _HollowCircumcirclePainter oldDelegate) =>
      oldDelegate.hollowColor != hollowColor ||
      oldDelegate.innerRadius != innerRadius;
}

class _HueRingPainter extends CustomPainter {
  _HueRingPainter({
    required this.center,
    required this.innerRadius,
    required this.outerRadius,
    required this.hollowColor,
  });

  final double center;
  final double innerRadius;
  final double outerRadius;
  final Color hollowColor;

  static final List<Color> _rainbowColors = [
    _hsvToColor(0, 1, 1),
    _hsvToColor(60, 1, 1),
    _hsvToColor(120, 1, 1),
    _hsvToColor(180, 1, 1),
    _hsvToColor(240, 1, 1),
    _hsvToColor(300, 1, 1),
    _hsvToColor(360, 1, 1),
  ];

  static const List<double> _rainbowStops = [0, 1/6, 2/6, 3/6, 4/6, 5/6, 1.0];

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(center, center);
    final rect = Rect.fromCircle(center: c, radius: outerRadius + 2);
    final gradient = SweepGradient(
      center: Alignment.center,
      startAngle: 0,
      endAngle: 2 * pi,
      colors: _rainbowColors,
      stops: _rainbowStops,
    );
    final ringPath = Path()
      ..addOval(Rect.fromCircle(center: c, radius: outerRadius))
      ..addOval(Rect.fromCircle(center: c, radius: innerRadius))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(
      ringPath,
      Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill,
    );
    final borderPaint = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(c, outerRadius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _HueRingPainter oldDelegate) =>
      oldDelegate.hollowColor != hollowColor;
}

class _SatValTrianglePainter extends CustomPainter {
  _SatValTrianglePainter({required this.hue});

  final double hue;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, h)
      ..lineTo(w, h / 2)
      ..close();
    final hueColor = _hsvToColor(hue, 1, 1);
    for (var py = 0.0; py < h; py += 1.5) {
      final rightX =
          py <= h / 2 ? py * 2 * w / h : (h - py) * 2 * w / h;
      if (rightX <= 0) continue;
      final leftColor = Color.lerp(Colors.white, Colors.black, py / h)!;
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          colors: [leftColor, hueColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(Rect.fromLTRB(0, py, rightX, py + 2));
      canvas.drawRect(Rect.fromLTRB(0, py, rightX, py + 2), gradientPaint);
    }
    final borderPaint = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _SatValTrianglePainter oldDelegate) =>
      oldDelegate.hue != hue;
}

// --- Main widget ---

/// A reusable color wheel picker: hue ring, saturation/value triangle, hex input,
/// optional common and recent color chips, preview strip, and Cancel/Apply actions.
class VColorWheelPicker extends StatefulWidget {
  const VColorWheelPicker({
    super.key,
    required this.initialColor,
    required this.onPick,
    required this.onClose,
    this.commonColors = kVColorWheelCommonColors,
    this.recentColors = const [],
    this.contentWidth,
  });

  /// Initial color when the picker is shown.
  final Color initialColor;

  /// Called when the user confirms the color (Apply).
  final ValueChanged<Color> onPick;

  /// Called when the user cancels (Cancel or close).
  final VoidCallback onClose;

  /// Six colors shown in the "Common" row. Defaults to [kVColorWheelCommonColors].
  final List<Color> commonColors;

  /// Up to six recently picked colors shown in the "Recent" row.
  final List<Color> recentColors;

  /// Optional width of the content area (e.g. to make the modal wider).
  final double? contentWidth;

  @override
  State<VColorWheelPicker> createState() => _VColorWheelPickerState();

  /// Shows the color wheel in a dialog. Returns the selected color when Apply is
  /// tapped, or null when Cancel/back is used.
  static Future<Color?> show(
    BuildContext context, {
    required Color initialColor,
    List<Color> recentColors = const [],
    List<Color> commonColors = kVColorWheelCommonColors,
    double? contentWidth = 420,
    String dialogTitle = 'Color wheel',
  }) {
    Color? result;
    return showDialog<Color>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(dialogTitle),
        content: SizedBox(
          width: contentWidth,
          child: VColorWheelPicker(
            initialColor: initialColor,
            commonColors: commonColors,
            recentColors: recentColors,
            onPick: (color) {
              result = color;
              Navigator.of(ctx).pop(color);
            },
            onClose: () => Navigator.of(ctx).pop(),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      ),
    ).then((value) => value ?? result);
  }
}

class _VColorWheelPickerState extends State<VColorWheelPicker> {
  static const double _wheelSize = 325;
  static const double _ringWidth = 28;
  static const double _markerRadius = 8;
  double get _hueMarkerRadius => _ringWidth / 2;

  late double _h;
  late double _s;
  late double _v;
  final List<double> _hsv = [0, 0, 0];
  late final TextEditingController _hexController;

  double get _center => _wheelSize / 2;
  double get _outerRadius => _center - 2;
  double get _innerRadius => _outerRadius - _ringWidth;
  double get _ringMidRadius => _innerRadius + _ringWidth / 2;
  double get _triangleSize => _innerRadius * 1.5;
  double get _triangleHeight => _innerRadius * sqrt(3);
  double get _triangleLeft => _center - _innerRadius / 2;
  double get _triangleTop => _center - _innerRadius * sqrt(3) / 2;

  @override
  void initState() {
    super.initState();
    _hsv[0] = 0;
    _hsv[1] = 1;
    _hsv[2] = 1;
    _rgbToHsv(
      (widget.initialColor.toARGB32() >> 16) & 0xFF,
      (widget.initialColor.toARGB32() >> 8) & 0xFF,
      widget.initialColor.toARGB32() & 0xFF,
      _hsv,
    );
    _h = _hsv[0];
    _s = _hsv[1];
    _v = _hsv[2];
    _hexController =
        TextEditingController(text: _colorToHex6(_hsvToColor(_h, _s, _v)));
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  Color get _currentColor => _hsvToColor(_h, _s, _v);

  void _syncHexFromColor() {
    _hexController.text = _colorToHex6(_currentColor);
  }

  void _onHexChanged(String value) {
    if (value.length != 6) return;
    final color = _parseHex(value);
    if (color == null) return;
    final r = (color.toARGB32() >> 16) & 0xFF;
    final g = (color.toARGB32() >> 8) & 0xFF;
    final b = color.toARGB32() & 0xFF;
    _rgbToHsv(r, g, b, _hsv);
    setState(() {
      _h = _hsv[0];
      _s = _hsv[1];
      _v = _hsv[2];
    });
  }

  void _selectColor(Color color) {
    final r = (color.toARGB32() >> 16) & 0xFF;
    final g = (color.toARGB32() >> 8) & 0xFF;
    final b = color.toARGB32() & 0xFF;
    _rgbToHsv(r, g, b, _hsv);
    setState(() {
      _h = _hsv[0];
      _s = _hsv[1];
      _v = _hsv[2];
    });
    _hexController.text = _colorToHex6(color);
  }

  Widget _buildColorChipRow(
    BuildContext context,
    String label,
    List<Color> colors,
    ColorScheme cs,
  ) {
    final bool isRecentRow = label == 'Recent';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(6, (i) {
            if (i >= colors.length) {
              // For the Recent row, show disabled placeholders until we have 6 colors.
              if (!isRecentRow) {
                return const SizedBox(width: 36, height: 36);
              }
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cs.surfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: cs.outline.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
              );
            }
            final color = colors[i];
            final isSelected = _currentColor.value == color.value;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => _selectColor(color),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? cs.primary
                          : cs.outline.withValues(alpha: 0.5),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _applyHexInput() {
    final color = _parseHex(_hexController.text);
    if (color == null) {
      _hexController.text = _colorToHex6(_currentColor);
      return;
    }
    final r = (color.toARGB32() >> 16) & 0xFF;
    final g = (color.toARGB32() >> 8) & 0xFF;
    final b = color.toARGB32() & 0xFF;
    _rgbToHsv(r, g, b, _hsv);
    setState(() {
      _h = _hsv[0];
      _s = _hsv[1];
      _v = _hsv[2];
    });
    _hexController.text = _colorToHex6(_currentColor);
  }

  void _updateHueFromOffset(Offset localPosition) {
    final dx = localPosition.dx - _center;
    final dy = localPosition.dy - _center;
    final angleRad = atan2(dy, dx);
    final hue = (angleRad * 180 / pi + 360) % 360;
    setState(() => _h = hue);
    _syncHexFromColor();
  }

  void _updateSvFromOffset(Offset localPosition) {
    final w = _triangleSize;
    final h = _triangleHeight;
    final left = _triangleLeft;
    final top = _triangleTop;
    final x = (localPosition.dx - left).clamp(0.0, w);
    final y = (localPosition.dy - top).clamp(0.0, h);
    final rightX =
        y <= h / 2 ? y * 2 * w / h : (h - y) * 2 * w / h;
    if (rightX <= 0) {
      setState(() => _s = 0);
      _syncHexFromColor();
      return;
    }
    final s = (x / rightX).clamp(0.0, 1.0);
    final v = (1 - y / h) * (1 - s) + s;
    setState(() {
      _s = s;
      _v = v.clamp(0.0, 1.0);
    });
    _syncHexFromColor();
  }

  bool _isInRing(Offset p) {
    final dx = p.dx - _center;
    final dy = p.dy - _center;
    final r = sqrt(dx * dx + dy * dy);
    return r >= _innerRadius && r <= _outerRadius;
  }

  bool _isInTriangle(Offset p) {
    final w = _triangleSize;
    final h = _triangleHeight;
    final left = _triangleLeft;
    final top = _triangleTop;
    final x = p.dx - left;
    final y = p.dy - top;
    if (x < 0 || x > w || y < 0 || y > h) return false;
    final rightX =
        y <= h / 2 ? y * 2 * w / h : (h - y) * 2 * w / h;
    return x <= rightX;
  }

  void _onPickDrag(Offset localPosition) {
    if (_isInRing(localPosition)) {
      _updateHueFromOffset(localPosition);
    } else if (_isInTriangle(localPosition)) {
      _updateSvFromOffset(localPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hueRad = _h * pi / 180;
    final hueMarkerX = _center + _ringMidRadius * cos(hueRad);
    final hueMarkerY = _center + _ringMidRadius * sin(hueRad);
    final w = _triangleSize;
    final h = _triangleHeight;
    final left = _triangleLeft;
    final top = _triangleTop;
    final y = _s < 1 ? h * (1 - _v) / (1 - _s) : h / 2;
    final rightX = y <= h / 2 ? y * 2 * w / h : (h - y) * 2 * w / h;
    final svX = left + _s * rightX;
    final svY = top + y.clamp(0.0, h);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onPanStart: (d) => _onPickDrag(d.localPosition),
          onPanUpdate: (d) => _onPickDrag(d.localPosition),
          onTapDown: (d) => _onPickDrag(d.localPosition),
          child: SizedBox(
            width: _wheelSize,
            height: _wheelSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(_wheelSize, _wheelSize),
                  painter: _HollowCircumcirclePainter(
                    center: _center,
                    innerRadius: _innerRadius,
                    hollowColor: cs.surface,
                  ),
                ),
                CustomPaint(
                  size: Size(_wheelSize, _wheelSize),
                  painter: _HueRingPainter(
                    center: _center,
                    innerRadius: _innerRadius,
                    outerRadius: _outerRadius,
                    hollowColor: cs.surface,
                  ),
                ),
                Positioned(
                  left: _triangleLeft,
                  top: _triangleTop,
                  child: CustomPaint(
                    size: Size(_triangleSize, _triangleHeight),
                    painter: _SatValTrianglePainter(hue: _h),
                  ),
                ),
                Positioned(
                  left: hueMarkerX - _hueMarkerRadius,
                  top: hueMarkerY - _hueMarkerRadius,
                  child: Container(
                    width: _hueMarkerRadius * 2,
                    height: _hueMarkerRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.black87, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: svX - _markerRadius,
                  top: svY - _markerRadius,
                  child: Container(
                    width: _markerRadius * 2,
                    height: _markerRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.black87, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildColorChipRow(
                context,
                'Common',
                widget.commonColors,
                cs,
              ),
              if (widget.recentColors.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildColorChipRow(
                  context,
                  'Recent',
                  widget.recentColors,
                  cs,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 160,
          child: VTextBox(
            controller: _hexController,
            label: 'Hex',
            hint: 'RRGGBB',
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f]')),
              LengthLimitingTextInputFormatter(6),
            ],
            onChanged: _onHexChanged,
            onSubmitted: (_) => _applyHexInput(),
            onEditingComplete: _applyHexInput,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 256, // match width of 6 common color chips (6*36 + 5*8)
          height: 40,
          decoration: BoxDecoration(
            color: _currentColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: cs.outline),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            VButton(
              label: 'Cancel',
              variant: VButtonVariant.text,
              onPressed: widget.onClose,
            ),
            const SizedBox(width: 8),
            VButton(
              label: 'Apply',
              onPressed: () {
                widget.onPick(_currentColor);
                widget.onClose();
              },
            ),
          ],
        ),
      ],
    );

    if (widget.contentWidth != null) {
      return SizedBox(width: widget.contentWidth, child: content);
    }
    return content;
  }
}
