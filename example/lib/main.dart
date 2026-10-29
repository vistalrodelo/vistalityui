import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vistalityui/vistalityui.dart';

import 'playground_fonts.dart';
import 'playground_sidebar_screen.dart';
void main() {
  runApp(const VistalityUIPlayground());
}

/// Default seed color; theme is generated from this via ColorScheme.fromSeed.
const kDefaultSeedColor = Color(0xFF0D47A1);

class VistalityUIPlayground extends StatefulWidget {
  const VistalityUIPlayground({super.key});

  @override
  State<VistalityUIPlayground> createState() => _VistalityUIPlaygroundState();
}

class _VistalityUIPlaygroundState extends State<VistalityUIPlayground> {
  bool _isDarkMode = false;
  Color _seedColor = kDefaultSeedColor;
  VRadiusSize _radiusSize = VRadiusSize.sm;
  double? _customRadius; // when set, theme uses this instead of _radiusSize
  String _selectedFontId = 'Poppins';
  TextTheme Function(TextTheme) _textThemeBuilder = GoogleFonts.poppinsTextTheme;

  @override
  void initState() {
    super.initState();
    _preloadFont(_selectedFontId);
  }

  void _preloadFont(String fontId) {
    unawaited(
      GoogleFonts.pendingFonts([GoogleFonts.getFont(fontId)]).then((_) {
        if (mounted) setState(() {});
      }),
    );
  }

  void _onFontChanged(String id, TextTheme Function(TextTheme) builder) {
    setState(() {
      _selectedFontId = id;
      _textThemeBuilder = builder;
    });
    _preloadFont(id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildTheme(
        _seedColor,
        brightness: Brightness.light,
        defaultRadius: _customRadius ?? _radiusSize,
        textThemeBuilder: _textThemeBuilder,
      ),
      darkTheme: buildTheme(
        _seedColor,
        brightness: Brightness.dark,
        defaultRadius: _customRadius ?? _radiusSize,
        textThemeBuilder: _textThemeBuilder,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      title: 'VistalityUI Playground',
      home: PlaygroundSidebarScreen(
        isDarkMode: _isDarkMode,
        onDarkModeChanged: (value) => setState(() => _isDarkMode = value),
        seedColor: _seedColor,
        onSeedColorChanged: (value) => setState(() => _seedColor = value),
        radiusSize: _radiusSize,
        onRadiusSizeChanged: (value) =>
            setState(() {
              _radiusSize = value;
              _customRadius = null;
            }),
        customRadius: _customRadius,
        onCustomRadiusChanged: (value) => setState(() => _customRadius = value),
        getFontOptions: () => kPlaygroundFontOptions,
        selectedFontId: _selectedFontId,
        onFontChanged: _onFontChanged,
      ),
    );
  }
}
