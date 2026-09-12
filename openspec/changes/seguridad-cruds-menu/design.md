## Context

Actualmente los ítems de navegación están anidados directamente sin un contenedor lógico (como "Catálogos", "Seguridad").
En la creación de usuarios, dado que usamos Supabase Auth, una inserción directa a `auth.users` desde el frontend con la llave anónima no es viable sin cerrar la sesión actual, o arrojará errores de permisos.

## Goals / Non-Goals

**Goals:**
- Proporcionar las pantallas de CRUD para la base de datos de Seguridad del SAIM.
- Definir un nuevo componente de Drawer (menú lateral) más limpio.
- Proveer un mecanismo seguro en el backend/frontend para crear usuarios en Supabase sin perder sesión.

**Non-Goals:**
- Construir vistas para reportes o flujos complejos de facturación (está fuera de este módulo).

## Decisions

1. **Reestructuración del Menú Lateral**: 
   - Utilizaremos el componente `NavigationDrawer` (o una lista agrupada estándar de Material) en Riverpod para aislar la navegación en grupos (`Catálogos`, `Seguridad`).
2. **Creación de Usuarios en Supabase**:
   - En lugar de cerrar sesión o hacer `supabase.auth.signUp()`, para la creación de usuarios desde el dashboard de un administrador, usaremos una **Edge Function** o llamaremos a la API Supabase de Admin (`supabase.auth.admin.createUser`) configurando las variables correctas (requiere Service Role Key, que no debe exponerse a los usuarios normales). 
   - Alternativa elegida para SAIM Frontend seguro: Crear una Edge Function (Deno) en Supabase llamada `admin-create-user` que valide el JWT del admin y luego ejecute `supabase.auth.admin.createUser()`. El backend se encarga de todo.

## Risks / Trade-offs

- [Risk] Exponer la llave `service_role` en el frontend.
  - Mitigación: Nunca colocar esa llave en el frontend. Usar siempre un backend intermedio (Edge Function) autenticado.
- [Risk] Menú muy grande.
  - Mitigación: Usar un componente `ExpansionTile` para contraer los submenús por categoría.
