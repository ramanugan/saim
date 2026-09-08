## Context

`ModalDataTable` es un widget compartido (`lib/shared/widgets/modal_data_table.dart`) usado por los 33 modales CRUD. Actualmente recibe un `DataTable` pre-construido y solo añade scroll horizontal. No existe paginación ni búsqueda. Ver proposal.md para la motivación completa.

## Goals / Non-Goals

**Goals:**
- Implementar paginación client-side y búsqueda en el widget compartido `ModalDataTable`.
- Minimizar cambios en los 33 modales CRUD existentes — el cambio en cada uno debe ser mecánico.
- Mantener la reactividad Riverpod al 100%.

**Non-Goals:**
- Paginación server-side (los volúmenes actuales no lo justifican).
- Rediseño visual de los modales CRUD (solo se agrega el paginador y buscador).
- Agregar funcionalidades de ordenamiento por columna (posible mejora futura).

## Decisions

### D1: Evolucionar `ModalDataTable` en vez de crear un widget nuevo

**Decisión**: Cambiar la API del widget existente.

**Alternativa**: Crear un `PaginatedModalDataTable` nuevo y migrar gradualmente.

**Razón**: El widget actual es trivial (35 líneas). Crear uno nuevo dejaría dos widgets para el mismo propósito. Mejor evolucionar el único punto de entrada, lo cual fuerza que todos los modales se actualicen en batch — evitando inconsistencia.

### D2: API basada en `columns` + `rows` + `searchableValues` separados

**Decisión**: `ModalDataTable` recibe `List<DataColumn> columns`, `List<DataRow> rows`, y `List<String> searchableValues` como parámetros individuales.

**Alternativa A**: Seguir recibiendo `DataTable` y extraer rows internamente — imposible porque `DataTable` no expone sus rows como lista pública.

**Alternativa B**: Recibir datos raw (modelos) + builder function — demasiado invasivo, requiere cambiar la lógica de cada modal.

**Razón**: Separar columns/rows es el mínimo cambio necesario. `searchableValues` es una lista paralela de strings que permite buscar sin necesidad de introspeccionar los widgets dentro de cada `DataCell`.

### D3: Estado interno del widget (no Riverpod)

**Decisión**: La página actual (`_currentPage`) y el query de búsqueda (`_searchQuery`) son estado local del widget (`StatefulWidget`), no providers.

**Razón**: Son estado de UI efímero que solo existe mientras el modal está abierto. Al cerrar y reabrir el modal, siempre empieza en página 1 sin filtro — que es el comportamiento deseado. Crear providers para esto sería sobreingeniería.

### D4: Paginación siempre visible

**Decisión**: Los controles de paginación se muestran siempre, incluso con ≤10 registros.

**Razón**: Decisión explícita del usuario. Proporciona consistencia visual y permite detectar que la funcionalidad existe aunque la tabla tenga pocos registros.

### D5: `didUpdateWidget` para mantener reactividad

**Decisión**: Cuando Riverpod actualiza los datos y el widget padre se reconstruye con nuevas listas de `rows`/`searchableValues`, `ModalDataTable.didUpdateWidget` debe validar que `_currentPage` siga siendo válida. Si no lo es (e.g., se eliminó el último registro de la página actual), retroceder a la última página válida.

**Razón**: Garantiza que la tabla nunca muestre una página vacía tras una mutación reactiva.

## Risks / Trade-offs

- **[Cambio masivo en 33 archivos]** → El cambio es mecánico (desestructurar `DataTable` en params separados + agregar `searchableValues`). Bajo riesgo de error lógico. Se mitiga verificando con `flutter analyze`.
- **[searchableValues debe mantenerse en sync con rows]** → Si un modal pasa N rows pero M searchableValues (con N ≠ M), la búsqueda fallará silenciosamente. Se mitiga con un `assert(rows.length == searchableValues.length)` en el constructor.
