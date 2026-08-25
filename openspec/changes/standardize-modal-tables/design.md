## Context

Las tablas (`DataTable`) contenidas dentro de modales en `saim-frontend` se desbordan horizontalmente. Aunque están envueltas en un `SingleChildScrollView`, Flutter en web y escritorio oculta el scrollbar por defecto y deshabilita el arrastre con el cursor, impidiendo al usuario ver el contenido cortado. 

## Goals / Non-Goals

**Goals:**
- Proveer una experiencia de usuario fluida e intuitiva para desplazar contenido de tablas muy anchas.
- Habilitar el desplazamiento nativo similar a dispositivos táctiles (drag-to-scroll).
- Estandarizar la envoltura de `DataTable` en todos los modales existentes.

**Non-Goals:**
- No se rediseñarán las tablas en sí (columnas, datos o estilo).
- No se migrará a `PaginatedDataTable` en este momento.

## Decisions

**1. Habilitar drag-to-scroll globalmente en `main.dart`**
- **Rationale**: Flutter 2.5+ deshabilitó por defecto el scroll de arrastre con mouse. Al crear un `AppScrollBehavior` que incluye `PointerDeviceKind.mouse` y `trackpad`, restauramos la capacidad intuitiva de hacer clic y arrastrar en cualquier componente deslizable de la app web (no solo las tablas, también listas y modales largos).
- **Alternatives considered**: Habilitarlo por tabla (repetitivo) o no habilitarlo y depender solo de un scrollbar (menos fluido).

**2. Crear el wrapper `ModalDataTable`**
- **Rationale**: Un `Scrollbar` horizontal necesita un `ScrollController` atado a un `SingleChildScrollView` horizontal. En lugar de copiar y pegar este bloque de 10-15 líneas en cada uno de los 29 modales de CRUD, un solo widget estandariza esto y permite controlar propiedades del scrollbar globalmente si fuese necesario.
- **Alternatives considered**: Intentar forzar un `ScrollbarThemeData` en el tema global; descartado porque en Flutter Web el scrollbar horizontal no se muestra automáticamente en `SingleChildScrollView` a menos que se envuelva explícitamente en el widget `Scrollbar`.

## Risks / Trade-offs

- **Risk**: Posibles conflictos de scroll si un modal tiene una estructura anidada muy compleja donde el scroll vertical de la página interfiere con el scroll horizontal de la tabla.
  - **Mitigation**: El widget `ModalDataTable` solo controla el eje horizontal (envolviendo el `DataTable`). El eje vertical seguirá siendo manejado por el modal padre, lo que evita el "scroll trap" bidireccional.
