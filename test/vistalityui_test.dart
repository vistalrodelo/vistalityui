import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vistalityui/vistalityui.dart';

void main() {
  testWidgets('buildTheme exposes status colors and component themes', (tester) async {
    final theme = buildTheme(const Color(0xFFEF7A10));
    expect(theme.useMaterial3, isTrue);
    expect(theme.extension<VColors>()!.success, const Color(0xFF15803D));
    expect(theme.extension<VColors>()!.warning, const Color(0xFFB45309));
    expect(theme.extension<VColors>()!.info, const Color(0xFF0369A1));
    expect(theme.inputDecorationTheme.filled, isTrue);
    expect(theme.snackBarTheme.behavior, SnackBarBehavior.floating);

    final dark = buildTheme(const Color(0xFFEF7A10), brightness: Brightness.dark);
    expect(dark.extension<VColors>()!.success, const Color(0xFF4ADE80));
  });

  testWidgets('VButton calls onPressed and blocks taps while loading', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _app(
        Column(
          children: [
            VButton(label: 'Save', onPressed: () => taps++),
            const VButton(label: 'Wait', onPressed: _noop, loading: true),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(taps, 1);

    await tester.tap(find.byType(CircularProgressIndicator));
    await tester.pump();
    expect(taps, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('VTextBox autofocuses and shows prefix text', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      _app(
        VTextBox(
          controller: controller,
          label: 'Price',
          prefixText: '₱ ',
          autofocus: true,
        ),
      ),
    );

    expect(tester.testTextInput.isVisible, isTrue);
    expect(find.text('₱ '), findsOneWidget);
    controller.dispose();
  });

  testWidgets('VCard reports taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _app(
        VCard(
          onTap: () => taps++,
          margin: const EdgeInsets.all(8),
          child: const Text('Open note'),
        ),
      ),
    );

    await tester.tap(find.text('Open note'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('VAlert dismisses through onClose', (tester) async {
    var closed = false;
    await tester.pumpWidget(
      _app(
        VAlert(
          title: 'Saved',
          message: 'Profile updated',
          onClose: () => closed = true,
        ),
      ),
    );

    await tester.tap(find.byTooltip('Dismiss'));
    await tester.pump();
    expect(closed, isTrue);
  });

  testWidgets('VTabs shows the selected panel', (tester) async {
    await tester.pumpWidget(
      _app(
        const VTabs(
          tabs: [
            VTabItem(label: 'Overview', child: Text('Overview content')),
            VTabItem(label: 'Activity', child: Text('Activity content')),
          ],
        ),
      ),
    );

    expect(find.text('Overview content'), findsOneWidget);
    await tester.tap(find.text('Activity'));
    await tester.pump();
    expect(find.text('Activity content'), findsOneWidget);
    expect(find.text('Overview content'), findsNothing);
  });

  testWidgets('VPagination reports the selected page', (tester) async {
    var page = 1;
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (context, setState) {
            return VPagination(
              page: page,
              pageCount: 12,
              onPageChanged: (value) => setState(() => page = value),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('2'));
    await tester.pump();
    expect(page, 2);
  });

  testWidgets('VToast shows a message', (tester) async {
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) {
            return VButton(
              label: 'Notify',
              onPressed: () => VToast.show(
                context,
                message: 'Invite sent',
                intent: VIntent.success,
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Notify'));
    await tester.pump();
    expect(find.text('Invite sent'), findsOneWidget);
  });

  testWidgets('VFilterableTable hides rows that do not match', (tester) async {
    await tester.pumpWidget(_app(const _FilterHost()));
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'ali');
    await tester.pump();

    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsNothing);
  });

  testWidgets('VTextFormField reports validation errors', (tester) async {
    final formKey = GlobalKey<FormState>();
    await tester.pumpWidget(
      _app(
        Form(
          key: formKey,
          child: const VTextFormField(
            label: 'Email',
            validator: _required,
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'ada@example.com');
    await tester.pump();
    expect(formKey.currentState!.validate(), isTrue);
  });

  testWidgets('VBarChart renders item labels', (tester) async {
    await tester.pumpWidget(
      _app(
        const VBarChart(
          items: [
            VBarChartItem(label: 'Mon', value: 4),
            VBarChartItem(label: 'Tue', value: 0),
          ],
        ),
      ),
    );
    expect(find.text('Mon'), findsOneWidget);
    expect(find.text('Tue'), findsOneWidget);
  });

  testWidgets('VDialog.confirm returns true', (tester) async {
    bool? result;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) {
            return VButton(
              label: 'Open',
              onPressed: () async {
                result = await VDialog.confirm(
                  context,
                  title: 'Delete?',
                  message: 'This cannot be undone.',
                  confirmLabel: 'Delete',
                );
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('This cannot be undone.'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });
}

Widget _app(Widget child) {
  return MaterialApp(
    theme: buildTheme(const Color(0xFFEF7A10)),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void _noop() {}

String? _required(String? value) {
  if (value == null || value.trim().isEmpty) return 'Required';
  return null;
}

class _FilterHost extends StatefulWidget {
  const _FilterHost();

  @override
  State<_FilterHost> createState() => _FilterHostState();
}

class _FilterHostState extends State<_FilterHost> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    return VFilterableTable(
      filterText: _filter,
      onFilterChanged: (value) => setState(() => _filter = value),
      columns: const [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Role')),
      ],
      rows: const [
        DataRow(cells: [DataCell(Text('Alice')), DataCell(Text('Admin'))]),
        DataRow(cells: [DataCell(Text('Bob')), DataCell(Text('Editor'))]),
      ],
    );
  }
}
