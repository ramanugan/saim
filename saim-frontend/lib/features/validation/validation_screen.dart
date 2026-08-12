import 'package:flutter/material.dart';
import '../../shared/layouts/app_layout.dart';
import 'widgets/validation_header.dart';
import 'widgets/validation_context_links.dart';
import 'widgets/validation_queue.dart';
import 'widgets/validation_detail.dart';

class ValidationScreen extends StatelessWidget {
  ValidationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Validación de órdenes',
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValidationHeader(),
            SizedBox(height: 16),
            ValidationContextLinks(),
            SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Panel Izquierdo: Cola de revisión
                SizedBox(
                  width: 300,
                  child: ValidationQueue(),
                ),
                SizedBox(width: 24),
                // Panel Derecho: Detalle de validación
                Expanded(
                  child: ValidationDetail(),
                ),
              ],
            ),
            SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
