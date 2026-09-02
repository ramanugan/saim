## Context

See proposal.md for motivation. 
Actualmente las zonas se almacenan en la tabla `zona_contrato` asociadas directamente a una versión de contrato mediante `id_contrato_version`. Existen múltiples registros con el mismo código y nombre porque cada vez que se usa una zona en un contrato se crea un registro copia.

## Goals / Non-Goals

**Goals:**
- Obtener una lista única de zonas previamente registradas sin hacer consultas `FutureProvider` aisladas, respetando la regla del proyecto de que los "Dropdown/Helper Providers" escuchen a un `StateNotifierProvider` base.
- Permitir la selección e importación ágil desde la UI del asistente.

**Non-Goals:**
- Normalizar la tabla `zona_contrato` a un catálogo independiente. Se mantendrá el esquema actual donde las zonas pertenecen a la versión del contrato.

## Decisions

**Decisión 1: Creación de `helperZonasContratoUnicasProvider`**
- **Rationale**: En lugar de hacer un query `SELECT DISTINCT` que rompe la regla de reactividad, crearemos un `Provider` que hace un `ref.watch(zonasContratoProvider)`. Cuando la data llega, itera y filtra los registros en el cliente usando un `Map` para garantizar unicidad por `codigo`.
- **Alternativa rechazada**: Crear una vista en Postgres. Rechazada porque agrega complejidad a la DB cuando la tabla `zona_contrato` es lo suficientemente pequeña por ahora como para agrupar en memoria en el cliente, y ya tenemos el provider que trae todas las zonas.

**Decisión 2: UI a través de un Modal Dialog (`showDialog`)**
- **Rationale**: En el paso "Zonas", en lugar de inyectar un dropdown gigantesco en cada zona nueva, se usa un diálogo emergente ("Importar Existente") que lista todas las zonas previas. Al seleccionar, se inserta prellenada en la pila del `Stepper`.

## Risks / Trade-offs

- **Risk:** Crecimiento excesivo de la lista en memoria si hay miles de zonas distintas.
  - **Mitigation:** Para los alcances actuales del sistema, el volumen es bajo. Si crece, se cambiará la arquitectura del `helper` o se limitará el listado.
