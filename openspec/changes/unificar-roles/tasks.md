## 1. Migración SQL (Base de Datos)

- [x] 1.1 Crear script de migración SQL para insertar registros vigentes de `roles` a la tabla `rol`.
- [x] 1.2 Añadir al script la migración de cuentas de `user_profiles` a la tabla `usuario` (vinculando con el auth.uid real).
- [x] 1.3 Añadir al script la migración de la relación de usuarios y roles hacia la tabla `usuario_rol`.
- [x] 1.4 Modificar o crear la tabla transicional para permisos (`rol_permiso`) y migrar los registros de `role_permissions`.
- [x] 1.5 Ejecutar y probar el script SQL transaccional en Supabase local.

## 2. Refactorización del Frontend

- [x] 2.1 Actualizar la consulta de perfil en `lib/core/providers/auth_provider.dart` para obtener datos desde `usuario` uniendo `usuario_rol` y `rol` en lugar de `user_profiles`.
- [x] 2.2 Adaptar `UserProfile` o reemplazar su uso por `Usuario` dentro del proveedor de autenticación.
- [x] 2.3 Modificar `RoleGuard` (`lib/shared/widgets/role_guard.dart`) para extraer el nombre del rol del nuevo arreglo de roles del usuario.
- [x] 2.4 Modificar `PermissionsMatrix` (`lib/features/security/widgets/permissions_matrix.dart`) y `permissions_provider.dart` para escribir/leer sobre `rol_permiso` o la estructura adoptada.

## 3. Limpieza y Verificación

- [x] 3.1 Limpiar advertencias/errores en el Frontend (correr `flutter analyze`).
- [x] 3.2 Verificar que el inicio de sesión siga funcionando y el redireccionamiento por roles se cumpla.
- [x] 3.3 Generar script `drop_legacy_security_tables.sql` que elimine las tablas viejas (`roles`, `user_profiles`, `role_permissions`). (Este script se ejecutará manualmente por el usuario tras verificar).
