## Why

Actualmente, las zonas (`zona_contrato`) se crean de manera duplicada como hijas directas de cada versión de contrato. Esto provoca que en las asignaciones de tiendas a zonas (Catálogo "Zona Tienda") el selector de zonas muestre elementos duplicados ("CENTRO_OCCIDENTE" repetido múltiples veces). 
Esta arquitectura dificulta la mantenibilidad, ya que las zonas en la realidad existen de forma independiente a los contratos. Se requiere extraer el concepto de "Zona" a un catálogo maestro (independiente), para que las tiendas pertenezcan a las zonas de forma unívoca, y los contratos simplemente se vinculen a las zonas existentes que van a cubrir.

## What Changes

- **BREAKING**: Extraer la entidad `zona_contrato` hacia un catálogo maestro llamado `zona`.
- **BREAKING**: Migrar la tabla `zona_tienda` para que referencie al nuevo catálogo `zona` (`id_zona`) en lugar de referenciar a `zona_contrato`.
- Crear una nueva tabla relacional (ej. `contrato_version_zona`) para vincular una versión de contrato con múltiples zonas (donde a su vez vivirán el SLA y el Alcance de esa cobertura).
- Añadir el nuevo CRUD del catálogo "Zonas" en la UI (menú `Inicio -> Catálogos -> Zonas`).
- Modificar el Paso 3 del asistente de Contratos en la UI para que, en lugar de crear nuevas zonas, permita seleccionar de las zonas existentes (usando multiselect o añadiendo desde catálogo).
- Modificar la vista de "Zona Tienda" para que el selector de zona lea desde el nuevo catálogo `zona`, eliminando la duplicidad.
- Proveer un script de migración SQL que cree las nuevas tablas, migre los datos de `zona_contrato` a `zona` (haciendo un `DISTINCT` por código de zona) y actualice las referencias FK.

## Capabilities

### New Capabilities
- `catalogos/zona`: CRUD para el catálogo maestro de Zonas, el cual será el punto único de registro y edición para cada zona geográfica (código, nombre, descripción, coordinador_responsable).

### Modified Capabilities
- `catalogos/contrato`: El requerimiento "Importación de zonas existentes" se transforma a "Selección de zonas de cobertura". Ya no se importan datos para crear una nueva fila, sino que se enlaza el contrato a zonas del catálogo maestro.
- `catalogos/zona-tienda`: El requerimiento de vinculación cambiará para indicar que la asignación de la tienda se hace directamente sobre el catálogo maestro de Zonas (garantizando unicidad en el selector).

## Impact

- **Base de Datos**: 
  - Nueva tabla `zona`.
  - Nueva tabla puente `contrato_cobertura_zona` (que hereda SLA y Alcance).
  - Modificación estructural de `zona_tienda` (cambio de FK `id_zona_contrato` a `id_zona`).
- **Backend (FastAPI)**: 
  - Nuevos endpoints para CRUD `/zonas`.
  - Refactor del endpoint de creación/actualización de contratos (`/contratos`) para usar la tabla puente y no crear zonas on-the-fly.
- **Frontend (Flutter)**:
  - Nueva pantalla de catálogo `ZonasScreen` y modal `CrudZonasModal`.
  - Refactor de `CrudContratosModal` (Paso 3 "Zonas") para seleccionar en lugar de crear.
  - Refactor de `CrudZonaTiendaModal` para cargar la lista desde `/zonas` y enviar `id_zona`.
