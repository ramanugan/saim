## Why

En la plataforma SAIM, las tablas dentro de modales (principalmente en flujos CRUD) sufren de problemas de usabilidad en dispositivos de escritorio y web: cuando el contenido excede el ancho del modal, no se muestra una barra de desplazamiento horizontal ni se permite el "drag-to-scroll" con el mouse de forma predeterminada. Esto provoca que el contenido del lado derecho quede invisible o inaccesible para los usuarios.

## What Changes

- Habilitar el comportamiento de arrastrar para desplazar (`drag-to-scroll`) para el mouse y trackpad a nivel global en la aplicación.
- Crear un nuevo componente estándar `ModalDataTable` que envuelva nativamente los `DataTable` con un `Scrollbar` horizontal siempre visible.
- Reemplazar el uso directo de `DataTable` por el nuevo `ModalDataTable` en todos los modales de la carpeta `lib/features/catalogs/widgets/modals`.

## Capabilities

### New Capabilities
- `ui/modal-data-table`: Comportamiento estándar de desplazamiento y visualización para tablas contenidas dentro de modales.

### Modified Capabilities

## Impact

- **Frontend (`saim-frontend`)**: Modificación del archivo `main.dart` para inyectar el nuevo comportamiento global de scroll.
- **Frontend Widgets**: Creación de `lib/shared/widgets/modal_data_table.dart`.
- **Modales CRUD**: Reemplazo de sintaxis en aproximadamente 29 archivos dentro de `lib/features/catalogs/widgets/modals/`. No afecta la lógica de negocio ni las llamadas a Supabase.
