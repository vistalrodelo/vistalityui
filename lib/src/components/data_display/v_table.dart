import 'package:flutter/material.dart';

class VDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;

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

class VSortableTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final int? sortColumnIndex;
  final bool sortAscending;

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

class VFilterableTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final String filterText;
  final ValueChanged<String> onFilterChanged;

  const VFilterableTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.filterText,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Filter'),
          onChanged: onFilterChanged,
        ),
        const SizedBox(height: 8),
        DataTable(columns: columns, rows: rows),
      ],
    );
  }
}

class VPaginatedTable extends StatelessWidget {
  final List<DataColumn> columns;
  final DataTableSource source;
  final int rowsPerPage;

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

class VEditableTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<List<Widget>> rows;

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

class VStickyHeaderTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;

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
