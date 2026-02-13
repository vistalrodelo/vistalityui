# Vistality UI Playground (`vistalityui_example`)

This is the **playground / example app** for the `vistalityui` Flutter UI library.  
It showcases the components, theming, and customization options provided by the package.

## What this app demonstrates

- **Seed-based Material 3 theming**
  - Uses `buildTheme` from `vistalityui` with a brand seed color.
  - Light mode forces the seed color as the primary.
  - Dark mode uses the full Material 3 dark `ColorScheme.fromSeed` derived from the same seed.

- **Dark mode toggle**
  - A `VSwitch` in the app bar (top-right) toggles between light and dark mode.
  - Internally this flips `ThemeMode` on the `MaterialApp`, so the **entire UI** (all components) re-themes.

- **Color overrides**
  - Examples of overriding colors for:
    - `VButton` (`backgroundColor`, `foregroundColor`, `borderColor`)
    - `VIconButton` / `VFab`
    - `VCheckbox`, `VRadio`, `VSegmented`, `VSwitch`
    - `VSlider`, `VRangeSlider`, `VRating`
    - `VTimeline`, `VAdvancedTable`, `VTextBox`, `VMultiSelectDropdown`
  - All overrides are **optional**; when not provided, components fall back to the theme’s colors and intents.

- **Component groups**
  - Foundations (typography, theme colors)
  - Buttons & actions
  - Data display (cards, tables, lists, grids, timelines)
  - Forms & text
  - Inputs & selection
  - A dedicated **Color Overrides** accordion that groups all override demos in one place.

## Running the playground

From the package root:

```bash
cd vistalityui/example
flutter pub get
flutter run
```

This will launch the playground app so you can interactively explore all components, test dark mode, and verify color overrides.
