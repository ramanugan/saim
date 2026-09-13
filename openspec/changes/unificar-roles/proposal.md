## Why

El sistema cuenta con una deuda técnica donde coexisten dos estructuras para la gestión de roles de usuario: las tablas heredadas (`roles`, `user_profiles`, `role_permissions`) y las nuevas tablas (`rol`, `usuario`, `usuario_rol`). Las nuevas pantallas administrativas ya apuntan a las tablas nuevas, pero la lógica de autenticación y protección de rutas sigue atada a las tablas antiguas, que además contienen los datos reales. Este cambio unifica todo el sistema bajo las nuevas tablas para poder eliminar la estructura obsoleta y tener una única fuente de verdad.

## What Changes

- Refactorización de la lógica de autenticación (`auth_provider.dart`) para consultar la tabla `usuario` y `usuario_rol` en lugar de `user_profiles` y `roles`.
- Adaptación de la protección de rutas (`RoleGuard`) para validar los permisos contra las nuevas entidades.
- Migración de datos SQL: traspaso de los roles vigentes desde `roles` hacia `rol`, y de la asignación de usuarios desde `user_profiles` a `usuario` y `usuario_rol`.
- Actualización de la Matriz de Permisos (`PermissionsMatrix`) para que escriba sobre una nueva estructura de permisos ligada a `rol` (por ejemplo, `rol_permisos` o adaptando la actual).
- **BREAKING**: Eliminación de las tablas `user_profiles` y `roles` una vez completada la migración.

## Capabilities

### Modified Capabilities
Ninguna. Este cambio es puramente arquitectónico y de refactorización de esquema de datos. No se alteran los requerimientos a nivel de usuario ni se añaden nuevas funcionalidades. Se ha agregado `skip_specs: true` al archivo `.openspec.yaml`.

## Impact

- **Supabase**: Esquema de base de datos (`public`), disparadores de creación de usuarios.
- **Frontend**: `auth_provider.dart`, `role_guard.dart`, `permissions_matrix.dart`, y modelos relacionados.
- Posible disrupción temporal del inicio de sesión durante la ejecución del script SQL de migración si hay sesiones activas.
