## Context

La pantalla original de "Usuarios y roles" (`UsersAdminScreen`) incluía un `DefaultTabController` con dos vistas: una tabla de usuarios y un componente `PermissionsMatrix`. Durante la migración a CRUDs modulares en el menú lateral ("Seguridad" -> Usuarios, Roles, Org. Proveedora), el componente de la matriz de permisos fue omitido. Debemos restaurarlo usando la estructura modular actual.

## Goals / Non-Goals

**Goals:**
- Restaurar la funcionalidad completa del componente `PermissionsMatrix`.
- Exponer esta vista a través de una ruta dedicada (`/admin/permisos`) y agregarla al Drawer bajo "Seguridad".
- Reutilizar el código del componente existente de React/Flutter en `lib/features/users_admin/widgets/permissions_matrix.dart`.

**Non-Goals:**
- Modificar el esquema de la base de datos de los permisos (`modulo`, `permiso_rol`, etc.).
- Refactorizar las pantallas de CRUD ya completadas (`UsuariosScreen`, `RolesScreen`).

## Decisions

1. **Ruta y Navegación**: Se creará una nueva pantalla `RolePermissionsScreen` (ubicada en `lib/features/security/screens/role_permissions_screen.dart`). Se añadirá una opción "Permisos de Rol" en `AppDrawer` dentro del submenú "Seguridad". 
   - *Rationale*: Mantiene la separación de responsabilidades y es coherente con el nuevo patrón de 1 módulo = 1 pantalla.

2. **Reutilización de Código**: Se copiará o moverá el widget `PermissionsMatrix` y su lógica desde la carpeta obsoleta `features/users_admin/` a la nueva arquitectura en `features/security/widgets/`.
   - *Rationale*: Evita reescribir lógica compleja de Riverpod que ya funciona para gestionar la matriz bidimensional de roles y módulos.

## Risks / Trade-offs

- **Riesgo**: El código antiguo de `PermissionsMatrix` podría depender de providers antiguos que fueron borrados.
  - **Mitigación**: Revisaremos las dependencias (como `rolProvider` o `permisoRolProvider`) durante la implementación y los enlazaremos a los nuevos providers si es necesario.
