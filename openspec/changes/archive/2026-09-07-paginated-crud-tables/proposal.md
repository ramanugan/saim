## Why

Los modales CRUD del SAIM muestran todos los registros en una lista sin cortar, lo que los hace poco usables conforme crece el catálogo (e.g., Municipios con ~50 registros ya desborda el viewport). No existe forma de buscar ni paginar dentro de la tabla, obligando al usuario a hacer scroll manual para localizar un registro.

## What Changes

- **Evolucionar `ModalDataTable`** para soportar paginación client-side (bloques de 10 registros) y un campo de búsqueda/filtro integrado, manteniendo la reactividad al 100% con Riverpod.
- **Cambiar la API de `ModalDataTable`**: en vez de recibir un `DataTable` pre-armado, recibirá `columns`, `rows` y `searchableValues` por separado, para que el widget controle internamente qué filas mostrar.
- **Migrar los 33 modales CRUD existentes** a la nueva API — cambio mecánico sin tocar lógica de negocio ni providers.

## Capabilities

### New Capabilities
_(ninguna — se extiende una capacidad existente)_

### Modified Capabilities
- `ui/modal-data-table`: Se agregan dos nuevos requerimientos — paginación client-side y búsqueda/filtro en línea — al widget compartido `ModalDataTable`.

## Impact

- **Frontend**: Todos los archivos `crud_*_modal.dart` (33 archivos en `lib/features/catalogs/widgets/modals/`) requieren un cambio mecánico de API.
- **Widget compartido**: `lib/shared/widgets/modal_data_table.dart` se reescribe con estado interno para página actual y query de búsqueda.
- **Backend / Providers**: Sin cambios. La paginación es 100% client-side.
- **Riesgo**: Bajo. El cambio en cada modal es mecánico (desestructurar `DataTable` → parámetros separados) y no altera lógica de negocio.
