import 'package:flutter/material.dart';
import '../../shared/layouts/app_layout.dart';
import 'widgets/field_order_header.dart';
import 'widgets/field_order_stepper.dart';
import 'widgets/context_ribbon.dart';
import 'widgets/sections/section_01_identification.dart';
import 'widgets/sections/section_02_equipment.dart';
import 'widgets/sections/section_03_readings.dart';
import 'widgets/sections/section_04_diagnosis.dart';
import 'widgets/sections/section_05_parts.dart';
import 'widgets/sections/section_06_materials.dart';
import 'widgets/sections/section_07_schedule.dart';
import 'widgets/sections/section_08_evidence.dart';
import 'widgets/sections/section_09_signature.dart';

class FieldOrderScreen extends StatelessWidget {
  FieldOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Orden en campo',
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FieldOrderHeader(),
            FieldOrderStepper(),
            ContextRibbon(),
            Section01Identification(),
            Section02Equipment(),
            Section03Readings(),
            Section04Diagnosis(),
            Section05Parts(),
            Section06Materials(),
            Section07Schedule(),
            Section08Evidence(),
            Section09Signature(),
            SizedBox(height: 60), // padding at bottom
          ],
        ),
      ),
    );
  }
}
