## Why

Durante la separación de la antigua pantalla "Usuarios y roles" en los nuevos CRUDs individuales de Seguridad (Usuarios, Roles, Organización Proveedora), la sub-pantalla de "Matriz de Permisos por Rol" fue omitida accidentalmente de la interfaz. Esta funcionalidad es crítica para gestionar los niveles de acceso de los distintos roles a las secciones del sistema, por lo que debe ser reintroducida.

## What Changes

- Se reincorporará el componente `PermissionsMatrix` (o equivalente) como una pantalla dedicada e independiente llamada "Permisos de Roles" (`RolePermissionsScreen`).
- Se añadirá una nueva opción al submenú lateral de "Seguridad" para acceder a esta nueva pantalla, ubicada después de "Organización Proveedora".
- No se alterará el funcionamiento actual de los CRUDs creados recientemente, manteniendo la arquitectura modular (Opción A).

## Capabilities

### New Capabilities
- `seguridad/matriz-permisos`: Capacidad para asignar, visualizar y revocar permisos específicos (ver, crear, editar, eliminar) de diferentes módulos del sistema, enlazados a un rol de usuario seleccionado.

## Impact

- Modificación menor en `AppDrawer` para incluir la nueva ruta.
- Modificación menor en `AppRouter` para registrar y proteger la nueva ruta bajo `/admin/permisos`.
- Creación de la pantalla `RolePermissionsScreen` integrando la lógica y el componente existente de asignación de permisos que solía vivir en `UsersAdminScreen`.
