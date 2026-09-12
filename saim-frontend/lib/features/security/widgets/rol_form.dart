import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/saim_button.dart';
import '../models/rol.dart';
import '../providers/roles_provider.dart';

class RolForm extends ConsumerStatefulWidget {
  final Rol? rol;

  const RolForm({super.key, this.rol});

  @override
  ConsumerState<RolForm> createState() => _RolFormState();
}

class _RolFormState extends ConsumerState<RolForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codigoController;
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _codigoController = TextEditingController(text: widget.rol?.codigo ?? '');
    _nombreController = TextEditingController(text: widget.rol?.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.rol?.descripcion ?? '');
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final notifier = ref.read(seguridadRolesProvider.notifier);

      final newRol = Rol(
        idRol: widget.rol?.idRol,
        codigo: _codigoController.text.trim().toUpperCase(),
        nombre: _nombreController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        activo: widget.rol?.activo ?? true,
      );

      if (widget.rol == null) {
        await notifier.addRol(newRol);
      } else {
        await notifier.updateRol(newRol);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.rol == null 
              ? 'Rol creado con éxito' 
              : 'Rol actualizado con éxito'
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
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.rol == null ? 'Agregar Rol' : 'Editar Rol',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _codigoController,
                label: 'Código*',
                hintText: 'Ej. TECNICO',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'El código es requerido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _nombreController,
                label: 'Nombre*',
                hintText: 'Ej. Técnico en campo',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'El nombre es requerido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descripcionController,
                label: 'Descripción*',
                hintText: 'Breve descripción del rol',
                maxLines: 2,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'La descripción es requerida';
                  return null;
                },
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
