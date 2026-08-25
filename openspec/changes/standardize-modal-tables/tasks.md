## 1. Configuración Global

- [x] 1.1 Modificar `lib/main.dart` para inyectar un `AppScrollBehavior` en el `MaterialApp` que habilite `PointerDeviceKind.mouse` y `trackpad`.

## 2. Componente de UI

- [x] 2.1 Crear el archivo `lib/shared/widgets/modal_data_table.dart` que contenga el StatefulWidget `ModalDataTable`.
- [x] 2.2 Configurar dentro de `ModalDataTable` el `ScrollController` y el envoltorio `Scrollbar` horizontal junto con un `SingleChildScrollView`.

## 3. Integración en Modales

- [x] 3.1 Identificar todos los modales en `lib/features/catalogs/widgets/modals/` que utilicen `DataTable`.
- [x] 3.2 Reemplazar la sintaxis de envoltorio actual (`SingleChildScrollView` horizontal) por el nuevo componente `ModalDataTable`.
- [x] 3.3 Revisar la compilación y verificar el scroll manual de un modal (ej. `crud_clientes_modal.dart`).
