# Vistality UI

A reusable Flutter UI component library with a Material 3 theme foundation, opinionated defaults, and easy customization.

## Features
- Material 3 based theme with seed-driven color scheme
- Intent-based components (primary, secondary, success, warning, danger)
- Consistent radius system with `VRadius` and per-component overrides
- Ready-to-use input, layout, and data display components
- Playground app included (`vistalityui_playground`)

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  vistalityui:
    path: ../vistalityui
```

## Quick start

```dart
import 'package:flutter/material.dart';
import 'package:vistalityui/vistalityui.dart';

const kBrandSeed = Color(0xFFEF7A10);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildTheme(
        kBrandSeed,
        brightness: Brightness.light,
        defaultRadius: VRadiusSize.md,
        fontFamily: 'Inter',
        fontFamilyFallback: const ['Roboto', 'Arial'],
      ),
      darkTheme: buildTheme(
        kBrandSeed,
        brightness: Brightness.dark,
        defaultRadius: VRadiusSize.md,
        fontFamily: 'Inter',
        fontFamilyFallback: const ['Roboto', 'Arial'],
      ),
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(
          child: VButton(label: 'Primary', onPressed: null),
        ),
      ),
    );
  }
}
```

## Theme and radius

`buildTheme` accepts a seed color and uses Material 3 to generate the palette. The primary color follows the seed.

You can set the default radius with `VRadiusSize` or a number:

```dart
buildTheme(kBrandSeed, defaultRadius: VRadiusSize.md);
buildTheme(kBrandSeed, defaultRadius: 24);
```

You can also set a global font and fallback list:

```dart
buildTheme(
  kBrandSeed,
  fontFamily: 'Inter',
  fontFamilyFallback: const ['Roboto', 'Arial'],
);
```

If you want a default font when `fontFamily` isn't set, use `defaultFontFamily`:

```dart
buildTheme(
  kBrandSeed,
  defaultFontFamily: 'Inter',
);
```

You can also use Google Fonts by passing a text theme builder:

```dart
import 'package:google_fonts/google_fonts.dart';

final theme = buildTheme(
  kBrandSeed,
  textThemeBuilder: GoogleFonts.interTextTheme,
);
```

Per-component overrides:

```dart
VButton(radius: VRadiusSize.lg, onPressed: () {}, label: 'Large Radius');
VButton(radius: 30, onPressed: () {}, label: 'Custom Radius');
```

## Inputs with icons

Most text input components accept `prefixIcon` and `suffixIcon` as either `IconData` or a widget:

```dart
VTextBox(
  controller: TextEditingController(),
  label: 'Email Address',
  prefixIcon: Icons.email,
  suffixIcon: Icons.check,
);
```

## Component categories

- Foundations: typography, theme colors
- Buttons & Actions: buttons, button groups, icon buttons, menus
- Data Display: cards, tables, lists, grids, timelines
- Forms & Text: forms, text boxes
- Inputs & Selection: dropdowns, chips, date/time pickers, sliders, segmented
- Feedback: alerts, banners, toasts
- Layout & Structure: header, sidebar, breadcrumbs
- Navigation: tabs, pagination
- Overlays: dialogs, popovers
- Utilities: clipboard, status
- Charts: basic charts

## Playground

Run the playground app to preview all components:

```bash
cd vistalityui_playground
flutter run
```

## License

See `LICENSE`.
