import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ModalDataTable extends StatefulWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final List<String> searchableValues;
  final int rowsPerPage;
  final TextStyle? headingTextStyle;

  const ModalDataTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.searchableValues,
    this.rowsPerPage = 10,
    this.headingTextStyle,
  }) : assert(rows.length == searchableValues.length,
            'rows.length must equal searchableValues.length');

  @override
  State<ModalDataTable> createState() => _ModalDataTableState();
}

class _ModalDataTableState extends State<ModalDataTable> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 0;
  String _searchQuery = '';

  /// Returns indices of rows that match the current search query.
  List<int> get _filteredIndices {
    if (_searchQuery.isEmpty) {
      return List.generate(widget.rows.length, (i) => i);
    }
    final query = _searchQuery.toLowerCase();
    return [
      for (int i = 0; i < widget.searchableValues.length; i++)
        if (widget.searchableValues[i].toLowerCase().contains(query)) i,
    ];
  }

  int get _totalPages {
    final filtered = _filteredIndices.length;
    if (filtered == 0) return 1;
    return (filtered / widget.rowsPerPage).ceil();
  }

  @override
  void didUpdateWidget(covariant ModalDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When data changes reactively, ensure current page is still valid
    if (oldWidget.rows.length != widget.rows.length) {
      final maxPage = _totalPages - 1;
      if (_currentPage > maxPage) {
        _currentPage = maxPage < 0 ? 0 : maxPage;
      }
    }
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _currentPage = 0; // Reset to first page on search
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _currentPage = 0;
    });
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredIndices = _filteredIndices;
    final totalFiltered = filteredIndices.length;
    final totalPages = _totalPages;

    // Clamp current page
    if (_currentPage >= totalPages) {
      _currentPage = totalPages - 1;
    }
    if (_currentPage < 0) _currentPage = 0;

    final startIndex = _currentPage * widget.rowsPerPage;
    final endIndex = (startIndex + widget.rowsPerPage).clamp(0, totalFiltered);
    final pageIndices = filteredIndices.sublist(startIndex, endIndex);
    final pageRows = pageIndices.map((i) => widget.rows[i]).toList();

    final rangeStart = totalFiltered == 0 ? 0 : startIndex + 1;
    final rangeEnd = endIndex;

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            style: TextStyle(color: context.textColor, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Buscar...',
              hintStyle: TextStyle(color: context.mutedTextColor, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: context.mutedTextColor, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.close, color: context.mutedTextColor, size: 18),
                      onPressed: _clearSearch,
                    )
                  : null,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: context.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: context.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: context.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: context.borderColor, width: 1.5),
              ),
            ),
          ),
        ),
        // Table
        Expanded(
          child: totalFiltered == 0
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      _searchQuery.isNotEmpty
                          ? 'No se encontraron resultados para "$_searchQuery"'
                          : 'No hay registros.',
                      style: TextStyle(color: context.mutedTextColor, fontSize: 14),
                    ),
                  ),
                )
              : ClipRect(
                  child: Scrollbar(
                    controller: _verticalController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _verticalController,
                      scrollDirection: Axis.vertical,
                      child: Scrollbar(
                        controller: _horizontalController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalController,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            dataRowMinHeight: 38,
                            dataRowMaxHeight: 44,
                            headingRowHeight: 42,
                            columns: widget.columns,
                            rows: pageRows,
                            headingTextStyle: widget.headingTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        // Pagination controls
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: context.borderColor)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mostrando $rangeStart–$rangeEnd de $totalFiltered',
                style: TextStyle(color: context.mutedTextColor, fontSize: 12),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Previous button
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: 20),
                    color: _currentPage > 0 ? context.textColor : context.mutedTextColor,
                    onPressed: _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  // Page numbers
                  ..._buildPageNumbers(totalPages, context),
                  // Next button
                  IconButton(
                    icon: Icon(Icons.chevron_right, size: 20),
                    color: _currentPage < totalPages - 1 ? context.textColor : context.mutedTextColor,
                    onPressed: _currentPage < totalPages - 1 ? () => _goToPage(_currentPage + 1) : null,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPageNumbers(int totalPages, BuildContext context) {
    // Show at most 5 page buttons, with ellipsis for larger sets
    const maxVisible = 5;
    List<int> pages = [];

    if (totalPages <= maxVisible) {
      pages = List.generate(totalPages, (i) => i);
    } else {
      pages.add(0); // Always show first

      int start = (_currentPage - 1).clamp(1, totalPages - 3);
      int end = (start + 2).clamp(start, totalPages - 2);

      // Adjust start if end is capped
      if (end == totalPages - 2) {
        start = (end - 2).clamp(1, end);
      }

      if (start > 1) pages.add(-1); // Ellipsis
      for (int i = start; i <= end; i++) {
        pages.add(i);
      }
      if (end < totalPages - 2) pages.add(-1); // Ellipsis

      pages.add(totalPages - 1); // Always show last
    }

    return pages.map((page) {
      if (page == -1) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text('…', style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
        );
      }
      final isActive = page == _currentPage;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: InkWell(
          onTap: isActive ? null : () => _goToPage(page),
          borderRadius: BorderRadius.circular(4),
          child: Container(
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive ? context.textColor.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${page + 1}',
              style: TextStyle(
                color: isActive ? context.textColor : context.mutedTextColor,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
