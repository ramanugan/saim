import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/saim_button.dart';
import '../../../core/theme/app_theme.dart';

class CorrectivoDetailPanel extends StatelessWidget {
  CorrectivoDetailPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, ),
          Divider(height: 1, color: context.borderColor),
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildSolicitudPanel(context, )),
                SizedBox(width: 32),
                Expanded(flex: 4, child: _buildEvaluacionPanel(context)),
                SizedBox(width: 32),
                Expanded(flex: 3, child: _buildHitosPanel(context, )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COR-2026-00208 · FOLIO CLIENTE SM-94733',
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Satélite · Pérdida de temperatura',
                      style: TextStyle(
                        color: context.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Reporte directo · prioridad Crítica · IG-00078',
                      style: TextStyle(
                        color: context.mutedTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.red50,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Color(0xFFF3A7A7)),
                ),
                child: Text(
                  'SLA vence 1 h 20',
                  style: TextStyle(color: AppColors.red, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSmallChip(context, 'Abrir IG-00078'),
              _buildSmallChip(context, 'Refacciones vinculadas', active: true),
              _buildSmallChip(context, 'Cerrar falla / orden'),
              _buildSmallChip(context, 'Ir a facturación'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallChip(BuildContext context, String text, {bool active = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active ? AppColors.blue50 : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: active ? AppColors.blue : Color(0xFFB8C8D8)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.blue,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildSolicitudPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Solicitud y diagnóstico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        SizedBox(height: 16),
        _buildInfoRow(context, 'Solicitó', 'Ana Torres · Gerente'),
        _buildInfoRow(context, 'Canal', 'Correo + folio cliente'),
        _buildInfoRow(context, 'Afectación', 'Operación al 60 %'),
        _buildInfoRow(context, 'Técnicos', 'AG / DR'),
        SizedBox(height: 16),
        Text('Diagnóstico preliminar', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFFF7F9FB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.borderColor),
          ),
          child: Text(
            'Posible falla en válvula de expansión y pérdida parcial de refrigerante. Se requieren pruebas de hermeticidad.',
            style: TextStyle(fontSize: 12, height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: context.mutedTextColor, fontSize: 11)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildEvaluacionPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Evaluación económica', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFFFFF7E6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFFFD580)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Resultado de cobertura', style: TextStyle(color: Color(0xFFB2821E), fontSize: 9)),
              SizedBox(height: 4),
              Text('Correctivo cobrable adicional', style: TextStyle(color: AppColors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(height: 4),
              Text('Atención y diagnóstico dentro del SLA. Materiales, refacciones y mano de obra correctiva se cotizan.', style: TextStyle(color: Color(0xFFB2821E), fontSize: 10)),
            ],
          ),
        ),
        SizedBox(height: 24),
        _buildCostRow(context, 'Mano de obra', '\$12,800'),
        _buildCostRow(context, 'Refacciones', '\$24,500'),
        _buildCostRow(context, 'Materiales', '\$6,900'),
        _buildCostRow(context, 'Equipo especial', '\$4,200'),
        Divider(color: context.borderColor, height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total estimado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('\$48,400', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        SizedBox(height: 24),
        SaimButton(
          text: 'Generar cotización v1',
          onPressed: () => _showTempDialog(context, 'Generar cotización v1'),
          fullWidth: true,
        ),
        SizedBox(height: 8),
        SaimButton(
          text: 'Registrar autorización del cliente',
          onPressed: () => _showTempDialog(context, 'Registrar autorización'),
          type: SaimButtonType.secondary,
          fullWidth: true,
        ),
      ],
    );
  }

  void _showTempDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(action),
        content: Text('Esta acción está en construcción y no guarda cambios reales.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildHitosPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hitos y documentos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        SizedBox(height: 16),
        _buildStep(context, 
          step: '1',
          title: 'Reporte recibido',
          subtitle: '26 jul · 07:42',
          done: true,
        ),
        _buildStep(context, 
          step: '2',
          title: 'Cuadrilla en tienda',
          subtitle: '26 jul · 10:14',
          done: true,
        ),
        _buildStep(context, 
          step: '3',
          title: 'Diagnóstico',
          subtitle: 'En proceso',
          isActive: true,
        ),
        _buildStep(context, 
          step: '4',
          title: 'Cotización',
          subtitle: 'Pendiente',
        ),
        _buildStep(context, 
          step: '5',
          title: 'Autorización',
          subtitle: 'Pendiente',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildStep(BuildContext context, {
    required String step,
    required String title,
    required String subtitle,
    bool done = false,
    bool isActive = false,
    bool isLast = false,
  }) {
    Color iconBg = done ? AppColors.green : (isActive ? AppColors.blue : Color(0xFFE2E8F0));
    Color iconColor = (done || isActive) ? Colors.white : AppColors.muted;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: done
                  ? Icon(Icons.check, size: 14, color: context.surfaceColor)
                  : Center(
                      child: Text(
                        step,
                        style: TextStyle(color: iconColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: Color(0xFFE2E8F0),
              ),
          ],
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: done || isActive ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
            SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: context.mutedTextColor, fontSize: 10)),
          ],
        ),
      ],
    );
  }
}
