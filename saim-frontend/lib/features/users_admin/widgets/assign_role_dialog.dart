import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../providers/users_provider.dart';

class AssignRoleDialog extends ConsumerStatefulWidget {
  final UserProfile user;

  AssignRoleDialog({super.key, required this.user});

  @override
  ConsumerState<AssignRoleDialog> createState() => _AssignRoleDialogState();
}

class _AssignRoleDialogState extends ConsumerState<AssignRoleDialog> {
  int? _selectedRoleId;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedRoleId = widget.user.role?.id;
    _firstNameController = TextEditingController(text: widget.user.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.user.lastName ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _saveRole() async {
    if (_selectedRoleId == null) return;
    
    setState(() => _isSaving = true);
    try {
      await ref.read(usersAdminProvider).updateUserProfile(
        widget.user.id,
        _selectedRoleId,
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rol actualizado correctamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar rol: \$e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rolesAsync = ref.watch(rolesProvider);

    return AlertDialog(
      title: Text('Editar Perfil de Usuario'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Usuario: ${widget.user.fullName}', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('Nombre(s):'),
          SizedBox(height: 8),
          TextField(
            controller: _firstNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              hintText: 'Ej. Juan',
            ),
          ),
          SizedBox(height: 16),
          Text('Apellidos:'),
          SizedBox(height: 8),
          TextField(
            controller: _lastNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              hintText: 'Ej. Pérez',
            ),
          ),
          SizedBox(height: 16),
          Text('Rol del sistema:'),
          SizedBox(height: 8),
          rolesAsync.when(
            data: (roles) {
              return DropdownButtonFormField<int>(
                value: _selectedRoleId,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                hint: Text('Seleccionar rol'),
                isExpanded: true,
                items: roles.map((role) {
                  return DropdownMenuItem<int>(
                    value: role.id,
                    child: Text(role.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRoleId = value;
                  });
                },
              );
            },
            loading: () => CircularProgressIndicator(),
            error: (e, st) => Text('Error al cargar roles: \$e'),
          ),
        ],
      ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveRole,
          child: _isSaving
              ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : Text('Guardar'),
        ),
      ],
    );
  }
}
