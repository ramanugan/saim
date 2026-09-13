## Context

Ver `proposal.md` para la motivación. Actualmente tenemos las tablas `roles` y `user_profiles` que se usan en la lógica de autenticación y autorización (vía Supabase y `auth_provider.dart`), así como la tabla `role_permissions` usada en la matriz de permisos. A su vez, se crearon nuevas tablas `rol`, `usuario` y `usuario_rol` para la gestión en la UI. Este cambio unifica ambas estructuras para usar solo las nuevas tablas en español.

## Goals / Non-Goals

**Goals:**
- Que el login (validación de cuentas activas) consulte `usuario`.
- Que el sistema de guardia de rutas (`RoleGuard`) consulte `usuario` y `usuario_rol`.
- Que la asignación de permisos `role_permissions` funcione mapeada a la tabla `rol` (o a una nueva tabla `rol_permiso`).
- Que los usuarios y roles existentes migren a las tablas nuevas mediante un script SQL transaccional.
- Que las tablas viejas `roles` y `user_profiles` puedan eliminarse de Supabase.

**Non-Goals:**
- No se agregará nueva funcionalidad ni nuevos roles o permisos.
- No se modificará la apariencia visual de las pantallas de UI (solo sus proveedores de estado y consultas).

## Decisions

1. **Tabla de Permisos**: Renombraremos lógicamente y modificaremos `role_permissions` para que su llave foránea apunte a la nueva tabla `rol` (`id_rol`). Así unificamos la matriz de permisos.
2. **Modelo de Usuario (`auth_provider.dart`)**: La consulta de sesión activa cambiará de `.from('user_profiles').select('*, roles(*)')` a `.from('usuario').select('*, usuario_rol(*, rol(*))')`. Validaremos `usuario.estado_cuenta == 'ACTIVA'` en lugar de `is_active`.
3. **Migración SQL**: Se escribirá un archivo `.sql` transaccional que insertará los roles vigentes en `rol`, los usuarios vigentes en `usuario`, y sus vínculos en `usuario_rol`.

## Risks / Trade-offs

- **[Risk]** Interrupción del servicio durante la migración de datos.
  - **Mitigación**: Ejecutar la migración dentro de una sola transacción SQL (`BEGIN; ... COMMIT;`) para asegurar atomicidad.
- **[Risk]** Desajustes con `auth.users`.
  - **Mitigación**: Las contraseñas y cuentas están protegidas en el esquema `auth` de Supabase. La tabla `usuario` en el esquema público sólo almacena metadatos; la llave principal foránea apuntará al `id` de `auth.users`.
