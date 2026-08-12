import 'package:flutter/material.dart';
import '../form/form_section_title.dart';
import '../form/custom_inputs.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class Section09Signature extends StatelessWidget {
  Section09Signature({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormSectionTitle(
            number: '09',
            title: 'Entrega y aceptación',
            subtitle: 'El puesto y la obligatoriedad dependen de la plantilla del cliente.',
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 800;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: isWide ? 1 : 0, child: _buildTechSignature(context, )),
                  if (isWide) SizedBox(width: 24) else SizedBox(height: 24),
                  Expanded(flex: isWide ? 2 : 0, child: _buildClientSignature(context, )),
                  if (isWide) SizedBox(width: 24) else SizedBox(height: 24),
                  Expanded(flex: isWide ? 1 : 0, child: _buildSealBox(context, )),
                ],
              );
            },
          ),
          SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: false,
                  onChanged: (v) {},
                  activeColor: AppColors.blue,
                  side: BorderSide(color: context.borderColor),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Confirmo que la información refleja el trabajo realizado y que la persona indicada aceptó el servicio.',
                  style: TextStyle(fontSize: 12, color: context.textColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTechSignature(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: context.borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Técnico responsable', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: context.textColor)),
          SizedBox(height: 24),
          Text('José Ramírez', style: TextStyle(fontSize: 16, color: AppColors.ink)),
          SizedBox(height: 8),
          Text('Firma registrada en perfil · 21 jul 14:05', style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
        ],
      ),
    );
  }

  Widget _buildClientSignature(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: context.borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Jefe de mantenimiento', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: context.textColor)),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: CustomTextField(label: 'Nombre', value: 'Carlos Hernández', isRequired: true)),
              SizedBox(width: 16),
              Expanded(child: CustomDropdown(label: 'Puesto', value: 'Jefe de mantenimiento', isRequired: true, items: ['Jefe de mantenimiento', 'Gerente de tienda'])),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: context.backgroundColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: context.borderColor, style: BorderStyle.solid),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Firma dentro del recuadro', style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.blue,
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('Limpiar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSealBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: context.borderColor),
        borderRadius: BorderRadius.circular(6),
        color: context.backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Sello / evidencia equivalente', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: context.textColor)),
          SizedBox(height: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.blue.withOpacity(0.3), width: 2),
            ),
            alignment: Alignment.center,
            child: Text('SELLO\nTIENDA', textAlign: TextAlign.center, style: TextStyle(color: AppColors.blue, fontSize: 10, fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: true,
                  onChanged: (v) {},
                  activeColor: AppColors.blue,
                ),
              ),
              SizedBox(width: 8),
              Text('Se obtuvo sello', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
