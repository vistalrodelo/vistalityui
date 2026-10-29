import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vistalityui/vistalityui.dart';

import 'component_showcase_screen.dart';
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

Widget _maxWidthButton(Widget child) => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: _kPlaygroundButtonMaxWidth),
  child: child,
);

class _AppBarSeparator extends StatelessWidget {
  const _AppBarSeparator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1,
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

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

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 78.4, // default 56 * 1.4
        leading: isWide
            ? null
            : IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          tooltip: 'Menu',
        ),
        title: Text(
          'VistalityUI',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
        ),
        actions: isWide
            ? _buildWideAppBarActions(context)
            : _buildCompactAppBarActions(context),
      ),
      drawer: isWide ? null : _buildDrawer(context),
      body: Row(
        children: [
          if (isWide) _buildSidebar(context),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxContentWidth = 880.0;
                final padding = MediaQuery.sizeOf(context).width >= VBreakpoints.lg
                    ? 24.0
                    : 16.0;
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(padding, padding + 8, padding, padding + 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
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
    );
  }

  List<Widget> _buildWideAppBarActions(BuildContext context) {
    return [
      _SeedColorButton(
        seedColor: widget.seedColor,
        onSeedColorChanged: widget.onSeedColorChanged,
        onOpenColorWheel: () => _openColorWheelPicker(context),
        recentColors: _recentPickerColors,
        onAddToRecent: (color) => setState(() {
          final next = _addToRecent(_recentPickerColors, color);
          _recentPickerColors
            ..clear()
            ..addAll(next);
        }),
      ),
      _AppBarSeparator(),
      _RadiusChip(
        radiusSize: widget.radiusSize,
        onRadiusSizeChanged: widget.onRadiusSizeChanged,
        customRadius: widget.customRadius,
        onCustomRadiusChanged: widget.onCustomRadiusChanged,
      ),
      _AppBarSeparator(),
      _FontAutocomplete(
        getFontOptions: widget.getFontOptions,
        value: widget.selectedFontId,
        onChanged: widget.onFontChanged,
      ),
      _AppBarSeparator(),
      VButton(
        label: 'Search components',
        prefixIcon: const Icon(Icons.search),
        variant: VButtonVariant.text,
        onPressed: () => _openComponentSearch(context),
      ),
      _AppBarSeparator(),
      const SizedBox(width: 50),
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
      const SizedBox(width: 40),
    ];
  }

  List<Widget> _buildCompactAppBarActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.search),
        tooltip: 'Search components',
        onPressed: () => _openComponentSearch(context),
      ),
      PopupMenuButton<String>(
        tooltip: 'Playground options',
        onSelected: (value) {
          switch (value) {
            case _mobileMenuSeedColor:
              _openSeedColorDialog(context);
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
            child: ListTile(
              leading: Icon(Icons.palette_outlined),
              title: Text('Seed color'),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
          const PopupMenuItem<String>(
            value: _mobileMenuCornerRadius,
            child: ListTile(
              leading: Icon(Icons.rounded_corner),
              title: Text('Corner radius'),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
          const PopupMenuItem<String>(
            value: _mobileMenuFont,
            child: ListTile(
              leading: Icon(Icons.font_download_outlined),
              title: Text('Font'),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
          PopupMenuItem<String>(
            value: _mobileMenuDarkMode,
            child: ListTile(
              leading: Icon(
                widget.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              ),
              title: Text(widget.isDarkMode ? 'Dark mode: on' : 'Dark mode: off'),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
        ],
      ),
      const SizedBox(width: 4),
    ];
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: _buildSidebarContent(context),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        border: Border(right: BorderSide(color: vc.outline.withValues(alpha: 0.2))),
      ),
      child: _buildSidebarContent(context),
    );
  }

  Widget _buildSidebarContent(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    const sections = [
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

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        for (final section in sections) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              section.title,
              style: theme.textTheme.titleSmall?.copyWith(
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

    if (_selectedId == _overviewId || _selectedId == null) {
      return content;
    }
    return _buildComponentFrame(context, content);
  }

  Widget _buildComponentFrame(BuildContext context, Widget child) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DashedBorderContainer(
          color: cs.outline.withValues(alpha: 0.65),
          borderRadius: 12,
          padding: const EdgeInsets.all(16),
          child: SizedBox(width: double.infinity, child: child),
        ),
      ],
    );
  }

  Widget _contentSection(
      BuildContext context, {
        required String title,
        String? subtitle,
        required List<Widget> children,
        double topPadding = 32,
      }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 0.2,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: subtitle != null ? 16 : 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildOverviewContent(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Design system overview',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.25,
              color: cs.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select seed color, preferred corner radius, or font and see immediately how it looks. '
              'Use the sidebar to explore foundations, actions, data display, and forms.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: cs.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        _contentSection(
          context,
          title: 'Seed color',
          subtitle: 'Select a color to generate the theme (ColorScheme.fromSeed).',
          topPadding: 32,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 16,
              children: [
                ..._kSeedOptions.map((color) {
                  final isSelected = widget.seedColor == color;
                  return GestureDetector(
                    onTap: () => widget.onSeedColorChanged(color),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? cs.outline : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _colorToHex(color),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                GestureDetector(
                  onTap: () => _openColorWheelPicker(context),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.outline),
                          gradient: SweepGradient(
                            center: Alignment.center,
                            colors: const [
                              Color(0xFFFF0000),
                              Color(0xFFFFFF00),
                              Color(0xFF00FF00),
                              Color(0xFF00FFFF),
                              Color(0xFF0000FF),
                              Color(0xFFFF00FF),
                              Color(0xFFFF0000),
                            ],
                          ),
                        ),
                        child: Icon(Icons.touch_app, size: 18, color: cs.onSurface),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Color wheel',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        _contentSection(
          context,
          title: 'Font',
          subtitle: 'Select a font family for the app typography.',
          topPadding: 32,
          children: [
            SizedBox(
              width: 280,
              child: _FontAutocomplete(
                getFontOptions: widget.getFontOptions,
                value: widget.selectedFontId,
                onChanged: widget.onFontChanged,
              ),
            ),
          ],
        ),
        _contentSection(
          context,
          title: 'Dark mode',
          subtitle: 'Toggle light or dark theme for the whole app.',
          topPadding: 32,
          children: [
            VSwitch(
              value: widget.isDarkMode,
              onChanged: widget.onDarkModeChanged,
              label: 'Dark mode',
            ),
          ],
        ),
        _contentSection(
          context,
          title: 'Corner radius',
          subtitle: 'Default corner radius for buttons, fields, and cards (none, sm, md, lg).',
          topPadding: 32,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Floating Action Buttons'),
        const SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          VFab(icon: Icons.add, tooltip: 'Add', onPressed: () {}),
          VFab(icon: Icons.edit, tooltip: 'Edit', onPressed: () {}),
        ]),
      ],
    );
  }

  Widget _buildSegmentedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Segmented Buttons'),
        const SizedBox(height: 16),
        VSegmented<String>(
          value: _segmentValue,
          onChanged: (v) => setState(() => _segmentValue = v),
          options: const [
            VSegmentOption(value: 'day', label: 'Day'),
            VSegmentOption(value: 'week', label: 'Week'),
            VSegmentOption(value: 'month', label: 'Month'),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButtonsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Icon Buttons'),
        const SizedBox(height: 16),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Action Chips'),
        const SizedBox(height: 16),
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

  void _openSeedColorDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => _SeedColorPickerDialog(
        seedColor: widget.seedColor,
        onSeedColorChanged: widget.onSeedColorChanged,
        onClose: () => Navigator.of(dialogContext).pop(),
        dialogContext: dialogContext,
        onOpenColorWheel: () => _openColorWheelPicker(context),
        recentColors: _recentPickerColors,
        onAddToRecent: (color) => setState(() {
          final next = _addToRecent(_recentPickerColors, color);
          _recentPickerColors
            ..clear()
            ..addAll(next);
        }),
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
                  final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontFamily: option.fontFamily,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      );
                  return ListTile(
                    leading: isSelected ? const Icon(Icons.check) : const SizedBox.shrink(),
                    title: Text(option.name, style: style),
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

  void _openComponentSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ComponentShowcaseScreen(
          isDarkMode: widget.isDarkMode,
          onDarkModeChanged: widget.onDarkModeChanged,
        ),
      ),
    );
  }

  Widget _colorChip(BuildContext context, String label, Color color) {
    final textColor = color.computeLuminance() > 0.55 ? Colors.black : Colors.white;
    return Container(
      width: 120,
      height: 72,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
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
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
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
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);

    return Material(
      color: selected ? vc.primary.withValues(alpha: 0.12) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? vc.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: selected ? vc.primary : cs.onSurface,
                    fontWeight: selected ? FontWeight.w600 : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderContainer extends StatelessWidget {
  const _DashedBorderContainer({
    required this.child,
    required this.color,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = 10,
  });

  final Widget child;
  final Color color;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRRectPainter(
        color: color,
        borderRadius: borderRadius,
        strokeWidth: 1,
        dashLength: 6,
        gapLength: 4,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  final Color color;
  final double borderRadius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      Radius.circular(borderRadius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = min(distance + dashLength, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return color != oldDelegate.color ||
        borderRadius != oldDelegate.borderRadius ||
        strokeWidth != oldDelegate.strokeWidth ||
        dashLength != oldDelegate.dashLength ||
        gapLength != oldDelegate.gapLength;
  }
}

class _SeedColorButton extends StatelessWidget {
  const _SeedColorButton({
    required this.seedColor,
    required this.onSeedColorChanged,
    this.onOpenColorWheel,
    this.recentColors = const [],
    this.onAddToRecent,
  });

  final Color seedColor;
  final ValueChanged<Color> onSeedColorChanged;
  final VoidCallback? onOpenColorWheel;
  final List<Color> recentColors;
  final ValueChanged<Color>? onAddToRecent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            showDialog<void>(
              context: context,
              builder: (dialogContext) => _SeedColorPickerDialog(
                seedColor: seedColor,
                onSeedColorChanged: onSeedColorChanged,
                onClose: () => Navigator.of(dialogContext).pop(),
                dialogContext: dialogContext,
                onOpenColorWheel: onOpenColorWheel,
                recentColors: recentColors,
                onAddToRecent: onAddToRecent,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Seed color',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: seedColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.palette_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SeedColorPickerDialog extends StatefulWidget {
  const _SeedColorPickerDialog({
    required this.seedColor,
    required this.onSeedColorChanged,
    required this.onClose,
    required this.dialogContext,
    required this.onOpenColorWheel,
    this.recentColors = const [],
    this.onAddToRecent,
  });

  final Color seedColor;
  final ValueChanged<Color> onSeedColorChanged;
  final VoidCallback onClose;
  final BuildContext dialogContext;
  final VoidCallback? onOpenColorWheel;
  final List<Color> recentColors;
  final ValueChanged<Color>? onAddToRecent;

  @override
  State<_SeedColorPickerDialog> createState() => _SeedColorPickerDialogState();
}

class _SeedColorPickerDialogState extends State<_SeedColorPickerDialog> {
  bool _showingColorWheel = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (_showingColorWheel) {
      return AlertDialog(
        title: const Text('Color wheel'),
        content: SizedBox(
          width: 420,
          child: VColorWheelPicker(
            initialColor: widget.seedColor,
            commonColors: kVColorWheelCommonColors,
            recentColors: widget.recentColors,
            contentWidth: 420,
            onPick: (color) {
              widget.onSeedColorChanged(color);
              widget.onAddToRecent?.call(color);
              setState(() => _showingColorWheel = false);
            },
            onClose: () => setState(() => _showingColorWheel = false),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      );
    }
    return AlertDialog(
      title: const Text('Seed color'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a color to generate the theme automatically (Material 3 ColorScheme.fromSeed).',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 20,
              children: [
                ..._kSeedOptions.map((color) {
                  final isSelected = widget.seedColor == color;
                  return GestureDetector(
                    onTap: () {
                      widget.onSeedColorChanged(color);
                      Navigator.of(widget.dialogContext).pop();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? cs.primary : cs.outline.withValues(alpha: 0.3),
                              width: isSelected ? 3 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _colorToHex(color),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                GestureDetector(
                  onTap: () => setState(() => _showingColorWheel = true),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.outline),
                          gradient: const SweepGradient(
                            center: Alignment.center,
                            colors: [
                              Color(0xFFFF0000),
                              Color(0xFFFFFF00),
                              Color(0xFF00FF00),
                              Color(0xFF00FFFF),
                              Color(0xFF0000FF),
                              Color(0xFFFF00FF),
                              Color(0xFFFF0000),
                            ],
                          ),
                        ),
                        child: Icon(Icons.touch_app, size: 20, color: cs.onSurface),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Color wheel',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onClose,
          child: const Text('Close'),
        ),
      ],
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
    );
  }
}

String _radiusLabel(VRadiusSize size) {
  switch (size) {
    case VRadiusSize.none:
      return 'None';
    case VRadiusSize.sm:
      return 'SM';
    case VRadiusSize.md:
      return 'MD';
    case VRadiusSize.lg:
      return 'LG';
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

class _FontAutocomplete extends StatefulWidget {
  const _FontAutocomplete({
    required this.getFontOptions,
    required this.value,
    required this.onChanged,
  });

  final List<PlaygroundFontOption> Function() getFontOptions;
  final String value;
  final void Function(String id, TextTheme Function(TextTheme) builder) onChanged;

  @override
  State<_FontAutocomplete> createState() => _FontAutocompleteState();
}

class _FontAutocompleteState extends State<_FontAutocomplete> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  List<PlaygroundFontOption>? _options;
  Map<String, PlaygroundFontOption>? _optionById;
  static const int _maxOptions = 40;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _options == null) _loadOptions();
  }

  void _loadOptions() {
    final list = widget.getFontOptions();
    if (mounted) {
      setState(() {
        _options = list;
        _optionById = {for (final o in list) o.id: o};
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _FontAutocomplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  Iterable<String> _filterOptions(String query) {
    final options = _options ?? [];
    if (options.isEmpty) return const <String>[];
    if (query.isEmpty) {
      return options.take(_maxOptions).map((o) => o.id);
    }
    final lower = query.toLowerCase();
    return options
        .where((o) => o.name.toLowerCase().contains(lower))
        .take(_maxOptions)
        .map((o) => o.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: SizedBox(
        width: 200,
        height: 40,
        child: RawAutocomplete<String>(
          textEditingController: _controller,
          focusNode: _focusNode,
          optionsBuilder: (value) => _filterOptions(value.text.trim()),
          onSelected: (id) {
            final option = _optionById?[id];
            if (option != null) {
              _controller.text = id;
              widget.onChanged(id, option.textThemeBuilder);
            }
          },
          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
            return VTextBox(
              controller: controller,
              focusNode: focusNode,
              label: 'Font',
              hint: 'Search or select font',
              readOnly: false,
              filled: true,
              controlHeight: 40,
              suffixIcon: const Icon(Icons.arrow_drop_down),
              onTap: () => focusNode.requestFocus(),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            final optionById = _optionById ?? {};
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final id = options.elementAt(index);
                      final option = optionById[id];
                      final name = option?.name ?? id;
                      final fontFamily = option?.fontFamily;
                      final style = fontFamily != null
                          ? baseStyle?.copyWith(fontFamily: fontFamily)
                          : baseStyle;
                      return ListTile(
                        title: Text(name, style: style),
                        onTap: () => onSelected(id),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RadiusChip extends StatelessWidget {
  const _RadiusChip({
    required this.radiusSize,
    required this.onRadiusSizeChanged,
    this.customRadius,
    this.onCustomRadiusChanged,
  });

  final VRadiusSize radiusSize;
  final ValueChanged<VRadiusSize> onRadiusSizeChanged;
  final double? customRadius;
  final ValueChanged<double>? onCustomRadiusChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            final initialRadius =
                customRadius ?? _radiusSizeToNumber(radiusSize);
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
                                color: Theme.of(ctx)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 20),
                        VSegmented<VRadiusSize>(
                          value: radiusSize,
                          onChanged: (v) {
                            onRadiusSizeChanged(v);
                            Navigator.of(ctx).pop();
                          },
                          options: const [
                            VSegmentOption(
                                value: VRadiusSize.none, label: 'None'),
                            VSegmentOption(
                                value: VRadiusSize.sm, label: 'SM'),
                            VSegmentOption(
                                value: VRadiusSize.md, label: 'MD'),
                            VSegmentOption(
                                value: VRadiusSize.lg, label: 'LG'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Custom radius (0–200): ${localRadius.round()}',
                          style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                                color: Theme.of(ctx)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                        VSlider(
                          value: localRadius,
                          onChanged: onCustomRadiusChanged == null
                              ? null
                              : (v) {
                                  setStateDialog(() => localRadius = v);
                                  onCustomRadiusChanged?.call(v);
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
                    contentPadding:
                        const EdgeInsets.fromLTRB(24, 20, 24, 8),
                    actionsPadding:
                        const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  ),
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Corner radius',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.rounded_corner,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 4),
                Text(
                  customRadius != null
                      ? 'Custom (${customRadius!.round()})'
                      : _radiusLabel(radiusSize),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
