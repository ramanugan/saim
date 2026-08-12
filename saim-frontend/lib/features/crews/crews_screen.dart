import 'package:flutter/material.dart';
import '../../shared/layouts/app_layout.dart';
import 'widgets/crews_header.dart';
import 'widgets/crews_summary.dart';
import 'widgets/crews_board.dart';
import 'widgets/crews_history_table.dart';

class CrewsScreen extends StatelessWidget {
  CrewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Cuadrillas',
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CrewsHeader(),
            CrewsSummary(),
            CrewsBoard(),
            SizedBox(height: 32),
            CrewsHistoryTable(),
          ],
        ),
      ),
    );
  }
}
