import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../../shared/widgets/saim_button.dart';
import '../../../core/theme/app_theme.dart';

class StoreDetailPanel extends StatelessWidget {
  StoreDetailPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
        boxShadow: AppColors.shadow,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TIENDA SELECCIONADA',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: AppColors.blue,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Río Nilo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: context.textColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Determinante 28 · Soriana Súper · Guadalajara, Jalisco',
                          style: TextStyle(
                            fontSize: 13,
                            color: context.mutedTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusPill(
                    text: 'Cobertura activa',
                    type: StatusType.success,
                    large: true,
                  ),
                ],
              ),
              SizedBox(height: 24),
              
              // Store Grid
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _DetailBox(label: 'Zona contractual', value: 'Occidente'),
                  _DetailBox(label: 'Fecha de inclusión', value: '01 ene 2026'),
                  _DetailBox(label: 'Tipo de tienda', value: 'Súper'),
                  _DetailBox(label: 'Municipio', value: 'Guadalajara'),
                  _DetailBox(label: 'Coordenadas', value: '20.6597, -103.3496'),
                  _DetailBox(label: 'Anexo', value: 'ANX-OCC-2026-02'),
                ],
              ),
              
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Divider(height: 1, color: context.borderColor),
              ),
              
              // Iguala Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Iguala vigente',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: context.textColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Condiciones particulares de la tienda',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.mutedTextColor,
                        ),
                      ),
                    ],
                  ),
                  SaimButton(
                    text: 'Ver iguala',
                    type: SaimButtonType.secondary,
                    small: true,
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              // Iguala Grid
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _DetailBox(label: 'Código', value: 'IG-00028'),
                  _DetailBox(label: 'Periodicidad', value: 'Bimestral'),
                  _DetailBox(label: 'Duración', value: '6 horas'),
                  _DetailBox(label: 'Cuadrilla objetivo', value: '2 técnicos'),
                  _DetailBox(label: 'Cuota', value: '\$18,500 / bimestre'),
                  _DetailBox(label: 'Familias técnicas', value: 'Refrigeración + A/A'),
                ],
              ),
              SizedBox(height: 24),
              
              // Callout
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1), // blue50ish
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Text(
                      'Consistencia verificada',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'La tienda pertenece al cliente, zona y vigencia del contrato. La iguala cubre únicamente esta entidad.',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.mutedTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Divider(height: 1, color: context.borderColor),
              ),
              
              // Tags
              Text(
                'Estados de la zona',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.textColor,
                ),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _TagPill('Jalisco · 21'),
                  _TagPill('Nayarit · 7'),
                  _TagPill('Colima · 6'),
                  _TagPill('Michoacán · 11'),
                  _TagPill('Aguascalientes · 7'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailBox extends StatelessWidget {
  final String label;
  final String value;

  const _DetailBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, // Approximate width to force wrap like CSS grid with auto-fit
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: context.mutedTextColor,
            ),
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  final String text;

  const _TagPill(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.textColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: context.textColor,
        ),
      ),
    );
  }
}
