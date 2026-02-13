import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// One font option for the playground. Built from id/name only; no style work until needed.
class PlaygroundFontOption {
  const PlaygroundFontOption({
    required this.id,
    required this.name,
    required this.textThemeBuilder,
  });
  final String id;
  final String name;
  final TextTheme Function(TextTheme) textThemeBuilder;

  /// Resolve fontFamily on demand (for list tile); avoids building 1000+ styles at init.
  String? get fontFamily => GoogleFonts.getFont(id).fontFamily;
}

List<PlaygroundFontOption>? _cachedFontOptions;

/// All available Google Fonts: ids/names only, sorted. Cached after first access. No style work at build time.
List<PlaygroundFontOption> get kPlaygroundFontOptions {
  _cachedFontOptions ??= () {
    final keys = GoogleFonts.asMap().keys.toList()..sort();
    return keys.map((id) => PlaygroundFontOption(
      id: id,
      name: id,
      textThemeBuilder: (base) => base.apply(
        fontFamily: GoogleFonts.getFont(id).fontFamily,
      ),
    )).toList();
  }();
  return _cachedFontOptions!;
}
