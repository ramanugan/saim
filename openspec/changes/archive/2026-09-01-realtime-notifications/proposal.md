## Why

Actualmente, el SAIM utiliza un enfoque estático (polling/fetching) para obtener los datos de la base de datos a través de `SupabaseCrudNotifier`. Si los datos son modificados externamente (por otros usuarios o directamente en la base de datos), la interfaz no se entera y se desincroniza, obligando al usuario a refrescar la aplicación manualmente. Habilitar notificaciones en tiempo real (Realtime) mediante Supabase y Riverpod resolverá este problema de raíz, asegurando que todos los catálogos y módulos reflejen la información correcta instantáneamente.

## What Changes

- Modificación de la clase base `SupabaseCrudNotifier` para utilizar los canales de Supabase Realtime (`.onPostgresChanges`).
- En lugar de manejar un estado local aislado tras operaciones CRUD, se dependerá de los eventos de la base de datos para sincronizar (hacer `fetch()`) automáticamente todos los clientes conectados.
- Habilitación de la funcionalidad Realtime a nivel de base de datos (PostgreSQL) para las tablas de todos los catálogos.
- **BREAKING**: Cualquier escritura a la base de datos ahora disparará eventos de actualización en todos los clientes suscritos. El tráfico de red incrementará ligeramente al descargar listas actualizadas de la base de datos tras cada evento.

## Capabilities

### New Capabilities
- `system/realtime-reactivity`: Requerimiento sistémico de sincronización en tiempo real para todos los módulos que listen y gestionen datos de catálogos y operaciones (basado en Supabase Realtime).

### Modified Capabilities

## Impact

- **Frontend (Flutter)**: Afecta a `lib/core/providers/base_crud_notifier.dart` y cualquier proveedor que herede de él. Todos los catálogos (Clientes, Contratos, Equipos, Zonas, etc.) se volverán reactivos instantáneamente sin modificar sus archivos individuales.
- **Backend/Base de Datos (Supabase)**: Se requiere correr scripts SQL para activar la replicación en tiempo real (REPLICA IDENTITY) en las tablas operativas.
