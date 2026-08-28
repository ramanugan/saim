## 1. Modelo de Datos y Proveedor

- [x] 1.1 Crear el modelo `lib/features/catalogs/models/proveedor.dart` con su `fromJson` y `toJson`, asegurando el casteo `(json['col'] as num).toInt()` para los campos numéricos (como el PK y auditorías).
- [x] 1.2 Crear el notifier `lib/features/catalogs/providers/proveedores_provider.dart` que extienda `SupabaseCrudNotifier<Proveedor>`.

## 2. Interfaz de Usuario (Modal)

- [x] 2.1 Crear `lib/features/catalogs/widgets/modals/crud_proveedores_modal.dart`.
- [x] 2.2 Diseñar el formulario en el modal con campos para Razón Social (requerido), RFC, Contacto, Correo, Teléfono, Tipo Proveedor (requerido) y Estatus (requerido, default 'ACTIVO').
- [x] 2.3 Conectar los botones de "Guardar" y "Cancelar" del modal con el método correspondiente del `proveedores_provider`.

## 3. Interfaz de Usuario (Tabla y Pantalla)

- [x] 3.1 Crear `lib/features/catalogs/screens/proveedores_screen.dart` (Cubierto por Modal).
- [x] 3.2 Implementar la tabla usando `ModalDataTable` conectada a `proveedoresProvider`, configurando las columnas para los atributos clave.
- [x] 3.3 Conectar las acciones de tabla (Editar, Eliminar) llamando a `updateItem` y `deleteItem` / `toggleStatus`.

## 4. Navegación y Menú (Router y Sidebar)

- [x] 4.1 Añadir la ruta estática `/proveedores` en `lib/core/router/app_router.dart` apuntando a `ProveedoresScreen` (No aplica por uso de Modal).
- [x] 4.2 Actualizar el menú lateral (presumiblemente en `sidebar.dart` o donde aplique) para crear la categoría principal "Compras".
- [x] 4.3 Agregar la subcategoría "Proveedor" dentro de "Compras", dirigiendo a `/proveedores` (abriendo el modal).

## 5. Pruebas y Limpieza

- [x] 5.1 Ejecutar `flutter analyze` para verificar tipos y linting. (Completado).
- [x] 5.2 Correr la aplicación en Chrome local y probar el flujo completo: Listado, Creación de Proveedor, Edición, Cambio de Estatus (Activar/Desactivar). (Completado, pendiente validación final del usuario).
