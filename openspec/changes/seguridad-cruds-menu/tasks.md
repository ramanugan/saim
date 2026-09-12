## 1. Backend Edge Functions (Supabase)

- [x] 1.1 Crear Deno Edge Function `admin-create-user` para registrar identidades seguras sin cerrar sesión.
- [x] 1.2 Implementar validación de JWT (asegurar que solo admins puedan invocar la función).

## 2. Refactor de Navegación (Frontend)

- [x] 2.1 Modificar `app_router.dart` para soportar las nuevas rutas de Seguridad.
- [x] 2.2 Refactorizar el menú lateral (`Drawer`) agrupando por categorías (Catálogos, Seguridad) usando `ExpansionTile` o listas seccionadas.

## 3. CRUD Organización Proveedora

- [x] 3.1 Implementar `OrganizacionProveedoraProvider` usando Riverpod para listar, crear, actualizar y borrar de manera lógica.
- [x] 3.2 Crear la pantalla `OrganizacionProveedoraScreen` con la tabla y buscador usando `AsyncValueWidget`.
- [x] 3.3 Crear el modal `OrganizacionProveedoraForm` para altas/ediciones. proveedoras.

## 4. CRUD de Roles

- [x] 4.1 Crear Data Model y repositorio (`roles_provider.dart`).
- [x] 4.2 Crear vista principal listando los roles activos.
- [x] 4.3 Crear modal/formulario para crear y editar roles.

## 5. CRUD de Usuarios

- [x] 5.1 Adaptar o reescribir `UsuarioProvider` para que liste datos desde la tabla unificada `public.usuario`.
- [x] 5.2 Adaptar o reescribir `UsuariosScreen` para usar la nueva tabla y poder invocar al edge function en la creación.
- [x] 5.3 Crear/adaptar modal `UsuarioForm` para recopilar datos de creación (email, password temporal, id_empleado, roles básicos).

## 6. CRUD de Usuario-Rol

- [x] 6.1 Crear Data Model y repositorio (`usuario_rol_provider.dart`).
- [x] 6.2 Crear vista principal (o tab dentro de la gestión de usuarios) para asignar roles.
- [x] 6.3 Crear selector reactivo de roles, clientes y zonas para el ámbito.
