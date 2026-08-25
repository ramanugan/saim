import 'package:flutter/material.dart';

class ModalDataTable extends StatefulWidget {
  final DataTable dataTable;

  const ModalDataTable({super.key, required this.dataTable});

  @override
  State<ModalDataTable> createState() => _ModalDataTableState();
}

class _ModalDataTableState extends State<ModalDataTable> {
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _horizontalController,
      thumbVisibility: true,
      trackVisibility: true,
      child: SingleChildScrollView(
        controller: _horizontalController,
        scrollDirection: Axis.horizontal,
        child: widget.dataTable,
      ),
    );
  }
}
