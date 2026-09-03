## 1. Base de Datos (Migración y Esquema)

- [x] 1.1 Crear script de migración SQL para crear la nueva tabla `zona` (catálogo maestro).
- [x] 1.2 Añadir en el script la copia de datos desde `zona_contrato` a `zona` (usando `DISTINCT ON (codigo)`).
- [x] 1.3 Añadir en el script el renombrado/alteración de `zona_contrato` para que funcione como tabla puente, añadiendo FK `id_zona` y eliminando campos redundantes (codigo, nombre, descripcion).
- [x] 1.4 Modificar la tabla `zona_tienda` para que su FK apunte directamente a `id_zona` en lugar de `id_zona_contrato`.
- [x] 1.5 Ejecutar la migración en la base de datos de desarrollo y asegurar que la data migró correctamente.

## 2. Backend (FastAPI)

- [x] 2.1 (N/A, managed directly via Supabase on frontend) Actualizar los modelos Pydantic (schemas) de `ZonaContrato` para reflejar que ahora es una tabla puente o que depende de `zona`.
- [x] 2.2 Crear el CRUD completo de Zonas (`/zonas`): GET, POST, PUT, DELETE en un nuevo archivo o dentro del router de catálogos.
- [x] 2.3 Refactorizar el endpoint de creación de contratos (`actualizar_contrato_completo` RPC o el endpoint de FastAPI) para que al guardar el paso 3 asigne zonas existentes en lugar de crearlas.
- [x] 2.4 (N/A, managed directly via Supabase on frontend) Refactorizar el endpoint de `/zona_tienda` para que consulte por `id_zona` y asocie usando la nueva estructura.

## 3. Frontend (Flutter UI) - Catálogo de Zonas

- [x] 3.1 Crear el provider/repositorio Riverpod para gestionar el CRUD del catálogo de Zonas (consultar `/zonas`).
- [x] 3.2 (Impl in modal) Crear la pantalla `ZonasScreen` que liste las zonas registradas (semejante a otros catálogos).
- [x] 3.3 Crear el modal de edición/creación `CrudZonasModal` y enlazarlo a la pantalla.
- [x] 3.4 Añadir "Zonas" en el menú lateral o dropdown de Inicio -> Catálogos.

## 4. Frontend (Flutter UI) - Wizard de Contrato

- [x] 4.1 Modificar el Paso 3 del Contrato (`CrudContratosModal`): Eliminar los TextFields de creación (código, nombre, descripción).
- [x] 4.2 Reemplazar con un selector múltiple o un flujo de "Agregar Zona" que consuma el provider de catálogo de Zonas (`ZonasProvider`).
- [x] 4.3 Actualizar la construcción del DTO final `ContratoCreate` para que mande únicamente la lista de IDs de zona y no todo el objeto anidado.

## 5. Frontend (Flutter UI) - Zona Tienda

- [x] 5.1 En el modal de "Zona Tienda", cambiar el helper provider que alimenta el dropdown de zonas para que traiga la lista directa del catálogo maestro de Zonas.
- [x] 5.2 Validar que el dropdown muestre nombres únicos y correctos, y envíe el `id_zona` al backend.
