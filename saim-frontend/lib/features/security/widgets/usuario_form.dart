import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/saim_button.dart';
import '../models/usuario.dart';
import '../models/rol.dart';
import '../providers/usuarios_provider.dart';
import '../providers/roles_provider.dart';

class UsuarioForm extends ConsumerStatefulWidget {
  final Usuario? usuario;

  const UsuarioForm({super.key, this.usuario});

  @override
  ConsumerState<UsuarioForm> createState() => _UsuarioFormState();
}

class _UsuarioFormState extends ConsumerState<UsuarioForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _empleadoController;
  bool _isLoading = false;
  List<Rol> _availableRoles = [];
  Set<int> _selectedRoleIds = {};

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.usuario?.correo ?? '');
    _passwordController = TextEditingController();
    _empleadoController = TextEditingController(text: widget.usuario?.idEmpleado?.toString() ?? '');
    
    if (widget.usuario != null) {
      _selectedRoleIds = widget.usuario!.roles
          .where((r) => r.activo)
          .map((r) => r.idRol)
          .toSet();
    }
    
    Future.microtask(_loadRoles);
  }

  Future<void> _loadRoles() async {
    final notifier = ref.read(seguridadRolesProvider.notifier);
    await notifier.fetchRoles();
    final roles = ref.read(seguridadRolesProvider).value ?? [];
    if (mounted) {
      setState(() {
        _availableRoles = roles.where((r) => r.activo).toList();
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _empleadoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.usuario == null && _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña es obligatoria para nuevos usuarios'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final notifier = ref.read(seguridadUsuariosProvider.notifier);

      int? idEmpleado;
      if (_empleadoController.text.trim().isNotEmpty) {
        idEmpleado = int.tryParse(_empleadoController.text.trim());
      }

      if (widget.usuario == null) {
        // Creación
        final rolesToAssign = _selectedRoleIds.map((id) => {
          'id_rol': id,
        }).toList();

        await notifier.addUsuarioViaEdgeFunction(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          idEmpleado,
          rolesToAssign,
        );
      } else {
        // Actualización
        // NOTA: Para actualizar roles se requiere una lógica más compleja de sincronización en BD (borrar inactivos, insertar nuevos).
        // En esta iteración solo actualizamos el id_empleado.
        final updatedUsuario = widget.usuario!.copyWith(
          correo: _emailController.text.trim(), // No se cambia en Auth sin más pasos, pero lo reflejamos en BD.
          idEmpleado: idEmpleado,
        );
        await notifier.updateUsuario(updatedUsuario);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.usuario == null 
              ? 'Usuario creado con éxito' 
              : 'Usuario actualizado con éxito'
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.usuario == null ? 'Crear Usuario' : 'Editar Usuario',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _emailController,
                  label: 'Correo electrónico*',
                  hintText: 'Ej. nombre@empresa.com',
                  enabled: widget.usuario == null, // Solo se permite editar correo al crear
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'El correo es requerido';
                    if (!val.contains('@')) return 'Debe ser un correo válido';
                    return null;
                  },
                ),
                if (widget.usuario == null) ...[
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Contraseña Temporal*',
                    hintText: 'Mínimo 6 caracteres',
                    obscureText: true,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'La contraseña es requerida';
                      if (val.length < 6) return 'Debe tener al menos 6 caracteres';
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _empleadoController,
                  label: 'ID Empleado (Opcional)',
                  hintText: 'Ej. 1045',
                ),
                const SizedBox(height: 24),
                Text(
                  'Roles',
                  style: TextStyle(fontWeight: FontWeight.bold, color: context.textColor),
                ),
                const SizedBox(height: 8),
                if (_availableRoles.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableRoles.map((r) {
                      final isSelected = _selectedRoleIds.contains(r.idRol);
                      return FilterChip(
                        label: Text(r.nombre),
                        selected: isSelected,
                        onSelected: widget.usuario != null ? null : (selected) {
                          // TODO: Implementar actualización de roles para usuarios existentes en el backend
                          setState(() {
                            if (selected) {
                              _selectedRoleIds.add(r.idRol!);
                            } else {
                              _selectedRoleIds.remove(r.idRol);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                if (widget.usuario != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'La edición de roles no está disponible temporalmente.',
                      style: TextStyle(fontSize: 12, color: Colors.orange),
                    ),
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
      ),
    );
  }
}
