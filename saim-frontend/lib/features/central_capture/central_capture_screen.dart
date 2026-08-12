import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/layouts/app_drawer.dart';
import 'widgets/central_capture_header.dart';
import 'widgets/central_capture_stepper.dart';
import 'widgets/document_viewer.dart';
import 'widgets/context_ribbon.dart';
import 'widgets/sections/section_00_reception.dart';
import 'widgets/sections/section_01_identification.dart';
import 'widgets/sections/section_02_equipment.dart';
import 'widgets/sections/section_03_readings.dart';
import 'widgets/sections/section_04_diagnosis.dart';
import 'widgets/sections/section_05_parts.dart';
import 'widgets/sections/section_06_materials.dart';
import 'widgets/sections/section_07_workforce.dart';
import 'widgets/sections/section_08_evidence.dart';
import 'widgets/sections/section_09_signatures.dart';
import '../../core/theme/app_theme.dart';

class CentralCaptureScreen extends StatelessWidget {
  CentralCaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Captura central', style: TextStyle(color: context.textColor, fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: context.surfaceColor,
        iconTheme: IconThemeData(color: context.textColor),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CentralCaptureHeader(),
            SizedBox(height: 32),
            CentralCaptureStepper(),
            SizedBox(height: 32),
            DocumentViewer(),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ContextRibbon(),
                  Section00Reception(),
                  SizedBox(height: 32),
                  Section01Identification(),
                  SizedBox(height: 32),
                  Section02Equipment(),
                  SizedBox(height: 32),
                  Section03Readings(),
                  SizedBox(height: 32),
                  Section04Diagnosis(),
                  SizedBox(height: 32),
                  Section05Parts(),
                  SizedBox(height: 32),
                  Section06Materials(),
                  SizedBox(height: 32),
                  Section07Workforce(),
                  SizedBox(height: 32),
                  Section08Evidence(),
                  SizedBox(height: 32),
                  Section09Signatures(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
