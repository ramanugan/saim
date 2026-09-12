import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/saim_button.dart';
import '../providers/usuario_rol_provider.dart';
import '../providers/roles_provider.dart';
import '../providers/usuarios_provider.dart';
import '../models/usuario.dart';

class UsuarioRolForm extends ConsumerStatefulWidget {
  final Usuario usuario;

  const UsuarioRolForm({super.key, required this.usuario});

  @override
  ConsumerState<UsuarioRolForm> createState() => _UsuarioRolFormState();
}

class _UsuarioRolFormState extends ConsumerState<UsuarioRolForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int? _selectedRolId;
  
  // Para ámbito (simulados por ahora, en un sistema real vendrían de sus catálogos)
  int? _selectedClienteId;
  int? _selectedZonaId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(seguridadRolesProvider.notifier).fetchRoles();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRolId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar un rol'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final notifier = ref.read(usuarioRolProvider.notifier);

      await notifier.assignRol(
        widget.usuario.idUsuario!,
        _selectedRolId!,
        ambitoCliente: _selectedClienteId,
        ambitoZona: _selectedZonaId,
      );

      // Refrescar el usuario para que en la tabla principal se vea el cambio
      ref.read(seguridadUsuariosProvider.notifier).fetchUsuarios();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rol asignado con éxito'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
    final rolesState = ref.watch(seguridadRolesProvider);
    
    return Dialog(
      backgroundColor: context.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Asignar Rol a ${widget.usuario.nombreUsuario}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                ),
              ),
              const SizedBox(height: 24),
              
              rolesState.when(
                data: (roles) {
                  final activos = roles.where((r) => r.activo).toList();
                  return DropdownButtonFormField<int>(
                    value: _selectedRolId,
                    decoration: InputDecoration(
                      labelText: 'Rol*',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: context.backgroundColor,
                    ),
                    items: activos.map((r) => DropdownMenuItem(
                      value: r.idRol,
                      child: Text(r.nombre),
                    )).toList(),
                    onChanged: (val) => setState(() => _selectedRolId = val),
                    validator: (val) => val == null ? 'Requerido' : null,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error al cargar roles: $e'),
              ),
              
              const SizedBox(height: 16),
              Text(
                'Opcional: Ámbito (Cliente/Zona)',
                style: TextStyle(fontSize: 12, color: context.mutedTextColor),
              ),
              const SizedBox(height: 8),
              
              // TODO: Conectar a catálogos reales de Cliente y Zona. 
              // Por ahora son inputs de texto que parsean a int.
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'ID Cliente (Ámbito)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: context.backgroundColor,
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  setState(() => _selectedClienteId = int.tryParse(val));
                },
              ),
              
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'ID Zona (Ámbito)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: context.backgroundColor,
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  setState(() => _selectedZonaId = int.tryParse(val));
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
                    text: 'Asignar',
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
