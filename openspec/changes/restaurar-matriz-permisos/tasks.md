## 1. Creación de la Pantalla

- [x] 1.1 Crear el archivo `lib/features/security/screens/role_permissions_screen.dart`.
- [x] 1.2 Mover o importar el componente `PermissionsMatrix` (desde `users_admin/widgets/` a `security/widgets/`).
- [x] 1.3 Refactorizar las dependencias y providers en `PermissionsMatrix` para asegurar compatibilidad con la nueva estructura (usar `seguridadRolesProvider` en lugar del antiguo `rolProvider` si es necesario).

## 2. Enrutamiento y Menú

- [x] 2.1 Actualizar `lib/core/router/app_router.dart` para incluir la ruta `/admin/permisos` protegida con el `RoleGuard`.
- [x] 2.2 Actualizar `lib/shared/layouts/app_drawer.dart` para agregar la opción "Permisos de Rol" en la sección de Seguridad.

## 3. Pruebas y Limpieza

- [x] 3.1 Verificar que el dropdown de roles cargue correctamente los roles (`Administrador` y `Tecnico`).
- [x] 3.2 Probar un cambio en los toggle switches de la matriz (ver, eliminar, editar, crear) y comprobar la persistencia.
- [x] 3.3 Eliminar archivos redundantes de `lib/features/users_admin` si ya no son necesarios (opcional).
