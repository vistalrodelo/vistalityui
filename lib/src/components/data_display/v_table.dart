import 'package:flutter/material.dart';

/// Simple wrapper around [DataTable].
class VDataTable extends StatelessWidget {
  /// Column definitions.
  final List<DataColumn> columns;

  /// Row definitions.
  final List<DataRow> rows;

  /// Creates a [VDataTable].
  const VDataTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(columns: columns, rows: rows);
  }
}

/// [DataTable] with sorting configuration.
class VSortableTable extends StatelessWidget {
  /// Column definitions.
  final List<DataColumn> columns;

  /// Row definitions.
  final List<DataRow> rows;

  /// Column index being sorted.
  final int? sortColumnIndex;

  /// Whether sort is ascending.
  final bool sortAscending;

  /// Creates a [VSortableTable].
  const VSortableTable({
    super.key,
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortAscending = true,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: columns,
      rows: rows,
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
    );
  }
}

/// [DataTable] with a text filter input.
///
/// Rows whose visible [Text] matches [filterText] are shown. Rows that contain
/// only non-text cells stay visible so custom editors are not dropped.
class VFilterableTable extends StatefulWidget {
  /// Column definitions.
  final List<DataColumn> columns;

  /// Row definitions.
  final List<DataRow> rows;

  /// Current filter text.
  final String filterText;

  /// Called when the filter changes.
  final ValueChanged<String> onFilterChanged;

  /// Creates a [VFilterableTable].
  const VFilterableTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.filterText,
    required this.onFilterChanged,
  });

  @override
  State<VFilterableTable> createState() => _VFilterableTableState();
}

class _VFilterableTableState extends State<VFilterableTable> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.filterText);
  }

  @override
  void didUpdateWidget(VFilterableTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filterText != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.filterText,
        selection: TextSelection.collapsed(offset: widget.filterText.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.filterText.trim().toLowerCase();
    final filtered = widget.rows.where((row) => _rowMatches(row, query)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Filter',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: widget.onFilterChanged,
        ),
        const SizedBox(height: 8),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('No matching rows'),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(columns: widget.columns, rows: filtered),
          ),
      ],
    );
  }
}

bool _rowMatches(DataRow row, String query) {
  if (query.isEmpty) return true;
  final texts = row.cells
      .map((cell) => _plainText(cell.child).toLowerCase())
      .where((text) => text.isNotEmpty)
      .toList();
  if (texts.isEmpty) return true;
  return texts.any((text) => text.contains(query));
}

String _plainText(Widget widget) {
  if (widget is Text) {
    if (widget.data != null) return widget.data!;
    final span = widget.textSpan;
    if (span != null) return span.toPlainText();
  }
  if (widget is RichText) return widget.text.toPlainText();
  return '';
}

/// Paginated table built on [PaginatedDataTable].
class VPaginatedTable extends StatelessWidget {
  /// Column definitions.
  final List<DataColumn> columns;

  /// Data source for rows.
  final DataTableSource source;

  /// Rows per page.
  final int rowsPerPage;

  /// Creates a [VPaginatedTable].
  const VPaginatedTable({
    super.key,
    required this.columns,
    required this.source,
    this.rowsPerPage = 5,
  });

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      columns: columns,
      source: source,
      rowsPerPage: rowsPerPage,
    );
  }
}

/// Editable table constructed from widget cells.
class VEditableTable extends StatelessWidget {
  /// Column definitions.
  final List<DataColumn> columns;

  /// Row widget cells.
  final List<List<Widget>> rows;

  /// Creates a [VEditableTable].
  const VEditableTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: columns,
      rows: rows
          .map(
            (cells) => DataRow(cells: cells.map((c) => DataCell(c)).toList()),
          )
          .toList(),
    );
  }
}

/// Table with a custom sticky header row.
class VStickyHeaderTable extends StatelessWidget {
  /// Header labels.
  final List<String> headers;

  /// Row cell values.
  final List<List<String>> rows;

  /// Creates a [VStickyHeaderTable].
  const VStickyHeaderTable({
    super.key,
    required this.headers,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            children: headers
                .map((h) => Expanded(child: Text(h, style: const TextStyle(fontWeight: FontWeight.bold))))
                .toList(),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rows.length,
          itemBuilder: (context, index) {
            final row = rows[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Row(
                children: row.map((cell) => Expanded(child: Text(cell))).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
