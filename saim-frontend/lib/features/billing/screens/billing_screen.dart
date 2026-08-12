import 'package:flutter/material.dart';
import '../../../shared/layouts/app_layout.dart';
import '../../../shared/widgets/page_heading.dart';
import '../../../shared/widgets/saim_button.dart';
import '../widgets/cobranza_summary.dart';
import '../widgets/embudo_cobro_panel.dart';
import '../widgets/documentos_faltantes_list.dart';
import '../widgets/cuenta_por_cobrar_table.dart';
import '../widgets/aplicacion_pago_panel.dart';
import '../widgets/acciones_cobranza_list.dart';

class BillingScreen extends StatelessWidget {
  BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Facturación y cobranza',
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeading(
                eyebrow: 'Recuperación de ingresos',
                title: 'Facturación y cobranza',
                subtitle: 'Trabajos terminados, expediente, pedido, factura, saldo y pago.',
                actions: Row(
                  children: [
                    SaimButton(
                      text: '⇩ Estado de cuenta',
                      onPressed: () => _showDialog(context, 'Estado de cuenta'),
                      type: SaimButtonType.secondary,
                    ),
                    SizedBox(width: 12),
                    SaimButton(
                      text: '＋ Registrar pago',
                      onPressed: () => _showDialog(context, 'Registrar pago'),
                      type: SaimButtonType.primary,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              CobranzaSummary(),
              SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: EmbudoCobroPanel(),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: DocumentosFaltantesList(),
                  ),
                ],
              ),
              SizedBox(height: 24),
              CuentaPorCobrarTable(),
              SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: AplicacionPagoPanel(),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: AccionesCobranzaList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('En construcción'),
        content: Text('Acción: \$action'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cerrar')),
        ],
      ),
    );
  }
}
