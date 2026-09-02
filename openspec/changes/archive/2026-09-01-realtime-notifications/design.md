## Context

Actualmente el estado de los datos tabulares se almacena en memoria (`StateNotifier<AsyncValue<List<T>>>`) dentro de `SupabaseCrudNotifier` tras hacer un `.select()` de una sola vez. Cuando ocurre un cambio en Supabase (desde otra sesión u origen externo), el cliente local se desincroniza. Ver `proposal.md` para motivación y detalles.

## Goals / Non-Goals

**Goals:**
- Suscribir automáticamente las vistas tabulares a los WebSockets (Realtime) de Supabase.
- Sincronizar el estado del cliente con la base de datos de manera transparente y eficiente.
- Minimizar refactorización en los providers hijo (Clientes, Contratos, Equipos, etc.).

**Non-Goals:**
- Implementar resolución de conflictos offline-first.
- Hacer streaming fila por fila; optaremos por el patrón de invalidación local y *re-fetch*.

## Decisions

### 1. Patrón Listen-then-Fetch vs Stream Provider puro
**Decisión**: Implementaremos un canal (Channel) que escuche cambios en PostgreSQL y que dispare un `fetch()` a la base de datos completa cuando ocurra un evento (Listen-then-Fetch).
- **Rationale**: Supabase `stream` y `channel` devuelven la fila plana modificada (sin las uniones/joins). Muchos catálogos (ej. Contratos) utilizan `select('*, contrato_version(*, ...)')`. Si tratamos de inyectar la fila recibida por WebSocket en el estado local, nos faltarán las relaciones complejas. Hacer `fetch()` garantiza que los datos y sus relaciones siempre sean consistentes.
- **Alternatives Considered**: Cambiar a un `StreamProvider` con vistas SQL. Se descartó por requerir crear Vistas PostgreSQL complejas para cada catálogo y lidiar con los permisos de Realtime en las Vistas.

### 2. Suscripción y Limpieza (Lifecycle)
**Decisión**: Se instanciará un `RealtimeChannel` en el constructor o inicio de `SupabaseCrudNotifier` escuchando eventos genéricos `PostgresChangeEvent.all`. Se llamará a `.unsubscribe()` dentro de `dispose()`.
- **Rationale**: Evita memory leaks y múltiples conexiones de WebSocket si los providers se montan y desmontan (usualmente si usan autoDispose o si se reconstruye el árbol).

## Risks / Trade-offs

- **[Riesgo de picos de lectura]** → Al usar el patrón Listen-then-Fetch, un cambio dispara una lectura completa de la tabla para todos los clientes conectados viendo esa tabla.
  - **Mitigación**: Los catálogos (clientes, contratos, equipos) rara vez cambian múltiples veces por segundo y el número de técnicos conectados no suele estresar los límites de concurrencia.
- **[Riesgo de condición de carrera local]** → Cuando un usuario hace una modificación local (`updateItem()`), su propia mutación disparará un evento Realtime que causará un `fetch()`, pudiendo sobreescribir momentáneamente su estado.
  - **Mitigación**: Se puede mantener el estado optimista (la UI actualiza rápido) y cuando el `fetch()` regrese, simplemente confirmará los datos sin saltos visuales fuertes.

## Migration Plan

1. Modificar Supabase para habilitar REPLICA IDENTITY (Realtime) en las tablas base.
2. Modificar `lib/core/providers/base_crud_notifier.dart` para suscribirse y desuscribirse del canal.
3. Probar en un catálogo con relaciones (Contratos) y en uno simple (Equipos).
