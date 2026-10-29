import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vistalityui/vistalityui.dart';

import 'playground_fonts.dart';

/// Preset seed colors from well-known brands; theme is generated from the selected one.
const _kSeedOptions = [
  Color(0xFFFF9900), // Amazon
  Color(0xFF0A66C2), // LinkedIn
  Color(0xFF00704A), // Starbucks
  Color(0xFFFF0000), // YouTube
  Color(0xFF1DA1F2), // Twitter / X
  Color(0xFFE4405F), // Instagram
];

String _colorToHex(Color c) {
  return '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

const double _kPlaygroundButtonMaxWidth = 400;
const double _kChromeHeight = 64;
const double _kContentMaxWidth = 960;

double _contentPadding(double width) => width >= VBreakpoints.lg ? 32 : 20;

Widget _maxWidthButton(Widget child) => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: _kPlaygroundButtonMaxWidth),
  child: child,
);

/// Playground screen with sidebar navigation and main content area,
/// matching the layout from the README image.
class PlaygroundSidebarScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;
  final Color seedColor;
  final ValueChanged<Color> onSeedColorChanged;
  final VRadiusSize radiusSize;
  final ValueChanged<VRadiusSize> onRadiusSizeChanged;
  final double? customRadius;
  final ValueChanged<double>? onCustomRadiusChanged;
  final List<PlaygroundFontOption> Function() getFontOptions;
  final String selectedFontId;
  final void Function(String id, TextTheme Function(TextTheme) builder) onFontChanged;

  const PlaygroundSidebarScreen({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
    required this.seedColor,
    required this.onSeedColorChanged,
    required this.radiusSize,
    required this.onRadiusSizeChanged,
    this.customRadius,
    this.onCustomRadiusChanged,
    required this.getFontOptions,
    required this.selectedFontId,
    required this.onFontChanged,
  });

  @override
  State<PlaygroundSidebarScreen> createState() => _PlaygroundSidebarScreenState();
}

class _PlaygroundSidebarScreenState extends State<PlaygroundSidebarScreen> {
  static const _overviewId = 'overview';
  static const _buttonsId = 'buttons';
  static const _fabsId = 'fabs';
  static const _segmentedId = 'segmented';
  static const _iconButtonsId = 'icon_buttons';
  static const _chipsId = 'chips';
  static const _typographyId = 'typography';
  static const _colorsId = 'colors';
  static const _mobileMenuSeedColor = 'seed_color';
  static const _mobileMenuCornerRadius = 'corner_radius';
  static const _mobileMenuFont = 'font';
  static const _mobileMenuDarkMode = 'dark_mode';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final TextEditingController _sidebarTextController;
  late final TextEditingController _sidebarMaskedController;
  late final TextEditingController _sidebarNumberController;
  late final TextEditingController _sidebarSearchController;
  late final TextEditingController _sidebarChipsController;
  late final TextEditingController _sidebarDateController;
  late final TextEditingController _sidebarTimeController;
  late final TextEditingController _sidebarDateTimeController;

  String? _selectedId = _overviewId;
  String _segmentValue = 'day';
  bool _sidebarSwitchValue = false;
  String _sidebarRadioValue = 'a';
  String? _sidebarDropdownValue;
  double _sidebarSliderValue = 50;
  int _sidebarRatingValue = 3;
  RangeValues _sidebarRangeValues = const RangeValues(25, 75);
  final List<String> _sidebarMultiSelectValues = [];
  final List<String> _sidebarChipValues = [];
  DateTime? _sidebarDate;
  TimeOfDay? _sidebarTime;
  DateTime? _sidebarDateTime;
  final List<Color> _recentPickerColors = [];
  final TextEditingController _navFilterController = TextEditingController();
  String _navQuery = '';

  static List<Color> _addToRecent(List<Color> list, Color color) {
    final next = [color, ...list.where((c) => c.toARGB32() != color.toARGB32())];
    return next.take(6).toList();
  }

  @override
  void initState() {
    super.initState();
    _sidebarTextController = TextEditingController();
    _sidebarMaskedController = TextEditingController();
    _sidebarNumberController = TextEditingController();
    _sidebarSearchController = TextEditingController();
    _sidebarChipsController = TextEditingController();
    _sidebarDateController = TextEditingController();
    _sidebarTimeController = TextEditingController();
    _sidebarDateTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _sidebarTextController.dispose();
    _sidebarMaskedController.dispose();
    _sidebarNumberController.dispose();
    _sidebarSearchController.dispose();
    _sidebarChipsController.dispose();
    _sidebarDateController.dispose();
    _sidebarTimeController.dispose();
    _sidebarDateTimeController.dispose();
    _navFilterController.dispose();
    super.dispose();
  }

  bool _isWideLayout(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= VBreakpoints.md;
  }

  void _onSidebarItemTap(String id) {
    setState(() => _selectedId = id);
    if (!_isWideLayout(context)) {
      Navigator.of(context).pop(); // close drawer on narrow
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = _isWideLayout(context);

    final page = _currentPage();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: cs.surface,
      drawer: isWide ? null : _buildDrawer(context),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isWide) _buildSidebar(context),
          Expanded(
            child: Column(
              children: [
                _buildContentHeader(context, page, isWide),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final padding = _contentPadding(constraints.maxWidth);
                      return SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(padding, 28, padding, 48),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: _kContentMaxWidth),
                            child: SizedBox(
                              width: double.infinity,
                              child: _buildContent(context),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ({String section, String label}) _currentPage() {
    for (final section in _navSections()) {
      for (final item in section.items) {
        if (item.id == _selectedId) {
          return (section: section.title, label: item.label);
        }
      }
    }
    return (section: 'Library', label: 'Overview');
  }

  Widget _buildContentHeader(
    BuildContext context,
    ({String section, String label}) page,
    bool isWide,
  ) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      child: SizedBox(
        height: _kChromeHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = _contentPadding(constraints.maxWidth);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _kContentMaxWidth),
                  child: Row(
                    children: [
                      if (!isWide)
                        IconButton(
                          icon: const Icon(Icons.menu),
                          tooltip: 'Menu',
                          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                        ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              page.section,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: cs.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              page.label,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                                height: 1.15,
                              ),
                            ),
                          ],
                        ),
                      ),
              if (!isWide)
                PopupMenuButton<String>(
                  tooltip: 'Playground options',
                  onSelected: (value) {
                    switch (value) {
                      case _mobileMenuSeedColor:
                        _openColorWheelPicker(context);
                        break;
                      case _mobileMenuCornerRadius:
                        _openRadiusDialog(context);
                        break;
                      case _mobileMenuFont:
                        _openFontPickerDialog(context);
                        break;
                      case _mobileMenuDarkMode:
                        widget.onDarkModeChanged(!widget.isDarkMode);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: _mobileMenuSeedColor,
                      child: Text('Seed color'),
                    ),
                    const PopupMenuItem<String>(
                      value: _mobileMenuCornerRadius,
                      child: Text('Corner radius'),
                    ),
                    const PopupMenuItem<String>(
                      value: _mobileMenuFont,
                      child: Text('Font'),
                    ),
                    PopupMenuItem<String>(
                      value: _mobileMenuDarkMode,
                      child: Text(widget.isDarkMode ? 'Use light mode' : 'Use dark mode'),
                    ),
                  ],
                ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBrandHeader(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      child: SizedBox(
        height: _kChromeHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'V',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: cs.onPrimary,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vistality',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'Playground',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: _buildSidebarContent(context),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(right: BorderSide(color: cs.outlineVariant)),
      ),
      child: _buildSidebarContent(context),
    );
  }

  Widget _buildAppearancePanel(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final quiet = theme.textTheme.labelSmall?.copyWith(
      color: cs.onSurfaceVariant,
      fontWeight: FontWeight.w600,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Theme',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: widget.isDarkMode ? 'Light mode' : 'Dark mode',
                    onPressed: () => widget.onDarkModeChanged(!widget.isDarkMode),
                    icon: Icon(
                      widget.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('Color', style: quiet),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final color in _kSeedOptions)
                    _SeedSwatch(
                      color: color,
                      selected: widget.seedColor.toARGB32() == color.toARGB32(),
                      onTap: () => widget.onSeedColorChanged(color),
                    ),
                  _SeedSwatch(
                    color: cs.surfaceContainerHighest,
                    selected: !_kSeedOptions.any((c) => c.toARGB32() == widget.seedColor.toARGB32()),
                    icon: Icons.colorize_outlined,
                    onTap: () => _openColorWheelPicker(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Radius', style: quiet),
              const SizedBox(height: 8),
              VSegmented<VRadiusSize>(
                value: widget.radiusSize,
                onChanged: widget.onRadiusSizeChanged,
                options: const [
                  VSegmentOption(value: VRadiusSize.none, label: '0'),
                  VSegmentOption(value: VRadiusSize.sm, label: 'S'),
                  VSegmentOption(value: VRadiusSize.md, label: 'M'),
                  VSegmentOption(value: VRadiusSize.lg, label: 'L'),
                ],
              ),
              const SizedBox(height: 12),
              _FontDropdown(
                getFontOptions: widget.getFontOptions,
                value: widget.selectedFontId,
                onChanged: widget.onFontChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_SidebarSection> _navSections() {
    return const [
      _SidebarSection(
        title: 'Overview',
        items: [
          _SidebarItem(id: _overviewId, label: 'Overview', icon: Icons.dashboard_outlined),
        ],
      ),
      _SidebarSection(
        title: 'Foundations',
        items: [
          _SidebarItem(id: 'typography', label: 'Typography', icon: Icons.text_fields),
          _SidebarItem(id: 'colors', label: 'Colors', icon: Icons.palette_outlined),
        ],
      ),
      _SidebarSection(
        title: 'Actions',
        items: [
          _SidebarItem(id: _buttonsId, label: 'Buttons', icon: Icons.smart_button_outlined),
          _SidebarItem(id: _fabsId, label: 'FABs', icon: Icons.add_circle_outline),
          _SidebarItem(id: _segmentedId, label: 'Segmented', icon: Icons.view_agenda_outlined),
          _SidebarItem(id: _iconButtonsId, label: 'Icon Buttons', icon: Icons.star_outline),
          _SidebarItem(id: _chipsId, label: 'Chips', icon: Icons.label_outline),
          _SidebarItem(id: 'context_menu', label: 'Context Menu', icon: Icons.more_horiz),
          _SidebarItem(id: 'overflow_menu', label: 'Overflow Menu', icon: Icons.more_vert),
          _SidebarItem(id: 'toolbar', label: 'Toolbar', icon: Icons.apps),
        ],
      ),
      _SidebarSection(
        title: 'Data & Layout',
        items: [
          _SidebarItem(id: 'cards', label: 'Cards', icon: Icons.credit_card),
          _SidebarItem(id: 'table', label: 'Table', icon: Icons.table_chart),
          _SidebarItem(id: 'lists', label: 'List', icon: Icons.list),
          _SidebarItem(id: 'accordion', label: 'Accordion', icon: Icons.expand_more),
          _SidebarItem(id: 'timeline', label: 'Timeline', icon: Icons.timeline),
          _SidebarItem(id: 'feed', label: 'Feed', icon: Icons.rss_feed),
          _SidebarItem(id: 'grid', label: 'Grid', icon: Icons.grid_view),
        ],
      ),
      _SidebarSection(
        title: 'Forms & Inputs',
        items: [
          _SidebarItem(id: 'text_fields', label: 'Text Fields', icon: Icons.text_fields),
          _SidebarItem(id: 'multiline_text', label: 'Multiline Text', icon: Icons.subject),
          _SidebarItem(id: 'checkboxes', label: 'Checkboxes', icon: Icons.check_box_outlined),
          _SidebarItem(id: 'switches', label: 'Switches', icon: Icons.toggle_on_outlined),
          _SidebarItem(id: 'radio', label: 'Radio', icon: Icons.radio_button_checked_outlined),
          _SidebarItem(id: 'dropdown', label: 'Dropdown', icon: Icons.arrow_drop_down),
          _SidebarItem(id: 'multi_select_dropdown', label: 'Multi-Select Dropdown', icon: Icons.checklist),
          _SidebarItem(id: 'chips_input', label: 'Chips Input', icon: Icons.label),
          _SidebarItem(id: 'slider', label: 'Slider', icon: Icons.tune),
          _SidebarItem(id: 'range_slider', label: 'Range Slider', icon: Icons.tune),
          _SidebarItem(id: 'rating', label: 'Rating', icon: Icons.star_outline),
          _SidebarItem(id: 'otp_input', label: 'OTP / PIN Input', icon: Icons.pin),
          _SidebarItem(id: 'number_input', label: 'Number Input', icon: Icons.numbers),
          _SidebarItem(id: 'masked_textbox', label: 'Masked TextBox', icon: Icons.phone),
          _SidebarItem(id: 'search_box', label: 'Search', icon: Icons.search),
          _SidebarItem(id: 'date_picker', label: 'Date Picker', icon: Icons.calendar_month),
          _SidebarItem(id: 'time_picker', label: 'Time Picker', icon: Icons.access_time),
          _SidebarItem(id: 'datetime_picker', label: 'Date & Time', icon: Icons.date_range),
          _SidebarItem(id: 'file_upload', label: 'File Upload', icon: Icons.upload_file),
        ],
      ),
      _SidebarSection(
        title: 'Overlays & More',
        items: [
          _SidebarItem(id: 'dialogs', label: 'Dialogs', icon: Icons.info_outline),
          _SidebarItem(id: 'icons', label: 'Icons', icon: Icons.image_outlined),
          _SidebarItem(id: 'auto_sizer', label: 'Auto Sizer', icon: Icons.dashboard),
        ],
      ),
    ];
  }

  List<_SidebarSection> _visibleNavSections() {
    final query = _navQuery.trim().toLowerCase();
    if (query.isEmpty) return _navSections();
    return [
      for (final section in _navSections())
        if (section.items.any((item) => item.label.toLowerCase().contains(query)))
          _SidebarSection(
            title: section.title,
            items: [
              for (final item in section.items)
                if (item.label.toLowerCase().contains(query)) item,
            ],
          ),
    ];
  }

  Widget _buildSidebarContent(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        _buildBrandHeader(context),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: VTextBox(
            controller: _navFilterController,
            label: null,
            hint: 'Find a component',
            filled: true,
            controlHeight: 40,
            prefixIcon: Icons.search,
            onChanged: (value) => setState(() => _navQuery = value),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
            children: [
              if (_visibleNavSections().isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                  child: Text(
                    'No components match',
                    style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
              for (final section in _visibleNavSections()) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 4),
                  child: Text(
                    section.title,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                for (final item in section.items)
                  _SidebarTile(
                    label: item.label,
                    icon: item.icon,
                    selected: _selectedId == item.id,
                    onTap: () => _onSidebarItemTap(item.id),
                  ),
              ],
            ],
          ),
        ),
        _buildAppearancePanel(context),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    late final Widget content;
    switch (_selectedId) {
      case _overviewId:
        content = _buildOverviewContent(context);
        break;
      case _buttonsId:
        content = _buildButtonsContent(context);
        break;
      case _fabsId:
        content = _buildFabsContent(context);
        break;
      case _segmentedId:
        content = _buildSegmentedContent(context);
        break;
      case _iconButtonsId:
        content = _buildIconButtonsContent(context);
        break;
      case _chipsId:
        content = _buildChipsContent(context);
        break;
      case _typographyId:
        content = _buildTypographyContent(context);
        break;
      case _colorsId:
        content = _buildColorsContent(context);
        break;
      case 'text_fields':
        content = _buildTextFieldsContent(context);
        break;
      case 'multiline_text':
        content = _buildMultilineTextContent(context);
        break;
      case 'checkboxes':
        content = _buildCheckboxesContent(context);
        break;
      case 'switches':
        content = _buildSwitchesContent(context);
        break;
      case 'radio':
        content = _buildRadioContent(context);
        break;
      case 'dropdown':
        content = _buildDropdownContent(context);
        break;
      case 'slider':
        content = _buildSliderContent(context);
        break;
      case 'rating':
        content = _buildRatingContent(context);
        break;
      case 'cards':
        content = _buildCardsContent(context);
        break;
      case 'lists':
        content = _buildListsContent(context);
        break;
      case 'accordion':
        content = _buildAccordionContent(context);
        break;
      case 'table':
        content = _buildTableContent(context);
        break;
      case 'timeline':
        content = _buildTimelineContent(context);
        break;
      case 'feed':
        content = _buildFeedContent(context);
        break;
      case 'grid':
        content = _buildGridContent(context);
        break;
      case 'context_menu':
        content = _buildContextMenuContent(context);
        break;
      case 'overflow_menu':
        content = _buildOverflowMenuContent(context);
        break;
      case 'toolbar':
        content = _buildToolbarContent(context);
        break;
      case 'auto_sizer':
        content = _buildAutoSizerContent(context);
        break;
      case 'dialogs':
        content = _buildDialogsContent(context);
        break;
      case 'icons':
        content = _buildIconsContent(context);
        break;
      case 'multi_select_dropdown':
        content = _buildMultiSelectDropdownContent(context);
        break;
      case 'chips_input':
        content = _buildChipsInputContent(context);
        break;
      case 'otp_input':
        content = _buildOtpInputContent(context);
        break;
      case 'number_input':
        content = _buildNumberInputContent(context);
        break;
      case 'masked_textbox':
        content = _buildMaskedTextBoxContent(context);
        break;
      case 'search_box':
        content = _buildSearchBoxContent(context);
        break;
      case 'range_slider':
        content = _buildRangeSliderContent(context);
        break;
      case 'date_picker':
        content = _buildDatePickerContent(context);
        break;
      case 'time_picker':
        content = _buildTimePickerContent(context);
        break;
      case 'datetime_picker':
        content = _buildDateTimePickerContent(context);
        break;
      case 'file_upload':
        content = _buildFileUploadContent(context);
        break;
      default:
        content = Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 16),
                Text(
                  'Select a component from the sidebar',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
        break;
    }

    return content;
  }

  Widget _contentSection(
      BuildContext context, {
        required String title,
        String? subtitle,
        required List<Widget> children,
        double topPadding = 16,
      }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final radius = context.vRadius.defaultBorderRadius();
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: radius,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewContent(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color, type, radius, and dark mode in the sidebar apply to every control below.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: cs.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        _contentSection(
          context,
          title: 'Corner radius',
          subtitle: 'Presets live in the sidebar. Drag here for a custom value.',
          topPadding: 20,
          children: [
            SizedBox(
              width: 380,
              child: VSegmented<VRadiusSize>(
                value: widget.radiusSize,
                onChanged: widget.onRadiusSizeChanged,
                options: const [
                  VSegmentOption(value: VRadiusSize.none, label: 'None'),
                  VSegmentOption(value: VRadiusSize.sm, label: 'SM'),
                  VSegmentOption(value: VRadiusSize.md, label: 'MD'),
                  VSegmentOption(value: VRadiusSize.lg, label: 'LG'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 380,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Custom radius (0–200): ${(widget.customRadius ?? _radiusSizeToNumber(widget.radiusSize)).round()}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  VSlider(
                    value: widget.customRadius ?? _radiusSizeToNumber(widget.radiusSize),
                    onChanged: widget.onCustomRadiusChanged,
                    min: 0,
                    max: 200,
                    divisions: 200,
                  ),
                ],
              ),
            ),
          ],
        ),
        _contentSection(
          context,
          title: 'Primary actions',
          subtitle: 'Buttons sized for content, not full width.',
          topPadding: 32,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _maxWidthButton(VButton(label: 'Save', onPressed: () {}, size: VButtonSize.md)),
                _maxWidthButton(VButton(
                  label: 'Cancel',
                  intent: VIntent.secondary,
                  variant: VButtonVariant.ghost,
                  onPressed: () {},
                  size: VButtonSize.md,
                )),
                _maxWidthButton(VButton(
                  label: 'Delete',
                  intent: VIntent.danger,
                  variant: VButtonVariant.text,
                  onPressed: () {},
                  size: VButtonSize.md,
                )),
              ],
            ),
          ],
        ),
        _contentSection(
          context,
          title: 'Typography scale',
          subtitle: 'Headings and body text for clear hierarchy.',
          children: [
            const VHeading('Section heading', level: VHeadingLevel.h3),
            const SizedBox(height: 4),
            Text(
              'Body text for descriptions and longer content. '
                  'Keep line length readable and use hierarchy to guide the eye.',
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
        _contentSection(
          context,
          title: 'Theme colors',
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _colorChip(context, 'Primary', cs.primary),
                _colorChip(context, 'Secondary', cs.secondary),
                _colorChip(context, 'Surface', cs.surface),
                _colorChip(context, 'Error', cs.error),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Buttons & Actions'),
        const SizedBox(height: 6),
        Text(
          'Use primary for main actions; keep width intrinsic so buttons don’t stretch.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        _contentSection(
          context,
          title: 'Standard buttons',
          topPadding: 24,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _maxWidthButton(VButton(label: 'Primary', onPressed: () {}, size: VButtonSize.md)),
                _maxWidthButton(VButton(
                  label: 'Secondary',
                  intent: VIntent.secondary,
                  onPressed: () {},
                  size: VButtonSize.md,
                )),
                _maxWidthButton(VButton(
                  label: 'Outlined',
                  intent: VIntent.secondary,
                  variant: VButtonVariant.ghost,
                  onPressed: () {},
                  size: VButtonSize.md,
                )),
                _maxWidthButton(VButton(
                  label: 'Text',
                  variant: VButtonVariant.text,
                  onPressed: () {},
                  size: VButtonSize.md,
                )),
                _maxWidthButton(VButton(
                  label: 'Success',
                  intent: VIntent.success,
                  onPressed: () {},
                  size: VButtonSize.md,
                )),
              ],
            ),
          ],
        ),
        _contentSection(
          context,
          title: 'With icons',
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _maxWidthButton(VButton(
                  label: 'Add item',
                  onPressed: () {},
                  leading: const Icon(Icons.add, size: 18),
                  size: VButtonSize.md,
                )),
                _maxWidthButton(VButton(
                  label: 'Open',
                  intent: VIntent.secondary,
                  variant: VButtonVariant.ghost,
                  onPressed: () {},
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  size: VButtonSize.md,
                )),
              ],
            ),
          ],
        ),
        _contentSection(
          context,
          title: 'Floating action buttons',
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                VFab(icon: Icons.add, tooltip: 'Add', onPressed: () {}),
                VFab(icon: Icons.edit, tooltip: 'Edit', onPressed: () {}),
              ],
            ),
          ],
        ),
        _contentSection(
          context,
          title: 'Segmented control',
          children: [
            SizedBox(
              width: 280,
              child: VSegmented<String>(
                value: _segmentValue,
                onChanged: (v) => setState(() => _segmentValue = v),
                options: const [
                  VSegmentOption(value: 'day', label: 'Day'),
                  VSegmentOption(value: 'week', label: 'Week'),
                  VSegmentOption(value: 'month', label: 'Month'),
                ],
              ),
            ),
          ],
        ),
        _contentSection(
          context,
          title: 'Icon buttons',
          children: [
            VButtonGroup(
              children: [
                VIconButton(icon: Icons.close, tooltip: 'Close', onPressed: () {}),
                VIconButton(icon: Icons.edit_outlined, tooltip: 'Edit', onPressed: () {}),
                VIconButton(icon: Icons.delete_outline, tooltip: 'Delete', onPressed: () {}),
                VIconButton(icon: Icons.more_vert, tooltip: 'More', onPressed: () {}),
              ],
            ),
          ],
        ),
        _contentSection(
          context,
          title: 'Chips',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                VChip(label: 'Filter', onDeleted: () {}),
                VChip(label: 'Tag', onDeleted: () {}),
                VChip(label: 'Status', onDeleted: () {}),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFabsContent(BuildContext context) {
    return _contentSection(
      context,
      title: 'Floating action buttons',
      topPadding: 0,
      children: [
        Wrap(spacing: 12, runSpacing: 12, children: [
          VFab(icon: Icons.add, tooltip: 'Add', onPressed: () {}),
          VFab(icon: Icons.edit, tooltip: 'Edit', onPressed: () {}),
        ]),
      ],
    );
  }

  Widget _buildSegmentedContent(BuildContext context) {
    return _contentSection(
      context,
      title: 'Segmented buttons',
      topPadding: 0,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: VSegmented<String>(
            value: _segmentValue,
            onChanged: (v) => setState(() => _segmentValue = v),
            options: const [
              VSegmentOption(value: 'day', label: 'Day'),
              VSegmentOption(value: 'week', label: 'Week'),
              VSegmentOption(value: 'month', label: 'Month'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButtonsContent(BuildContext context) {
    return _contentSection(
      context,
      title: 'Icon buttons',
      topPadding: 0,
      children: [
        VButtonGroup(
          children: [
            VIconButton(icon: Icons.close, tooltip: 'Close', onPressed: () {}),
            VIconButton(icon: Icons.home_outlined, tooltip: 'Home', onPressed: () {}),
            VIconButton(icon: Icons.phone_outlined, tooltip: 'Phone', onPressed: () {}),
            VIconButton(icon: Icons.language, tooltip: 'Language', onPressed: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildChipsContent(BuildContext context) {
    return _contentSection(
      context,
      title: 'Action chips',
      topPadding: 0,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            VChip(label: 'Chips', onDeleted: () {}),
            VChip(label: 'Action Chip', onDeleted: () {}),
            VChip(label: 'Filter', onDeleted: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildTypographyContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Typography'),
        const SizedBox(height: 6),
        Text(
          'Consistent type scale for headings and body copy.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        _contentSection(
          context,
          title: 'Headings',
          topPadding: 24,
          children: [
            const VHeading('Heading 1', level: VHeadingLevel.h1),
            const SizedBox(height: 8),
            const VHeading('Heading 2', level: VHeadingLevel.h2),
            const SizedBox(height: 8),
            const VHeading('Heading 3', level: VHeadingLevel.h3),
            const SizedBox(height: 8),
            const VHeading('Heading 4', level: VHeadingLevel.h4),
            const SizedBox(height: 16),
            Text(
              'Body text for paragraphs and descriptions. '
                  'Keep line length comfortable for reading.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorsContent(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = <String, Color>{
      'Primary': scheme.primary,
      'Secondary': scheme.secondary,
      'Surface': scheme.surface,
      'Error': scheme.error,
      'Outline': scheme.outline,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Theme colors'),
        const SizedBox(height: 6),
        Text(
          'Palette used across the app for consistency and accessibility.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        _contentSection(
          context,
          title: 'Palette',
          topPadding: 24,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors.entries.map((e) => _colorChip(context, e.key, e.value)).toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextFieldsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Text Fields'),
        const SizedBox(height: 6),
        Text(
          'Single and multi-line inputs for forms and search.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        _contentSection(
          context,
          title: 'Single line',
          topPadding: 24,
          children: [
            SizedBox(
              width: 360,
              child: VTextBox(
                controller: _sidebarTextController,
                label: 'Name',
                hint: 'Enter name',
                prefixIcon: Icons.person_outline,
              ),
            ),
          ],
        ),
        _contentSection(
          context,
          title: 'Multiline (VTextBox)',
          children: [
            SizedBox(
              width: 360,
              child: VTextBox(
                controller: _sidebarTextController,
                label: 'Notes',
                hint: 'Optional notes',
                multiline: true,
                allowNewLineButton: true,
                allowClearButton: true,
                minLines: 2,
                maxLines: 6,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMultilineTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Multiline Text'),
        const SizedBox(height: 6),
        Text(
          'VTextBox with multiline, clear (X) and new-line (enter/back) icons.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        _contentSection(
          context,
          title: 'VTextBox (multiline + allowNewLineButton + allowClearButton)',
          topPadding: 24,
          children: [
            SizedBox(
              width: 360,
              child: VTextBox(
                controller: _sidebarTextController,
                label: 'Notes',
                hint: 'Optional notes',
                multiline: true,
                allowNewLineButton: true,
                allowClearButton: true,
                minLines: 3,
                maxLines: 8,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckboxesContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Checkboxes'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            VCheckbox(value: true, onChanged: (_) {}),
            const Text('Checked'),
            VCheckbox(value: false, onChanged: (_) {}),
            const Text('Unchecked'),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitchesContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Switches'),
        const SizedBox(height: 16),
        VSwitch(
          value: _sidebarSwitchValue,
          onChanged: (v) => setState(() => _sidebarSwitchValue = v),
          label: 'Toggle option',
        ),
      ],
    );
  }

  Widget _buildRadioContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Radio Buttons'),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VRadio<String>(
              value: 'a',
              groupValue: _sidebarRadioValue,
              onChanged: (v) => setState(() => _sidebarRadioValue = v),
              label: 'Option A',
            ),
            const SizedBox(height: 8),
            VRadio<String>(
              value: 'b',
              groupValue: _sidebarRadioValue,
              onChanged: (v) => setState(() => _sidebarRadioValue = v),
              label: 'Option B',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Dropdown'),
        const SizedBox(height: 6),
        Text(
          'Single selection from a list; use for forms and filters.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        _contentSection(
          context,
          title: 'Example',
          topPadding: 24,
          children: [
            SizedBox(
              width: 320,
              child: VDropdown<String>(
                label: 'Country',
                hint: 'Select country',
                value: _sidebarDropdownValue,
                items: const [
                  VDropdownItem(value: 'one', label: 'United States'),
                  VDropdownItem(value: 'two', label: 'Canada'),
                  VDropdownItem(value: 'three', label: 'United Kingdom'),
                ],
                onChanged: (v) => setState(() => _sidebarDropdownValue = v),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSliderContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Slider'),
        const SizedBox(height: 16),
        VSlider(
          value: _sidebarSliderValue,
          onChanged: (v) => setState(() => _sidebarSliderValue = v),
          min: 0,
          max: 100,
        ),
      ],
    );
  }

  Widget _buildRatingContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Rating'),
        const SizedBox(height: 16),
        VRating(
          value: _sidebarRatingValue,
          onChanged: (v) => setState(() => _sidebarRatingValue = v),
        ),
      ],
    );
  }

  Widget _buildCardsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Cards'),
        const SizedBox(height: 6),
        Text(
          'Containers for grouping related content—stats, lists, or actions.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        _contentSection(
          context,
          title: 'Example cards',
          topPadding: 24,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 220,
                  child: VCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Active users',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '12,847',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: VCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Pending',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '23',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'List View'),
        const SizedBox(height: 16),
        VListView(
          children: const [
            VCard(child: Padding(
              padding: EdgeInsets.all(12),
              child: Text('Item 1'),
            )),
            VCard(child: Padding(
              padding: EdgeInsets.all(12),
              child: Text('Item 2'),
            )),
            VCard(child: Padding(
              padding: EdgeInsets.all(12),
              child: Text('Item 3'),
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildAccordionContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Accordion'),
        const SizedBox(height: 16),
        VAccordion(
          title: 'Expandable section',
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Accordion body content.'),
          ),
        ),
      ],
    );
  }

  Widget _buildTableContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Table'),
        const SizedBox(height: 6),
        Text(
          'Structured data with filter, sortable columns, and pagination.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        _contentSection(
          context,
          title: 'VAdvancedTable',
          topPadding: 24,
          children: [
            SizedBox(
              height: 380,
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
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Timeline'),
        const SizedBox(height: 16),
        const VTimeline(
          items: [
            VTimelineItem(title: 'Step 1', subtitle: 'First step', time: '10:00'),
            VTimelineItem(title: 'Step 2', subtitle: 'Second step', time: '11:00'),
          ],
        ),
      ],
    );
  }

  Widget _buildFeedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Feed'),
        const SizedBox(height: 16),
        const VFeed(
          items: [
            VFeedItem(title: 'Update', body: 'Something changed', time: '2m'),
            VFeedItem(title: 'Alert', body: 'New notification', time: '1h'),
          ],
        ),
      ],
    );
  }

  Widget _buildGridContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Grid View'),
        const SizedBox(height: 16),
        VGridView(
          columns: 3,
          children: List.generate(
            6,
                (i) => VCard(
              child: Center(child: Text('Item ${i + 1}')),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContextMenuContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Context Menu'),
        const SizedBox(height: 6),
        Text(
          'Right-click or long-press the area to open the menu.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        _contentSection(
          context,
          title: 'VContextMenu',
          topPadding: 24,
          children: [
            VContextMenu(
              items: [
                VContextMenuItem(label: 'Copy', onSelected: () {}),
                VContextMenuItem(label: 'Paste', onSelected: () {}),
                VContextMenuItem(label: 'Delete', onSelected: () {}),
              ],
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Right-click or long-press here'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverflowMenuContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Overflow Menu'),
        const SizedBox(height: 6),
        Text(
          'More actions in a dropdown menu.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        _contentSection(
          context,
          title: 'VOverflowMenu',
          topPadding: 24,
          children: [
            VOverflowMenu(
              items: [
                VOverflowItem(label: 'Rename', onSelected: () {}),
                VOverflowItem(label: 'Move', onSelected: () {}),
                VOverflowItem(label: 'Delete', onSelected: () {}),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToolbarContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Toolbar Actions'),
        const SizedBox(height: 6),
        Text(
          'Icon actions with optional overflow menu.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        _contentSection(
          context,
          title: 'VToolbarActions',
          topPadding: 24,
          children: [
            VToolbarActions(
              actions: [
                VIconButton(icon: Icons.edit_outlined, tooltip: 'Edit', onPressed: () {}),
                VIconButton(icon: Icons.delete_outline, tooltip: 'Delete', onPressed: () {}),
              ],
              overflowItems: [
                VOverflowItem(label: 'Duplicate', onSelected: () {}),
                VOverflowItem(label: 'Archive', onSelected: () {}),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAutoSizerContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Auto Sizer'),
        const SizedBox(height: 16),
        SizedBox(
          height: 320,
          child: VAutoSizer(
            mobileLayout: VAutoSizerLayout.column,
            tabletLayout: VAutoSizerLayout.wrap,
            webLayout: VAutoSizerLayout.wrap,
            minItemWidth: 200,
            maxColumns: 3,
            spacing: 12,
            runSpacing: 12,
            children: [
              VCard(
                child: Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: const Text('Tile 1'),
                ),
              ),
              VCard(
                child: Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: const Text('Tile 2'),
                ),
              ),
              _maxWidthButton(VButton(label: 'Action', onPressed: () {})),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDialogsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Dialogs'),
        const SizedBox(height: 6),
        Text(
          'Modal dialogs for confirmations and focused tasks.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        _contentSection(
          context,
          title: 'Trigger',
          topPadding: 24,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _maxWidthButton(VButton(
                  label: 'Open dialog',
                  size: VButtonSize.md,
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Confirm'),
                        content: const Text(
                          'Do you want to continue? This action can be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    );
                  },
                )),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Icons'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: const [
            Icon(Icons.star, size: 32),
            Icon(Icons.favorite, size: 32),
            Icon(Icons.home, size: 32),
            Icon(Icons.settings, size: 32),
            Icon(Icons.search, size: 32),
          ],
        ),
      ],
    );
  }

  Widget _buildMultiSelectDropdownContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Multi-Select Dropdown'),
        const SizedBox(height: 16),
        SizedBox(
          width: 280,
          child: VMultiSelectDropdown<String>(
            label: 'Fruits',
            //hint: 'Select fruits',
            values: _sidebarMultiSelectValues,
            items: const [
              VMultiSelectItem(value: 'apple', label: 'Apple'),
              VMultiSelectItem(value: 'banana', label: 'Banana'),
              VMultiSelectItem(value: 'mango', label: 'Mango'),
              VMultiSelectItem(value: 'orange', label: 'Orange'),
            ],
            onChanged: (values) {
              setState(() {
                _sidebarMultiSelectValues
                  ..clear()
                  ..addAll(values);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChipsInputContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Chips Input'),
        const SizedBox(height: 16),
        SizedBox(
          width: 320,
          child: VChipsInput(
            controller: _sidebarChipsController,
            values: _sidebarChipValues,
            label: 'Tags',
            prefixIcon: Icons.tag,
            onChanged: (values) {
              setState(() {
                _sidebarChipValues
                  ..clear()
                  ..addAll(values);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInputContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'OTP / PIN Input'),
        const SizedBox(height: 16),
        VOtpInput(
          length: 6,
          autoSubmit: false,
          onCompleted: (code) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('OTP completed: $code')),
            );
          },
          onChanged: (_) {},
        ),
      ],
    );
  }

  Widget _buildNumberInputContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Number Input'),
        const SizedBox(height: 16),
        SizedBox(
          width: 200,
          child: VNumberInput(
            controller: _sidebarNumberController,
            label: 'Quantity',
            hint: '0',
          ),
        ),
      ],
    );
  }

  Widget _buildMaskedTextBoxContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Masked TextBox'),
        const SizedBox(height: 16),
        SizedBox(
          width: 280,
          child: VMaskedTextBox(
            controller: _sidebarMaskedController,
            label: 'Phone',
            hint: '0917 123 4567',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBoxContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Search Box'),
        const SizedBox(height: 16),
        SizedBox(
          width: 320,
          child: VTypeaheadSearchBox(
            controller: _sidebarSearchController,
            label: 'Search',
            hint: 'Search products',
            options: const [
              'Apple',
              'Banana',
              'Mango',
              'Orange',
              'Pineapple',
            ],
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: $value')),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRangeSliderContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Range Slider'),
        const SizedBox(height: 16),
        VRangeSlider(
          values: _sidebarRangeValues,
          onChanged: (v) => setState(() => _sidebarRangeValues = v),
          min: 0,
          max: 100,
        ),
      ],
    );
  }

  Widget _buildDatePickerContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Date Picker'),
        const SizedBox(height: 16),
        SizedBox(
          width: 280,
          child: VDatePickerField(
            controller: _sidebarDateController,
            value: _sidebarDate,
            label: 'Date',
            prefixIcon: Icons.calendar_month,
            onChanged: (v) => setState(() => _sidebarDate = v),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePickerContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Time Picker'),
        const SizedBox(height: 16),
        SizedBox(
          width: 280,
          child: VTimePickerField(
            controller: _sidebarTimeController,
            value: _sidebarTime,
            label: 'Time',
            prefixIcon: Icons.access_time,
            onChanged: (v) => setState(() => _sidebarTime = v),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePickerContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'DateTime Picker'),
        const SizedBox(height: 16),
        SizedBox(
          width: 280,
          child: VDateTimePickerField(
            controller: _sidebarDateTimeController,
            value: _sidebarDateTime,
            label: 'Date & Time',
            prefixIcon: Icons.date_range,
            onChanged: (v) => setState(() => _sidebarDateTime = v),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'File Upload'),
        const SizedBox(height: 16),
        SizedBox(
          width: 400,
          child: VFileUpload(
            height: 200,
            label: 'Upload File',
            onChanged: (files) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: ${files.length} file(s)')),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openColorWheelPicker(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      useRootNavigator: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Color wheel'),
        content: SizedBox(
          width: 420,
          child: VColorWheelPicker(
            initialColor: widget.seedColor,
            commonColors: kVColorWheelCommonColors,
            recentColors: _recentPickerColors,
            contentWidth: 420,
            onPick: (color) {
              widget.onSeedColorChanged(color);
              setState(() {
                final next = _addToRecent(_recentPickerColors, color);
                _recentPickerColors
                  ..clear()
                  ..addAll(next);
              });
            },
            onClose: () => Navigator.of(ctx).pop(),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      ),
    );
  }

  void _openRadiusDialog(BuildContext context) {
    final initialRadius = widget.customRadius ?? _radiusSizeToNumber(widget.radiusSize);
    double localRadius = initialRadius;
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setStateDialog) => AlertDialog(
            title: const Text('Corner radius'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Default radius for buttons, fields, and cards. Changes apply immediately.',
                  style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 20),
                VSegmented<VRadiusSize>(
                  value: widget.radiusSize,
                  onChanged: (v) {
                    widget.onRadiusSizeChanged(v);
                    Navigator.of(ctx).pop();
                  },
                  options: const [
                    VSegmentOption(value: VRadiusSize.none, label: 'None'),
                    VSegmentOption(value: VRadiusSize.sm, label: 'SM'),
                    VSegmentOption(value: VRadiusSize.md, label: 'MD'),
                    VSegmentOption(value: VRadiusSize.lg, label: 'LG'),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Custom radius (0–200): ${localRadius.round()}',
                  style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                      ),
                ),
                VSlider(
                  value: localRadius,
                  onChanged: widget.onCustomRadiusChanged == null
                      ? null
                      : (v) {
                          setStateDialog(() => localRadius = v);
                          widget.onCustomRadiusChanged?.call(v);
                        },
                  min: 0,
                  max: 200,
                  divisions: 200,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Close'),
              ),
            ],
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          ),
        );
      },
    );
  }

  void _openFontPickerDialog(BuildContext context) {
    final options = widget.getFontOptions();
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Font'),
          content: SizedBox(
            width: 360,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option.id == widget.selectedFontId;
                  return ListTile(
                    leading: isSelected ? const Icon(Icons.check) : const SizedBox.shrink(),
                    title: _FontPreviewText(
                      fontId: option.id,
                      name: option.name,
                      selected: isSelected,
                      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                    ),
                    onTap: () {
                      widget.onFontChanged(option.id, option.textThemeBuilder);
                      Navigator.of(ctx).pop();
                    },
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _colorChip(BuildContext context, String label, Color color) {
    final textColor = color.computeLuminance() > 0.55 ? Colors.black : Colors.white;
    return Container(
      width: 120,
      height: 72,
      decoration: BoxDecoration(
        color: color,
        borderRadius: context.vRadius.defaultBorderRadius(),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            _colorToHex(color),
            style: TextStyle(color: textColor.withValues(alpha: 0.9), fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return SizedBox(key: ValueKey(text), height: 0);
  }

}

class _SidebarSection {
  final String title;
  final List<_SidebarItem> items;

  const _SidebarSection({required this.title, required this.items});
}

class _SidebarItem {
  final String id;
  final String label;
  final IconData icon;

  const _SidebarItem({required this.id, required this.label, required this.icon});
}

class _SeedSwatch extends StatelessWidget {
  const _SeedSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 28,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? cs.primary : cs.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: icon == null
              ? null
              : Icon(icon, size: 14, color: color.computeLuminance() > 0.55 ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final radius = BorderRadius.circular(8);
    final foreground = selected ? cs.primary : cs.onSurfaceVariant;
    final labelColor = selected ? cs.primary : cs.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        color: selected ? cs.primary.withValues(alpha: 0.10) : Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          hoverColor: cs.onSurface.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Row(
              children: [
                Icon(icon, size: 18, color: foreground),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: labelColor,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FontDropdown extends StatefulWidget {
  const _FontDropdown({
    required this.getFontOptions,
    required this.value,
    required this.onChanged,
  });

  final List<PlaygroundFontOption> Function() getFontOptions;
  final String value;
  final void Function(String id, TextTheme Function(TextTheme) builder) onChanged;

  @override
  State<_FontDropdown> createState() => _FontDropdownState();
}

class _FontDropdownState extends State<_FontDropdown> {
  final TextEditingController _controller = TextEditingController();
  OverlayEntry? _entry;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
  }

  @override
  void didUpdateWidget(covariant _FontDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _removeEntry();
    _controller.dispose();
    super.dispose();
  }

  void _removeEntry() {
    _entry?.remove();
    _entry = null;
  }

  void _close() {
    if (_entry == null) return;
    _removeEntry();
    if (mounted) setState(() {});
  }

  void _toggle() {
    if (_entry != null) {
      _close();
      return;
    }

    final box = context.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || overlayBox == null) return;

    final topLeft = box.localToGlobal(Offset.zero, ancestor: overlayBox);
    final width = box.size.width;
    const menuHeight = 320.0;
    final spaceBelow = overlayBox.size.height - (topLeft.dy + box.size.height);
    final maxTop = (overlayBox.size.height - menuHeight).clamp(8.0, overlayBox.size.height);
    final top = spaceBelow >= menuHeight + 8
        ? topLeft.dy + box.size.height + 4
        : (topLeft.dy - menuHeight - 4).clamp(8.0, maxTop);

    _entry = OverlayEntry(
      builder: (overlayContext) {
        final theme = Theme.of(overlayContext);
        final cs = theme.colorScheme;
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _close,
              ),
            ),
            Positioned(
              left: topLeft.dx,
              top: top,
              width: width,
              height: menuHeight,
              child: Material(
                color: cs.surface,
                elevation: 6,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: cs.outlineVariant),
                ),
                clipBehavior: Clip.antiAlias,
                child: _FontMenuPanel(
                  options: widget.getFontOptions(),
                  selectedId: widget.value,
                  onSelected: (option) {
                    widget.onChanged(option.id, option.textThemeBuilder);
                    _close();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_entry!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final open = _entry != null;
    return VTextBox(
      controller: _controller,
      label: null,
      hint: 'Font',
      readOnly: true,
      filled: true,
      controlHeight: 40,
      suffixIcon: Icon(open ? Icons.arrow_drop_up : Icons.arrow_drop_down),
      onTap: _toggle,
    );
  }
}

class _FontMenuPanel extends StatefulWidget {
  const _FontMenuPanel({
    required this.options,
    required this.selectedId,
    required this.onSelected,
  });

  final List<PlaygroundFontOption> options;
  final String selectedId;
  final ValueChanged<PlaygroundFontOption> onSelected;

  @override
  State<_FontMenuPanel> createState() => _FontMenuPanelState();
}

class _FontMenuPanelState extends State<_FontMenuPanel> {
  final TextEditingController _filter = TextEditingController();
  final ScrollController _scroll = ScrollController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scroll.hasClients || _query.isNotEmpty) return;
        final index = widget.options.indexWhere((option) => option.id == widget.selectedId);
        if (index <= 0) return;
        final target = (index * 40.0) - 80;
        _scroll.jumpTo(target.clamp(0, _scroll.position.maxScrollExtent));
      });
    });
  }

  @override
  void dispose() {
    _filter.dispose();
    _scroll.dispose();
    super.dispose();
  }

  List<PlaygroundFontOption> get _matches {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.options;
    return [
      for (final option in widget.options)
        if (option.name.toLowerCase().contains(query)) option,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final matches = _matches;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
          child: TextField(
            controller: _filter,
            autofocus: true,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search fonts',
              prefixIcon: const Icon(Icons.search, size: 18),
              filled: true,
              fillColor: cs.surfaceContainerLow,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() => _query = value);
              if (_scroll.hasClients) _scroll.jumpTo(0);
            },
            onSubmitted: (_) {
              if (matches.isNotEmpty) widget.onSelected(matches.first);
            },
          ),
        ),
        Expanded(
          child: matches.isEmpty
              ? Center(
                  child: Text(
                    'No fonts',
                    style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                )
              : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.only(bottom: 8),
                  itemCount: matches.length,
                  itemExtent: 40,
                  itemBuilder: (context, index) {
                    final option = matches[index];
                    final selected = option.id == widget.selectedId;
                    return InkWell(
                      onTap: () => widget.onSelected(option),
                      child: ColoredBox(
                        color: selected ? cs.primary.withValues(alpha: 0.10) : Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: _FontPreviewText(
                                  fontId: option.id,
                                  name: option.name,
                                  selected: selected,
                                ),
                              ),
                              if (selected)
                                Icon(Icons.check, size: 16, color: cs.primary),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

double _radiusSizeToNumber(VRadiusSize size) {
  switch (size) {
    case VRadiusSize.none:
      return 0;
    case VRadiusSize.sm:
      return 6;
    case VRadiusSize.md:
      return 10;
    case VRadiusSize.lg:
      return 16;
  }
}

class _FontPreviewText extends StatefulWidget {
  const _FontPreviewText({
    required this.fontId,
    required this.name,
    required this.selected,
    this.fontSize,
  });

  final String fontId;
  final String name;
  final bool selected;
  final double? fontSize;

  @override
  State<_FontPreviewText> createState() => _FontPreviewTextState();
}

class _FontPreviewTextState extends State<_FontPreviewText> {
  @override
  void initState() {
    super.initState();
    _awaitFont();
  }

  @override
  void didUpdateWidget(covariant _FontPreviewText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fontId != widget.fontId) _awaitFont();
  }

  void _awaitFont() {
    final style = GoogleFonts.getFont(widget.fontId);
    unawaited(
      GoogleFonts.pendingFonts([style]).then((_) {
        if (mounted) setState(() {});
      }, onError: (_) {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Text(
      widget.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.getFont(
        widget.fontId,
        fontSize: widget.fontSize ?? theme.textTheme.bodyMedium?.fontSize ?? 14,
        fontWeight: FontWeight.w400,
        color: widget.selected ? cs.primary : cs.onSurface,
        height: 1.2,
      ),
    );
  }
}

