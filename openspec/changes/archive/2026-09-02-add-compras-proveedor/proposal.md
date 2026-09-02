## Why

Se requiere implementar el CRUD para el catálogo de Proveedores. Esto permite administrar de manera centralizada la información de los proveedores que suministran refacciones y servicios, facilitando la integración con los módulos de compras y suministros (que previamente requerían tener esta información disponible pero no tenían una interfaz para gestionarla). El DDL de la base de datos ya está correctamente configurado y validado.

## What Changes

- **Nuevo Módulo de Proveedores**: Interfaz principal tipo DataTable para visualizar, editar y eliminar lógicamente registros de proveedores.
- **Navegación y Menú Lateral**: Creación de un nuevo elemento raíz en el menú llamado "Compras", el cual contendrá como submenú al CRUD de "Proveedor".
- **Modal de Edición/Creación**: Formulario que incluye Razón Social, RFC, Contacto, Correo, Teléfono, Tipo Proveedor y Estatus.
- **Integración con SupabaseCrudNotifier**: Implementación del provider base que asegura operaciones CRUD estándar y consistentes con el resto de catálogos de la aplicación.

## Capabilities

### New Capabilities
- `catalogs/compras/proveedor`: Gestión del ciclo de vida (alta, edición, lectura y borrado lógico) de los registros de proveedores.

### Modified Capabilities
- Ninguna existente.

## Impact

- **UI/Menú**: El menú lateral principal tendrá una nueva sección `Compras -> Proveedor`.
- **Rutas**: Se agrega una ruta `/proveedores` en el `app_router.dart`.
- **Base de Datos**: Se interactuará directamente con la tabla `proveedor` en Supabase.
- **Frontend State**: Se añadirá el `proveedoresProvider` en Riverpod heredando la base abstracta `SupabaseCrudNotifier`.
