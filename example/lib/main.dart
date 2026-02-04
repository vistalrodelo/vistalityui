import 'package:flutter/material.dart';
import 'package:vistalityui/vistalityui.dart';

/// Runs the Vistality UI example app.
void main() {
  runApp(const VistalityExampleApp());
}

/// Example app showcasing core components.
class VistalityExampleApp extends StatelessWidget {
  /// Creates a [VistalityExampleApp].
  const VistalityExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vistality UI Example',
      theme: buildTheme(const Color(0xFF6366F1)),
      home: const ExampleHomePage(),
    );
  }
}

/// Example home page with basic components.
class ExampleHomePage extends StatelessWidget {
  /// Creates an [ExampleHomePage].
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vistality UI')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const VHeading('Components', level: VHeadingLevel.h4),
          const SizedBox(height: 16),
          VButton(
            label: 'Primary action',
            onPressed: () {},
            leading: const Icon(Icons.flash_on),
          ),
          const SizedBox(height: 12),
          VButton(
            label: 'Ghost button',
            variant: VButtonVariant.ghost,
            onPressed: () {},
          ),
          const SizedBox(height: 24),
          VAccordion(
            title: 'Details',
            initiallyExpanded: true,
            child: const Text(
              'Vistality UI provides reusable components with a cohesive theme.',
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              VCheckbox(
                value: true,
                onChanged: (_) {},
              ),
              const SizedBox(width: 12),
              const Text('Enable feature'),
            ],
          ),
        ],
      ),
    );
  }
}
