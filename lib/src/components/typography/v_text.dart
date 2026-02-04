import 'package:flutter/material.dart';

/// Heading levels mapped to the theme text styles.
enum VHeadingLevel {
  /// Display large heading.
  h1,

  /// Display medium heading.
  h2,

  /// Display small heading.
  h3,

  /// Headline medium heading.
  h4,

  /// Headline small heading.
  h5,

  /// Title large heading.
  h6,
}

/// Basic text widget wrapper.
class VText extends StatelessWidget {
  /// Text content.
  final String text;

  /// Optional text style override.
  final TextStyle? style;

  /// Optional text alignment.
  final TextAlign? textAlign;

  /// Maximum number of lines to display.
  final int? maxLines;

  /// Overflow behavior.
  final TextOverflow? overflow;

  /// Creates a [VText].
  const VText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Heading text that maps to theme display/title styles.
class VHeading extends StatelessWidget {
  /// Text content.
  final String text;

  /// Heading level.
  final VHeadingLevel level;

  /// Optional text alignment.
  final TextAlign? textAlign;

  /// Creates a [VHeading].
  const VHeading(
    this.text, {
    super.key,
    this.level = VHeadingLevel.h3,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final style = switch (level) {
      VHeadingLevel.h1 => theme.displayLarge,
      VHeadingLevel.h2 => theme.displayMedium,
      VHeadingLevel.h3 => theme.displaySmall,
      VHeadingLevel.h4 => theme.headlineMedium,
      VHeadingLevel.h5 => theme.headlineSmall,
      VHeadingLevel.h6 => theme.titleLarge,
    };
    return Text(text, style: style, textAlign: textAlign);
  }
}

/// Label text using `labelLarge`.
class VLabel extends StatelessWidget {
  /// Text content.
  final String text;

  /// Creates a [VLabel].
  const VLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.labelLarge);
  }
}

/// Caption text using `bodySmall`.
class VCaption extends StatelessWidget {
  /// Text content.
  final String text;

  /// Creates a [VCaption].
  const VCaption(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.bodySmall);
  }
}

/// Monospace code-style text.
class VCode extends StatelessWidget {
  /// Text content.
  final String text;

  /// Creates a [VCode].
  const VCode(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontFamily: 'monospace'),
    );
  }
}

/// Single-line text with ellipsis overflow by default.
class VTruncatedText extends StatelessWidget {
  /// Text content.
  final String text;

  /// Maximum number of lines.
  final int maxLines;

  /// Creates a [VTruncatedText].
  const VTruncatedText(this.text, {super.key, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Selectable text wrapper.
class VSelectableText extends StatelessWidget {
  /// Text content.
  final String text;

  /// Creates a [VSelectableText].
  const VSelectableText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return SelectableText(text);
  }
}
