## Context

La base de datos cuenta con dos tablas ya configuradas en Supabase: `tipo_equipo` y `equipo`. La tabla `equipo` contiene referencias a `tienda` y a `tipo_equipo`. El sistema actual de frontend está construido con Flutter Web, utilizando Riverpod para la gestión del estado, y los modales CRUD se basan en el componente `ModalDataTable`. El backend está construido en FastAPI.

## Goals / Non-Goals

**Goals:**
- Implementar los modelos Pydantic y endpoints de FastAPI que expongan las operaciones CRUD.
- En el endpoint de listar `equipos` (GET), incorporar la lógica necesaria (usando relaciones en SQLAlchemy o Supabase JOINs) para proveer los nombres de la tienda y el tipo de equipo en la respuesta, evitando que el frontend haga peticiones N+1.
- Construir los dos modales CRUD en Flutter (`CrudTipoEquipoModal` y `CrudEquipoModal`) y registrarlos en la ruta de navegación (AppRouter).
- En el modal de `equipo`, agrupar los múltiples campos del formulario (12 campos) utilizando un diseño en grid/columnas para que no requiera scroll excesivo.

**Non-Goals:**
- Modificar el esquema de la base de datos (ya fue consolidado).
- Implementar flujos complejos de mantenimiento preventivo sobre los equipos (esto se manejará en otro Change Proposal).

## Decisions

- **Join vs Múltiples Fetch (Backend)**: El endpoint `GET /api/v1/equipos` traerá internamente los datos relacionales (`tienda.nombre`, `tipo_equipo.nombre`).
  *Alternativa:* Que el frontend haga fetch a todos los catálogos y resuelva en memoria (como se hace en los proveedores de suministros).
  *Razón:* La tabla `equipo` puede crecer significativamente. Dejar que la DB o el backend resuelva las referencias (`JOIN`) reduce la carga en el cliente y facilita la paginación y búsqueda por texto (ej. buscar equipos de la tienda "Soriana").

- **Estructura del Formulario Frontend**: Se utilizarán filas (Rows) con `Expanded` (similar al diseño propuesto en el modo exploración) para colocar campos como "Marca" y "Modelo" uno al lado del otro.
  *Alternativa:* Un solo `Column` donde cada campo ocupe el 100% de la anchura.
  *Razón:* Un formulario de más de 10 campos a una sola columna abruma al usuario en resoluciones Desktop. Agrupar lógicamente los datos (Identificación, Detalles Técnicos, Operatividad) mejora la usabilidad.

## Risks / Trade-offs

- **Formulario muy grande** → Agrupación visual por secciones (Identificación, Detalles y Estado Operativo).
- **Carga de catálogos en el Frontend** → El formulario de alta/edición de Equipo necesitará descargar previamente los catálogos de "Tienda" y "Tipo de Equipo" para rellenar los Dropdowns. Se utilizarán Helper Providers (`helperTiendasProvider`, `helperTiposEquipoProvider`) con caché para evitar bloqueos en la UI.
