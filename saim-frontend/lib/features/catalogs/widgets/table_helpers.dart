import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class CatalogPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  CatalogPanel({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.borderColor),
        boxShadow: AppColors.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: context.textColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.mutedTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class CatalogDataTable extends StatefulWidget {
  final List<String> columns;
  final List<DataRow> rows;

  CatalogDataTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  @override
  State<CatalogDataTable> createState() => _CatalogDataTableState();
}

class _CatalogDataTableState extends State<CatalogDataTable> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dataTableTheme: DataTableThemeData(
                    dataTextStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.ink,
                    ),
                    headingTextStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: context.mutedTextColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Color(0xFFF9FBFC)),
                  dataRowMaxHeight: double.infinity,
                  dataRowMinHeight: 48,
                  headingRowHeight: 40,
                  dividerThickness: 1,
                  columnSpacing: 16,
                  horizontalMargin: 16,
                  columns: widget.columns
                      .map((c) => DataColumn(label: Text(c)))
                      .toList(),
                  rows: widget.rows,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
