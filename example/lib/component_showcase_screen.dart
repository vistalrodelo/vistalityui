import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vistalityui/vistalityui.dart';

const double _kPlaygroundButtonMaxWidth = 400;

Widget _maxWidthButton(Widget child) => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: _kPlaygroundButtonMaxWidth),
  child: child,
);

class ComponentShowcaseScreen extends StatefulWidget {
  /// Whether dark mode is currently enabled.
  final bool isDarkMode;

  /// Called when the dark mode toggle is changed.
  final ValueChanged<bool> onDarkModeChanged;

  const ComponentShowcaseScreen({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<ComponentShowcaseScreen> createState() =>
      _ComponentShowcaseScreenState();
}

class _ComponentShowcaseScreenState extends State<ComponentShowcaseScreen> {
  bool _isLoading = true;
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _errorController = TextEditingController();
  final TextEditingController _disabledController =
      TextEditingController(text: 'Disabled value');
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _multilineController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _componentSearchController =
      TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _maskedController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _chipsController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<String> _chipValues = [];
  late final List<VFormFieldConfig> _formFields;
  String? _selectedCountry;
  final List<String> _selectedFruits = [];
  String _selectedGender = 'male';
  String? _emailError;
  bool _switchValue = false;
  double _sliderValue = 25;
  RangeValues _rangeValues = const RangeValues(20, 60);
  String _segmentValue = 'weekly';
  int _ratingValue = 3;
  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;
  DateTime? _pickedDateTime;
  String _filterText = '';
  final List<bool> _expansionStates = [false, false];
  final TextEditingController _editableName = TextEditingController(text: 'Alice');
  final TextEditingController _editableRole = TextEditingController(text: 'Admin');
  final _tableSource = _SampleTableSource();
  int? _sortColumnIndex = 0;
  bool _sortAscending = true;
  final List<List<String>> _sortableRows = [
    ['Alice', 'Admin'],
    ['Bob', 'Editor'],
    ['Cara', 'Viewer'],
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
    _formFields = [
      VFormFieldConfig.text(
        prefixIcon: Icons.person,
        id: 'first_name',
        label: 'First Name',
        required: true,
      ),
      VFormFieldConfig.text(
        prefixIcon: Icons.person,
        id: 'last_name',
        label: 'Last Name',
      ),
      VFormFieldConfig.text(
        prefixIcon: Icons.email,
        id: 'email',
        label: 'Email',
        required: true,
        keyboardType: TextInputType.emailAddress,
        validator: _emailValidator,
      ),
      VFormFieldConfig<String>.dropdown(
        id: 'country',
        label: 'Country',
        hint: 'Select country',
        required: true,
        items: [
          VDropdownItem(value: 'ph', label: 'Philippines'),
          VDropdownItem(value: 'us', label: 'United States'),
          VDropdownItem(value: 'jp', label: 'Japan'),
        ],
      ),
      VFormFieldConfig<String>.radio(
        id: 'gender',
        label: 'Gender',
        required: true,
        options: [
          VRadioOption(value: 'male', label: 'Male'),
          VRadioOption(value: 'female', label: 'Female'),
        ],
      ),
      VFormFieldConfig<String>.multiselect(
        id: 'fruits',
        label: 'Favorite Fruits',
        items: [
          VMultiSelectItem(value: 'apple', label: 'Apple'),
          VMultiSelectItem(value: 'banana', label: 'Banana'),
          VMultiSelectItem(value: 'mango', label: 'Mango'),
          VMultiSelectItem(value: 'orange', label: 'Orange'),
          VMultiSelectItem(value: 'pineapple', label: 'Pineapple'),
          VMultiSelectItem(value: 'grapes', label: 'Grapes'),
          VMultiSelectItem(value: 'guava', label: 'Guava'),
          VMultiSelectItem(value: 'lemon', label: 'Lemon'),
          VMultiSelectItem(value: 'peach', label: 'Peach'),
        ],
      ),
      VFormFieldConfig.checkbox(
        id: 'terms',
        label: 'I agree to the terms',
        required: true,
      ),
      VFormFieldConfig.multiline(
        id: 'notes',
        label: 'Notes',
        hint: 'Optional notes',
        allowClearButton: true,
        allowNewLineButton: true,
      ),
    ];
  }

  @override
  void dispose() {
    _textController.dispose();
    _errorController.dispose();
    _disabledController.dispose();
    _passwordController.dispose();
    _multilineController.dispose();
    _emailController.dispose();
    _searchController.dispose();
    _componentSearchController.dispose();
    _numberController.dispose();
    _maskedController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _dateTimeController.dispose();
    _chipsController.dispose();
    _editableName.dispose();
    _editableRole.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VistalityUI – Component Showcase'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: VSwitch(
                value: widget.isDarkMode,
                onChanged: widget.onDarkModeChanged,
                label: 'Dark mode',
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? _buildSkeletonPage()
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VTextBox(
                    controller: _componentSearchController,
                    label: 'Search components',
                    hint: 'Type a component name',
                    prefixIcon: const Icon(Icons.search),
                    allowClearButton: true,
                    onChanged: (value) => setState(() => _filterText = value),
                  ),
                  const SizedBox(height: 12),
                  ..._buildShowcaseSections(context, query: _filterText),
                ],
              ),
            ),
    );
  }

  Widget _buildSkeletonPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _skeletonLine(width: 220, height: 20),
          const SizedBox(height: 12),
          _skeletonLine(width: 140, height: 16),
          const SizedBox(height: 12),
          _skeletonBlock(height: 120),
          const SizedBox(height: 16),
          _skeletonLine(width: 180, height: 16),
          const SizedBox(height: 12),
          _skeletonBlock(height: 200),
          const SizedBox(height: 16),
          _skeletonLine(width: 200, height: 16),
          const SizedBox(height: 12),
          _skeletonBlock(height: 140),
          const SizedBox(height: 16),
          _skeletonLine(width: 160, height: 16),
          const SizedBox(height: 12),
          _skeletonBlock(height: 180),
        ],
      ),
    );
  }

  Widget _skeletonLine({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _skeletonBlock({required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
  Widget _wrap(List<Widget> children) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: children,
    );
  }

  Widget _buildThemeColorTiles(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = <String, Color>{
      'Primary': scheme.primary,
      'On Primary': scheme.onPrimary,
      'Primary Container': scheme.primaryContainer,
      'On Primary Container': scheme.onPrimaryContainer,
      'Secondary': scheme.secondary,
      'On Secondary': scheme.onSecondary,
      'Tertiary': scheme.tertiary,
      'On Tertiary': scheme.onTertiary,
      'Background': scheme.background,
      'On Background': scheme.onBackground,
      'Surface': scheme.surface,
      'On Surface': scheme.onSurface,
      'Surface Variant': scheme.surfaceVariant,
      'On Surface Variant': scheme.onSurfaceVariant,
      'Outline': scheme.outline,
      'Error': scheme.error,
      'On Error': scheme.onError,
      'Error Container': scheme.errorContainer,
      'On Error Container': scheme.onErrorContainer,
    };

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.entries
          .map((entry) => _colorTile(entry.key, entry.value))
          .toList(),
    );
  }

  Widget _colorTile(String label, Color color) {
    final textColor =
        color.computeLuminance() > 0.55 ? Colors.black : Colors.white;
    return Container(
      constraints: const BoxConstraints(minWidth: 160),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _colorHex(color),
            style: TextStyle(
              color: textColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _autoSizerTile(String label, Color color, Color textColor) {
    return Container(
      width: 140,
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        //borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<Widget> _buildShowcaseSections(
    BuildContext context, {
    String query = '',
  }) {
    final normalized = query.trim().toLowerCase();
    final scheme = Theme.of(context).colorScheme;
    final sections = <Widget>[];

    void addSection(String title, List<_DemoItem> items) {
      final filtered = _filterItems(title, items, normalized);
      if (filtered.isEmpty) return;
      if (sections.isNotEmpty) {
        sections.add(const SizedBox(height: 12));
      }
      sections.add(_groupSection(title, filtered));
    }

    addSection(
      'Foundations',
      [
        _DemoItem(
          title: 'Typography',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              VHeading('Heading 1', level: VHeadingLevel.h1),
              SizedBox(height: 8),
              VHeading('Heading 2', level: VHeadingLevel.h2),
              SizedBox(height: 8),
              VHeading('Heading 3', level: VHeadingLevel.h3),
              SizedBox(height: 8),
              VHeading('Heading 4', level: VHeadingLevel.h4),
              SizedBox(height: 8),
              VHeading('Heading 5', level: VHeadingLevel.h5),
              SizedBox(height: 8),
              VHeading('Heading 6', level: VHeadingLevel.h6),
            ],
          ),
        ),
        _DemoItem(
          title: 'Theme Colors',
          child: _buildThemeColorTiles(context),
        ),
      ],
    );

    addSection(
      'Layout',
      [
        _DemoItem(
          title: 'Auto Sizer',
          child: SizedBox(
            height: 420,
            child: VAutoSizer(
              mobileLayout: VAutoSizerLayout.column,
              tabletLayout: VAutoSizerLayout.wrap,
              webLayout: VAutoSizerLayout.wrap,
              minItemWidth: 240,
              maxColumns: 3,
              spacing: 12,
              runSpacing: 12,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _autoSizerTile(
                  'Overview',
                  scheme.primaryContainer,
                  scheme.onPrimaryContainer,
                ),
                _autoSizerTile(
                  'Reports',
                  scheme.secondaryContainer,
                  scheme.onSecondaryContainer,
                ),
                VTextBox(
                  controller: _textController,
                  label: 'Title',
                  hint: 'Type here',
                ),
                _maxWidthButton(VButton(
                  label: 'Create',
                  onPressed: () {},
                )),
                VDatePickerField(
                  controller: _dateController,
                  value: _pickedDate,
                  label: 'Start Date',
                  prefixIcon: Icons.calendar_today,
                  onChanged: (v) => setState(() => _pickedDate = v),
                ),
                VMultiSelectDropdown<String>(
                  label: 'Fruits',
                  //hint: 'Select fruits',
                  values: _selectedFruits,
                  items: const [
                    VMultiSelectItem(value: 'apple', label: 'Apple'),
                    VMultiSelectItem(value: 'banana', label: 'Banana'),
                    VMultiSelectItem(value: 'mango', label: 'Mango'),
                  ],
                  onChanged: (values) {
                    setState(() {
                      _selectedFruits
                        ..clear()
                        ..addAll(values);
                    });
                  },
                ),
                VChipsInput(
                  controller: _chipsController,
                  values: _chipValues,
                  label: 'Tags',
                  prefixIcon: Icons.tag,
                  onChanged: (values) {
                    setState(() {
                      _chipValues
                        ..clear()
                        ..addAll(values);
                    });
                  },
                ),
                VDropdown<String>(
                  label: 'Country',
                  hint: 'Select country',
                  value: _selectedCountry,
                  items: const [
                    VDropdownItem(value: 'ph', label: 'Philippines'),
                    VDropdownItem(value: 'us', label: 'United States'),
                    VDropdownItem(value: 'jp', label: 'Japan'),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedCountry = value);
                  },
                ),
                VOtpInput(
                  length: 4,
                )
              ],
            ),
          ),
        ),
      ],
    );

    addSection(
      'Buttons & Actions',
      [
        _DemoItem(
          title: 'Buttons',
          child: Column(
            children: _buildAccordionList([
              _DemoItem(
                title: 'Buttons – Full Width',
                child: _maxWidthButton(VButton(
                  label: 'Continue',
                  fullWidth: true,
                  size: VButtonSize.lg,
                  onPressed: () {},
                )),
              ),
              _DemoItem(
                title: 'Buttons – Group',
                child: VButtonGroup(
                  children: [
                    VPrimaryButton(label: 'Save', onPressed: () {}),
                    VSecondaryButton(label: 'Cancel', onPressed: () {}),
                    VGhostButton(label: 'More', onPressed: () {}),
                  ],
                ),
              ),
              _DemoItem(
                title: 'Buttons – Icon/FAB',
                child: _wrap([
                  VIconButton(
                    icon: Icons.favorite,
                    tooltip: 'Favorite',
                    onPressed: () {},
                  ),
                  VFab(
                    icon: Icons.add,
                    tooltip: 'Add',
                    onPressed: () {},
                  ),
                ]),
              ),
              _DemoItem(
                title: 'Buttons – Intents',
                child: _wrap([
                  _maxWidthButton(VButton(label: 'Primary', onPressed: () {})),
                  _maxWidthButton(VButton(
                    label: 'Secondary',
                    intent: VIntent.secondary,
                    onPressed: () {},
                  )),
                  _maxWidthButton(VButton(
                    label: 'Success',
                    intent: VIntent.success,
                    onPressed: () {},
                  )),
                  _maxWidthButton(VButton(
                    label: 'Warning',
                    intent: VIntent.warning,
                    onPressed: () {},
                  )),
                  _maxWidthButton(VButton(
                    label: 'Danger',
                    intent: VIntent.danger,
                    onPressed: () {},
                  )),
                ]),
              ),
              _DemoItem(
                title: 'Buttons – Sizes',
                child: _wrap([
                  _maxWidthButton(VButton(
                    label: 'Small',
                    size: VButtonSize.sm,
                    onPressed: () {},
                  )),
                  _maxWidthButton(VButton(
                    label: 'Medium',
                    size: VButtonSize.md,
                    onPressed: () {},
                  )),
                  _maxWidthButton(VButton(
                    label: 'Large',
                    size: VButtonSize.lg,
                    onPressed: () {},
                  )),
                ]),
              ),
              _DemoItem(
                title: 'Buttons – States',
                child: _wrap([
                  _maxWidthButton(VButton(
                    label: 'Disabled',
                    onPressed: null,
                  )),
                  _maxWidthButton(VButton(
                    label: 'Loading',
                    loading: true,
                    onPressed: () {},
                  )),
                ]),
              ),
              _DemoItem(
                title: 'Buttons – Variants',
                child: _wrap([
                  _maxWidthButton(VButton(
                    label: 'Primary',
                    onPressed: () {},
                    variant: VButtonVariant.solid,
                  )),
                  _maxWidthButton(VButton(
                    label: 'Secondary',
                    intent: VIntent.secondary,
                    variant: VButtonVariant.solid,
                    onPressed: () {},
                  )),
                  _maxWidthButton(VButton(
                    label: 'Ghost',
                    intent: VIntent.secondary,
                    variant: VButtonVariant.ghost,
                    onPressed: () {},
                  )),
                  _maxWidthButton(VButton(
                    label: 'Text',
                    variant: VButtonVariant.text,
                    onPressed: () {},
                  )),
                  _maxWidthButton(VButton(
                    label: 'Destructive',
                    intent: VIntent.danger,
                    onPressed: () {},
                  )),
                  _maxWidthButton(VButton(
                    label: 'Disabled',
                    onPressed: null,
                  )),
                  _maxWidthButton(VButton(
                    label: 'Loading',
                    loading: true,
                    onPressed: () {},
                  )),
                ]),
              ),
              _DemoItem(
                title: 'Buttons – Overrides',
                child: _wrap([
                  _maxWidthButton(VButton(
                    label: 'Custom colors',
                    onPressed: () {},
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    borderColor: Colors.deepOrange,
                    leading: const Icon(Icons.color_lens),
                  )),
                  _maxWidthButton(VButton(
                    label: 'Override text only',
                    onPressed: () {},
                    foregroundColor: Colors.pinkAccent,
                  )),
                ]),
              ),
            ]),
          ),
        ),
        _DemoItem(
          title: 'Context Menu',
          child: VContextMenu(
            items: [
              VContextMenuItem(label: 'Copy', onSelected: () {}),
              VContextMenuItem(label: 'Paste', onSelected: () {}),
              VContextMenuItem(label: 'Delete', onSelected: () {}),
            ],
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: const Text('Right-click / long-press me'),
            ),
          ),
        ),
        _DemoItem(
          title: 'Overflow Menu',
          child: VOverflowMenu(
            items: [
              VOverflowItem(label: 'Rename', onSelected: () {}),
              VOverflowItem(label: 'Move', onSelected: () {}),
              VOverflowItem(label: 'Delete', onSelected: () {}),
            ],
          ),
        ),
        _DemoItem(
          title: 'Toolbar Actions',
          child: VToolbarActions(
            actions: [
              VIconButton(icon: Icons.edit, onPressed: () {}),
              VIconButton(icon: Icons.delete, onPressed: () {}),
            ],
            overflowItems: [
              VOverflowItem(label: 'Duplicate', onSelected: () {}),
              VOverflowItem(label: 'Archive', onSelected: () {}),
            ],
          ),
        ),
      ],
    );

    addSection(
      'Data Display',
      [
        _DemoItem(
          title: 'Accordion',
          child: VAccordion(
            title: 'Inner Accordion',
            child: const Text('Accordion content'),
          ),
        ),
        _DemoItem(
          title: 'Action Card',
          child: VActionCard(
            title: 'Invite User',
            description: 'Send an invite to a new team member.',
            actions: [
              _maxWidthButton(VButton(label: 'Cancel', variant: VButtonVariant.text, onPressed: () {})),
              _maxWidthButton(VButton(label: 'Send', onPressed: () {})),
            ],
          ),
        ),
        _DemoItem(
          title: 'Advanced Table',
          child: VAdvancedTable(
            headers: const ['Name', 'Role'],
            rows: const [
              ['Alice', 'Admin'],
              ['Bob', 'Editor'],
              ['Cara', 'Viewer'],
              ['Dave', 'Owner'],
              ['Ella', 'Analyst'],
              ['Faye', 'Viewer'],
            ],
            rowsPerPage: 3,
          ),
        ),
        _DemoItem(
          title: 'Basic Card',
          child: VCard(child: const Text('Basic card content')),
        ),
        _DemoItem(
          title: 'Card List',
          child: VListView(
            children: const [
              VCard(child: Text('Card A')),
              VCard(child: Text('Card B')),
              VCard(child: Text('Card C')),
            ],
          ),
        ),
        _DemoItem(
          title: 'Dashboard Tile',
          child: VDashboardTile(
            title: 'Revenue',
            subtitle: '\$12,540',
            icon: Icons.trending_up,
          ),
        ),
        _DemoItem(
          title: 'Data Table',
          child: VDataTable(
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Role')),
            ],
            rows: const [
              DataRow(cells: [DataCell(Text('Alice')), DataCell(Text('Admin'))]),
              DataRow(cells: [DataCell(Text('Bob')), DataCell(Text('Editor'))]),
            ],
          ),
        ),
        _DemoItem(
          title: 'Editable Table',
          child: VEditableTable(
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Role')),
            ],
            rows: [
              [
                TextField(controller: _editableName),
                TextField(controller: _editableRole),
              ],
            ],
          ),
        ),
        _DemoItem(
          title: 'Expansion Panel',
          child: VExpansionPanelList(
            items: [
              VExpansionItem(
                header: 'Panel 1',
                body: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Panel 1 content'),
                ),
                expanded: _expansionStates[0],
              ),
              VExpansionItem(
                header: 'Panel 2',
                body: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Panel 2 content'),
                ),
                expanded: _expansionStates[1],
              ),
            ],
            onToggle: (index) {
              setState(() => _expansionStates[index] = !_expansionStates[index]);
            },
          ),
        ),
        _DemoItem(
          title: 'Feed',
          child: VFeed(
            items: const [
              VFeedItem(title: 'New comment', body: 'Alice commented on issue #12', time: '2m'),
              VFeedItem(title: 'Deploy', body: 'Version 1.2 shipped to prod', time: '1h'),
            ],
          ),
        ),
        _DemoItem(
          title: 'Grid View',
          child: VGridView(
            columns: 3,
            children: List.generate(
              6,
              (i) => VCard(child: Center(child: Text('Item ${i + 1}'))),
            ),
          ),
        ),
        _DemoItem(
          title: 'List View',
          child: VListView(
            children: const [
              ListTile(title: Text('Item A')),
              ListTile(title: Text('Item B')),
              ListTile(title: Text('Item C')),
            ],
          ),
        ),
        _DemoItem(
          title: 'Media Card',
          child: VMediaCard(
            title: 'Beach',
            subtitle: 'Summer vibes',
            image: const NetworkImage('https://picsum.photos/300'),
          ),
        ),
        _DemoItem(
          title: 'Paginated Table',
          child: VPaginatedTable(
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Role')),
            ],
            source: _tableSource,
            rowsPerPage: 5,
          ),
        ),
        _DemoItem(
          title: 'Profile Card',
          child: VProfileCard(
            name: 'Jane Doe',
            subtitle: 'Product Manager',
            avatar: const NetworkImage('https://picsum.photos/100'),
          ),
        ),
        _DemoItem(
          title: 'Sortable Table',
          child: VSortableTable(
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            columns: [
              DataColumn(
                label: const Text('Name'),
                onSort: (index, ascending) {
                  setState(() {
                    _sortColumnIndex = index;
                    _sortAscending = ascending;
                    _sortableRows.sort((a, b) =>
                        ascending ? a[0].compareTo(b[0]) : b[0].compareTo(a[0]));
                  });
                },
              ),
              DataColumn(
                label: const Text('Role'),
                onSort: (index, ascending) {
                  setState(() {
                    _sortColumnIndex = index;
                    _sortAscending = ascending;
                    _sortableRows.sort((a, b) =>
                        ascending ? a[1].compareTo(b[1]) : b[1].compareTo(a[1]));
                  });
                },
              ),
            ],
            rows: _sortableRows
                .map((r) => DataRow(cells: [DataCell(Text(r[0])), DataCell(Text(r[1]))]))
                .toList(),
          ),
        ),
        _DemoItem(
          title: 'Stats Card',
          child: VStatsCard(label: 'Active Users', value: '1,245', change: '+6%'),
        ),
        _DemoItem(
          title: 'Sticky Header Table',
          child: VStickyHeaderTable(
            headers: const ['Name', 'Role'],
            rows: const [
              ['Alice', 'Admin'],
              ['Bob', 'Editor'],
              ['Cara', 'Viewer'],
            ],
          ),
        ),
        _DemoItem(
          title: 'Timeline',
          child: VTimeline(
            items: const [
              VTimelineItem(title: 'Signup', subtitle: 'User created account', time: '08:10'),
              VTimelineItem(title: 'Upgrade', subtitle: 'Upgraded to Pro', time: '09:30'),
            ],
          ),
        ),
        _DemoItem(
          title: 'Tree View',
          child: VTreeView(
            nodes: const [
              VTreeNode(
                label: 'Root',
                children: [
                  VTreeNode(label: 'Child A'),
                  VTreeNode(
                    label: 'Child B',
                    children: [
                      VTreeNode(label: 'Grandchild'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    addSection(
      'Forms & Text',
      [
        _DemoItem(
          title: 'Form',
          child: VAutoSizer(
            minItemWidth: 420,
            maxColumns: 2,
            spacing: 16,
            runSpacing: 16,
            children: [
              VCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VForm(
                      columns: 2,
                      fields: _formFields,
                      submitLabel: 'Submit',
                      cancelLabel: 'Cancel',
                      onSubmit: (values) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Submitted: ${values.keys.join(', ')}'),
                          ),
                        );
                      },
                      onCancel: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Canceled')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    addSection(
      'Inputs & Selection',
      [
        _DemoItem(
          title: 'Checkbox',
          child: Row(
            children: [
              VCheckbox(
                value: _selectedFruits.contains('apple'),
                onChanged: (v) {
                  setState(() {
                    if (v) {
                      _selectedFruits.add('apple');
                    } else {
                      _selectedFruits.remove('apple');
                    }
                  });
                },
              ),
              const SizedBox(width: 12),
              const Text('Apple'),
            ],
          ),
        ),
        _DemoItem(
          title: 'Chips Input',
          child: VChipsInput(
            controller: _chipsController,
            values: _chipValues,
            label: 'Tags',
            prefixIcon: Icons.tag,
            onChanged: (values) {
              setState(() {
                _chipValues
                  ..clear()
                  ..addAll(values);
              });
            },
          ),
        ),
        _DemoItem(
          title: 'Date Picker',
          child: VDatePickerField(
            controller: _dateController,
            value: _pickedDate,
            label: 'Date',
            prefixIcon: Icons.calendar_month,
            onChanged: (v) => setState(() => _pickedDate = v),
          ),
        ),
        _DemoItem(
          title: 'DateTime Picker',
          child: VDateTimePickerField(
            controller: _dateTimeController,
            value: _pickedDateTime,
            label: 'Date & Time',
            prefixIcon: Icons.date_range,
            onChanged: (v) => setState(() => _pickedDateTime = v),
          ),
        ),
        _DemoItem(
          title: 'Dropdown',
          child: VDropdown<String>(
            label: 'Country',
            hint: 'Select country',
            value: _selectedCountry,
            items: const [
              VDropdownItem(value: 'ph', label: 'Philippines'),
              VDropdownItem(value: 'us', label: 'United States'),
              VDropdownItem(value: 'jp', label: 'Japan'),
            ],
            onChanged: (value) {
              setState(() => _selectedCountry = value);
            },
          ),
        ),
        _DemoItem(
          title: 'File Upload',
          child: VFileUpload(
            height: 400,
            label: 'Upload File',
            onChanged: (files) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: ${files.length} file(s)')),
              );
            },
          ),
        ),
        _DemoItem(
          title: 'Masked TextBox',
          child: VMaskedTextBox(
            controller: _maskedController,
            label: 'Phone',
            hint: '0917 123 4567',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
          ),
        ),
        _DemoItem(
          title: 'Multi-Select Dropdown',
          child: VMultiSelectDropdown<String>(
            label: 'Fruits',
            //hint: 'Select fruits',
            values: _selectedFruits,
            items: const [
              VMultiSelectItem(value: 'apple', label: 'Apple'),
              VMultiSelectItem(value: 'banana', label: 'Banana'),
              VMultiSelectItem(value: 'mango', label: 'Mango'),
              VMultiSelectItem(value: 'orange', label: 'Orange'),
            ],
            onChanged: (values) {
              setState(() {
                _selectedFruits
                  ..clear()
                  ..addAll(values);
              });
            },
          ),
        ),
        _DemoItem(
          title: 'Number Input',
          child: VNumberInput(
            controller: _numberController,
            label: 'Quantity',
            hint: '0',
          ),
        ),
        _DemoItem(
          title: 'OTP / PIN Input',
          child: VOtpInput(
            controllers: _otpControllers,
            length: 6,
            autoSubmit: false,
            onCompleted: (code) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('OTP completed: $code')),
              );
            },
            onChanged: (v) {},
          ),
        ),
        _DemoItem(
          title: 'Radio',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VRadio<String>(
                value: 'male',
                groupValue: _selectedGender,
                onChanged: (v) => setState(() => _selectedGender = v),
                label: 'Male',
              ),
              const SizedBox(height: 8),
              VRadio<String>(
                value: 'female',
                groupValue: _selectedGender,
                onChanged: (v) => setState(() => _selectedGender = v),
                label: 'Female',
              ),
            ],
          ),
        ),
        _DemoItem(
          title: 'Rating',
          child: VRating(
            value: _ratingValue,
            onChanged: (v) => setState(() => _ratingValue = v),
          ),
        ),
        _DemoItem(
          title: 'Search Box',
          child: VTypeaheadSearchBox(
            controller: _searchController,
            label: 'Search',
            hint: 'Search products',
            options: const [
              'Apple',
              'Banana',
              'Coconut',
              'Grape',
              'Mango',
              'Orange',
              'Pineapple',
              'Strawberry',
              'Watermelon',
            ],
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: $value')),
              );
            },
          ),
        ),
        _DemoItem(
          title: 'Search Box (Async)',
          child: VTypeaheadSearchBox(
            label: 'Search (API)',
            hint: 'Search products',
            options: const [],
            asyncOptionsBuilder: (query) async {
              await Future.delayed(const Duration(milliseconds: 400));
              const all = [
                'Apple',
                'Banana',
                'Coconut',
                'Grape',
                'Mango',
                'Orange',
                'Pineapple',
                'Strawberry',
                'Watermelon',
              ];
              return all
                  .where((opt) => opt.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            },
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: $value')),
              );
            },
          ),
        ),
        _DemoItem(
          title: 'Segmented Control',
          child: VSegmented<String>(
            value: _segmentValue,
            onChanged: (v) => setState(() => _segmentValue = v),
            options: const [
              VSegmentOption(value: 'daily', label: 'Daily'),
              VSegmentOption(value: 'weekly', label: 'Weekly'),
              VSegmentOption(value: 'monthly', label: 'Monthly'),
            ],
          ),
        ),
        _DemoItem(
          title: 'Slider',
          child: VSlider(
            value: _sliderValue,
            onChanged: (v) => setState(() => _sliderValue = v),
            min: 0,
            max: 100,
          ),
        ),
        _DemoItem(
          title: 'Switch',
          child: VSwitch(
            value: _switchValue,
            onChanged: (v) => setState(() => _switchValue = v),
            label: 'Enable notifications',
          ),
        ),
        _DemoItem(
          title: 'Time Picker',
          child: VTimePickerField(
            controller: _timeController,
            value: _pickedTime,
            label: 'Time',
            onChanged: (v) => setState(() => _pickedTime = v),
          ),
        ),
      ],
    );

    addSection(
      'Color Overrides',
      [
        _DemoItem(
          title: 'Color Overrides',
          child: _wrap([
            // Buttons
            _maxWidthButton(VButton(
              label: 'Custom colors',
              onPressed: () {},
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              borderColor: Colors.deepOrange,
              leading: const Icon(Icons.color_lens),
            )),
            _maxWidthButton(VButton(
              label: 'Override text only',
              onPressed: () {},
              foregroundColor: Colors.pinkAccent,
            )),
            // Toolbar + overflow
            VToolbarActions(
              actions: [
                VIconButton(
                  icon: Icons.edit,
                  onPressed: () {},
                  color: Colors.teal,
                ),
                VIconButton(
                  icon: Icons.delete,
                  onPressed: () {},
                  color: Colors.redAccent,
                ),
              ],
              overflowItems: const [
                VOverflowItem(label: 'Duplicate', onSelected: null),
                VOverflowItem(label: 'Archive', onSelected: null),
              ],
              overflowColor: Colors.teal,
            ),
            // Checkbox / Radio / Segmented / Switch
            VCheckbox(
              value: _selectedFruits.contains('apple'),
              onChanged: (v) {
                setState(() {
                  if (v) {
                    _selectedFruits.add('apple');
                  } else {
                    _selectedFruits.remove('apple');
                  }
                });
              },
              activeColor: Colors.deepPurple,
            ),
            VRadio<String>(
              value: 'custom',
              groupValue: _selectedGender,
              onChanged: (v) => setState(() => _selectedGender = v),
              label: 'Radio override',
              activeColor: Colors.orange,
            ),
            VSegmented<String>(
              value: _segmentValue,
              onChanged: (v) => setState(() => _segmentValue = v),
              options: const [
                VSegmentOption(value: 'daily', label: 'Daily'),
                VSegmentOption(value: 'weekly', label: 'Weekly'),
                VSegmentOption(value: 'monthly', label: 'Monthly'),
              ],
              selectedColor: Colors.indigo,
              selectedForegroundColor: Colors.white,
            ),
            VSwitch(
              value: _switchValue,
              onChanged: (v) => setState(() => _switchValue = v),
              label: 'Switch override',
              activeColor: Colors.green,
            ),
            // Sliders / Rating
            VSlider(
              value: _sliderValue,
              onChanged: (v) => setState(() => _sliderValue = v),
              min: 0,
              max: 100,
              activeColor: Colors.pinkAccent,
            ),
            VRangeSlider(
              values: _rangeValues,
              onChanged: (v) => setState(() => _rangeValues = v),
              min: 0,
              max: 100,
              activeColor: Colors.cyan,
            ),
            VRating(
              value: _ratingValue,
              onChanged: (v) => setState(() => _ratingValue = v),
              activeColor: Colors.amber,
            ),
          ]),
        ),
      ],
    );

    if (sections.isEmpty) {
      return [
        VCard(
          child: const Text('No components found.'),
        ),
      ];
    }

    return sections;
  }

  List<_DemoItem> _filterItems(
    String sectionTitle,
    List<_DemoItem> items,
    String query,
  ) {
    if (query.isEmpty) return items;
    final sectionMatch = sectionTitle.toLowerCase().contains(query);
    if (sectionMatch) return items;
    return items
        .where((item) => item.title.toLowerCase().contains(query))
        .toList();
  }

  Widget _groupSection(String title, List<_DemoItem> items) {
    return VAccordion(
      title: title,
      child: Column(children: _buildAccordionList(items)),
    );
  }

  List<Widget> _buildAccordionList(List<_DemoItem> items) {
    final sorted = [...items]..sort((a, b) => a.title.compareTo(b.title));
    final widgets = <Widget>[];
    for (var i = 0; i < sorted.length; i++) {
      widgets.add(VAccordion(title: sorted[i].title, child: sorted[i].child));
      if (i != sorted.length - 1) {
        widgets.add(const SizedBox(height: 12));
      }
    }
    return widgets;
  }


  String? _emailValidator(String value) {
    if (value.trim().isEmpty) return 'Email is required';
    final emailRegExp =
        RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegExp.hasMatch(value.trim()) ? null : 'Invalid email';
  }

  String _colorHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
}

class _SampleTableSource extends DataTableSource {
  final List<List<String>> _rows = [
    ['Alice', 'Admin'],
    ['Bob', 'Editor'],
    ['Cara', 'Viewer'],
    ['Dave', 'Owner'],
    ['Ella', 'Analyst'],
  ];

  @override
  DataRow? getRow(int index) {
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow(cells: [DataCell(Text(row[0])), DataCell(Text(row[1]))]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rows.length;

  @override
  int get selectedRowCount => 0;
}

class _DemoItem {
  final String title;
  final Widget child;

  const _DemoItem({required this.title, required this.child});
}
