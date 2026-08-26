## 1. Backend: Modelos y Endpoints de Tipo Equipo

- [x] 1.1 Crear modelos Pydantic para `TipoEquipo` en `app/schemas/tipo_equipo.py`.
- [x] 1.2 Implementar endpoints CRUD para `TipoEquipo` en `app/api/endpoints/tipo_equipo.py`.
- [x] 1.3 Registrar el router de `tipo_equipo` en `app/api/router.py`.

## 2. Backend: Modelos y Endpoints de Equipo

- [x] 2.1 Crear modelos Pydantic para `Equipo` en `app/schemas/equipo.py`.
- [x] 2.2 Implementar endpoints CRUD para `Equipo` en `app/api/endpoints/equipo.py`, incluyendo las consultas relacionales para nombre de tienda y tipo de equipo en el endpoint GET.
- [x] 2.3 Registrar el router de `equipo` en `app/api/router.py`.

## 3. Frontend: Configuración y Providers

- [x] 3.1 Crear modelos Dart `TipoEquipo` y `Equipo` (`fromJson`, `toJson`).
- [x] 3.2 Crear `TipoEquipoProvider` (StateNotifier) y endpoints HTTP en `lib/features/catalogs/providers`.
- [x] 3.3 Crear `EquipoProvider` (StateNotifier) y endpoints HTTP en `lib/features/catalogs/providers`.
- [x] 3.4 Actualizar el menú de navegación (drawer) añadiendo el grupo "Equipamiento" y las dos nuevas rutas.
- [x] 3.5 Registrar las rutas en `app_router.dart`. (N/A: se implementaron como modales)

## 4. Frontend: Interfaces de Usuario (Modales CRUD)

- [x] 4.1 Crear `CrudTiposEquipoModal` en `lib/features/catalogs/widgets/modals/crud_tipos_equipo_modal.dart` implementando `ModalDataTable`. y el diseño estándar.
- [x] 4.2 Implementar `CrudEquiposModal` utilizando `ModalDataTable` y agrupando los múltiples campos en un formulario multi-columna amigable.
- [x] 4.3 (Opcional si no existen) Crear los helpers `helperTiendasProvider` y `helperTiposEquipoProvider` como pre-requisito para llenar los dropdowns del formulario de equipo.
