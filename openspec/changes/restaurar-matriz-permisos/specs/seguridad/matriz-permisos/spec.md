## Purpose

Gestionar y visualizar de forma centralizada los permisos de acceso (ver, crear, editar, eliminar) a los diferentes módulos del sistema, enlazados a roles específicos.

## ADDED Requirements

### Requirement: Acceso a la Matriz de Permisos
El sistema SHALL permitir a los usuarios administradores acceder a la vista de Matriz de Permisos a través del menú lateral "Seguridad".

#### Scenario: Navegación exitosa
- **WHEN** un administrador hace clic en "Permisos de Roles" dentro de "Seguridad"
- **THEN** se renderiza la pantalla de Matriz de Permisos (`RolePermissionsScreen`)

### Requirement: Selección de Rol
El sistema SHALL permitir seleccionar un rol existente para visualizar y modificar sus permisos.

#### Scenario: Cambio de rol seleccionado
- **WHEN** el usuario selecciona un rol del menú desplegable
- **THEN** la pantalla actualiza la lista de permisos para reflejar los del rol seleccionado

### Requirement: Gestión de Permisos por Módulo
El sistema SHALL mostrar los permisos agrupados por módulos (Contratos, Cobranza, etc.) y permitir activarlos o desactivarlos individualmente.

#### Scenario: Modificar un permiso
- **WHEN** el usuario hace toggle en el switch de un permiso (ej. "ver" en módulo "Contratos")
- **THEN** el sistema guarda inmediatamente el cambio en la base de datos a través de la API
