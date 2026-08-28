## Why

Actualmente, los 30 providers de catálogos en el frontend implementan operaciones CRUD hacia Supabase de forma manual y repetitiva. Esto genera código duplicado (más de 1,500 líneas redundantes) y provoca que errores sutiles (como enviar una llave primaria de tipo `GENERATED ALWAYS AS IDENTITY` en el payload de actualización) deban parcharse archivo por archivo. Este cambio introducirá una abstracción genérica (`SupabaseCrudRepository` o `BaseCrudNotifier`) para centralizar las operaciones de base de datos, garantizando la seguridad en los payloads y mejorando la mantenibilidad futura.

## What Changes

- **Abstracción Base**: Creación de una clase base (ej. `SupabaseCrudNotifier<T>`) o repositorio que encapsule `insert`, `update`, `delete`, `toggleStatus` y `fetch`.
- **Refactorización de Providers**: Migrar los ~30 providers actuales (`clientes_provider`, `tiendas_provider`, etc.) para que extiendan o utilicen esta clase base en lugar de reimplementar la lógica HTTP/Supabase.
- **Limpieza de Payloads**: La clase base garantizará automáticamente la eliminación de la llave primaria en las operaciones `UPDATE`, resolviendo definitivamente el error de `GENERATED ALWAYS AS IDENTITY`.

## Capabilities

### New Capabilities
*(Ninguna - Es un refactor puramente arquitectónico, sin cambios de comportamiento)*

### Modified Capabilities
*(Ninguna - Se ha activado `skip_specs: true` en `.openspec.yaml` para saltar la fase de especificaciones)*

## Impact

- **Código Afectado**: Todos los archivos dentro de `lib/features/catalogs/providers/`.
- **Dependencias**: Se estandarizará el uso del cliente de Supabase (inyectado a la clase base).
- **Sistemas**: Impacta la comunicación con Supabase desde el frontend, pero la API consumida sigue siendo el REST nativo de PostgREST proporcionado por Supabase.
