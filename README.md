# Vistality UI

A reusable Flutter UI component library with a Material 3 theme foundation, opinionated defaults, and easy customization.

![Vistality UI playground](../assets/vistalityui_playground.png)

## Features
- Material 3 based theme with seed-driven color scheme
- Intent-based components (primary, secondary, success, warning, danger)
- Consistent radius system with `VRadius` and per-component overrides
- Ready-to-use input, layout, and data display components
- Playground example app under `example/` (with dark-mode toggle and color overrides)

## Installation

### From pub.dev (recommended for users)

In your app’s `pubspec.yaml`:

```yaml
dependencies:
  vistalityui: ^2.1.0
```

Then run:

```bash
flutter pub get
```

### Local development (working on this repo)

Inside this monorepo, the example app depends on the local package using a path:

```yaml
dependencies:
  vistalityui:
    path: ..
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
![App screenshot](./assets/1.png)
![App screenshot](./assets/2.png)
![App screenshot](./assets/3.png)
![App screenshot](./assets/4.png)
![App screenshot](./assets/5.png)
![App screenshot](./assets/6.png)

## Theme and radius

`buildTheme` accepts a seed color and uses Material 3 to generate the palette.

- In **light mode**, the seed color is also used directly as the primary color, with `onPrimary` derived from its luminance.
- In **dark mode**, the full Material 3 dark `ColorScheme.fromSeed` is used so colors follow the standard Material behavior for dark themes.

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

## Playground / example app

The full playground lives in the package `example/` folder and is wired as a normal Flutter example app. It showcases:

- All component groups
- **Color overrides** for buttons and controls (e.g. `VButton.backgroundColor`, `VCheckbox.activeColor`, `VSegmented.selectedColor`, etc.)
- A top-right **dark mode toggle** (built with `VSwitch`) that flips `ThemeMode` between light and dark while still using the same seed-based Material 3 theming.

Run it from the package directory:

```bash
cd vistalityui/example
flutter run
```

## License

See `LICENSE`.
