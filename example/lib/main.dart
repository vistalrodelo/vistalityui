import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vistalityui/vistalityui.dart';

import 'component_showcase_screen.dart';
//const kBrandSeed = Color(0xFF1565C0);//Color(0xFF0D47A1);// your brand color
//const kBrandSeed = Color(0xFFEF7A10);
const kBrandSeed = Color(0xFF0D47A1);
void main() {
  runApp(const VistalityUIPlayground());
}

class VistalityUIPlayground extends StatefulWidget {
  const VistalityUIPlayground({super.key});

  @override
  State<VistalityUIPlayground> createState() => _VistalityUIPlaygroundState();
}

class _VistalityUIPlaygroundState extends State<VistalityUIPlayground> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildTheme(
        kBrandSeed,
        brightness: Brightness.light,
        defaultRadius: VRadiusSize.none,
        textThemeBuilder: GoogleFonts.latoTextTheme,
      ),
      darkTheme: buildTheme(
        kBrandSeed,
        brightness: Brightness.dark,
        defaultRadius: VRadiusSize.none,
        textThemeBuilder: GoogleFonts.latoTextTheme,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      title: 'VistalityUI Playground',
      home: ComponentShowcaseScreen(
        isDarkMode: _isDarkMode,
        onDarkModeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
        },
      ),
    );
  }
}
