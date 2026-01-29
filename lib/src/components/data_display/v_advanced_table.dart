import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';

class VAdvancedTable extends StatefulWidget {
  final List<String> headers;
  final List<List<String>> rows;
  final int rowsPerPage;

  const VAdvancedTable({
    super.key,
    required this.headers,
    required this.rows,
    this.rowsPerPage = 5,
  });

  @override
  State<VAdvancedTable> createState() => _VAdvancedTableState();
}

class _VAdvancedTableState extends State<VAdvancedTable> {
  String _filter = '';
  int _page = 0;
  int _sortColumn = 0;
  bool _ascending = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);

    final filtered = widget.rows.where((row) {
      if (_filter.isEmpty) return true;
      return row.any((cell) => cell.toLowerCase().contains(_filter.toLowerCase()));
    }).toList();

    filtered.sort((a, b) {
      final av = a[_sortColumn];
      final bv = b[_sortColumn];
      return _ascending ? av.compareTo(bv) : bv.compareTo(av);
    });

    final totalPages = (filtered.length / widget.rowsPerPage).ceil().clamp(1, 9999);
    final start = _page * widget.rowsPerPage;
    final end = (start + widget.rowsPerPage).clamp(0, filtered.length);
    final pageRows = filtered.sublist(start, end);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Filter'),
          onChanged: (v) {
            setState(() {
              _filter = v;
              _page = 0;
            });
          },
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: cs.surface,
          child: Row(
            children: List.generate(widget.headers.length, (index) {
              final label = widget.headers[index];
              final isActive = index == _sortColumn;
              return Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (_sortColumn == index) {
                        _ascending = !_ascending;
                      } else {
                        _sortColumn = index;
                        _ascending = true;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        label,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (isActive)
                        Icon(
                          _ascending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          size: 18,
                          color: vc.primary,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pageRows.length,
          itemBuilder: (context, index) {
            final row = pageRows[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Row(
                children: row.map((cell) => Expanded(child: Text(cell))).toList(),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('Page ${_page + 1} of $totalPages'),
            const Spacer(),
            TextButton(
              onPressed: _page > 0 ? () => setState(() => _page--) : null,
              child: const Text('Prev'),
            ),
            TextButton(
              onPressed: _page + 1 < totalPages ? () => setState(() => _page++) : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
