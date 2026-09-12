import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/saim_button.dart';
import '../models/organizacion_proveedora.dart';
import '../providers/organizacion_proveedora_provider.dart';

class OrganizacionProveedoraForm extends ConsumerStatefulWidget {
  final OrganizacionProveedora? organizacion;

  const OrganizacionProveedoraForm({super.key, this.organizacion});

  @override
  ConsumerState<OrganizacionProveedoraForm> createState() => _OrganizacionProveedoraFormState();
}

class _OrganizacionProveedoraFormState extends ConsumerState<OrganizacionProveedoraForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _razonSocialController;
  late TextEditingController _nombreComercialController;
  late TextEditingController _rfcController;
  late TextEditingController _domicilioFiscalController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _razonSocialController = TextEditingController(text: widget.organizacion?.razonSocial ?? '');
    _nombreComercialController = TextEditingController(text: widget.organizacion?.nombreComercial ?? '');
    _rfcController = TextEditingController(text: widget.organizacion?.rfc ?? '');
    _domicilioFiscalController = TextEditingController(text: widget.organizacion?.domicilioFiscal ?? '');
  }

  @override
  void dispose() {
    _razonSocialController.dispose();
    _nombreComercialController.dispose();
    _rfcController.dispose();
    _domicilioFiscalController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final notifier = ref.read(organizacionProveedoraProvider.notifier);

      final newOrg = OrganizacionProveedora(
        idOrganizacion: widget.organizacion?.idOrganizacion,
        razonSocial: _razonSocialController.text.trim(),
        nombreComercial: _nombreComercialController.text.trim().isNotEmpty ? _nombreComercialController.text.trim() : null,
        rfc: _rfcController.text.trim(),
        domicilioFiscal: _domicilioFiscalController.text.trim().isNotEmpty ? _domicilioFiscalController.text.trim() : null,
        activo: widget.organizacion?.activo ?? true,
      );

      if (widget.organizacion == null) {
        await notifier.addOrganizacion(newOrg);
      } else {
        await notifier.updateOrganizacion(newOrg);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.organizacion == null 
              ? 'Organización creada con éxito' 
              : 'Organización actualizada con éxito'
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.organizacion == null ? 'Agregar Organización' : 'Editar Organización',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _razonSocialController,
                label: 'Razón Social*',
                hintText: 'Ej. Operadora de Hospitales S.A. de C.V.',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'La razón social es requerida';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nombreComercialController,
                label: 'Nombre Comercial',
                hintText: 'Ej. Hospitales Star',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _rfcController,
                label: 'RFC*',
                hintText: 'Ej. OHO123456ABC',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'El RFC es requerido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _domicilioFiscalController,
                label: 'Domicilio Fiscal',
                hintText: 'Calle, Colonia, C.P., Ciudad, Estado',
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: Text('Cancelar', style: TextStyle(color: context.mutedTextColor)),
                  ),
                  const SizedBox(width: 12),
                  SaimButton(
                    text: 'Guardar',
                    isLoading: _isLoading,
                    onPressed: _submit,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
