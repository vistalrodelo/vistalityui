import 'package:flutter/material.dart';

enum VHeadingLevel { h1, h2, h3, h4, h5, h6 }

class VText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

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

class VHeading extends StatelessWidget {
  final String text;
  final VHeadingLevel level;
  final TextAlign? textAlign;

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

class VLabel extends StatelessWidget {
  final String text;
  const VLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.labelLarge);
  }
}

class VCaption extends StatelessWidget {
  final String text;
  const VCaption(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.bodySmall);
  }
}

class VCode extends StatelessWidget {
  final String text;
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

class VTruncatedText extends StatelessWidget {
  final String text;
  final int maxLines;
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

class VSelectableText extends StatelessWidget {
  final String text;
  const VSelectableText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return SelectableText(text);
  }
}
