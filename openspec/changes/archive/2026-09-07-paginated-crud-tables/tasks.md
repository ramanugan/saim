## 1. Widget Compartido

- [x] 1.1 Reescribir `ModalDataTable` en `lib/shared/widgets/modal_data_table.dart` con nueva API: `columns`, `rows`, `searchableValues`, `rowsPerPage` (default 10). Incluir estado interno `_currentPage`, `_searchQuery`, lógica de filtrado y paginación, campo de búsqueda, y controles de paginación. Agregar `assert(rows.length == searchableValues.length)`. Implementar `didUpdateWidget` para ajustar `_currentPage` si la lista de datos cambia reactivamente.

## 2. Migración de Modales CRUD — Básicos

- [x] 2.1 Migrar `crud_paises_modal.dart` a la nueva API de `ModalDataTable`
- [x] 2.2 Migrar `crud_estados_modal.dart`
- [x] 2.3 Migrar `crud_municipios_modal.dart`
- [x] 2.4 Migrar `crud_unidades_medida_modal.dart`
- [x] 2.5 Migrar `crud_tipos_tienda_modal.dart`
- [x] 2.6 Migrar `crud_tipos_servicio_modal.dart`
- [x] 2.7 Migrar `crud_tipos_equipo_modal.dart`

## 3. Migración de Modales CRUD — Cobertura

- [x] 3.1 Migrar `crud_clientes_modal.dart`
- [x] 3.2 Migrar `crud_contratos_modal.dart`
- [x] 3.3 Migrar `crud_zonas_modal.dart`
- [x] 3.4 Migrar `crud_zonas_estado_modal.dart`
- [x] 3.5 Migrar `crud_zonas_tienda_modal.dart`
- [x] 3.6 Migrar `crud_tiendas_modal.dart`

## 4. Migración de Modales CRUD — Equipos y Proveedores

- [x] 4.1 Migrar `crud_equipos_modal.dart`
- [x] 4.2 Migrar `crud_proveedores_modal.dart`
- [x] 4.3 Migrar `crud_almacenes_modal.dart`

## 5. Migración de Modales CRUD — Refacciones

- [x] 5.1 Migrar `crud_refacciones_modal.dart`
- [x] 5.2 Migrar `crud_categorias_refaccion_modal.dart`
- [x] 5.3 Migrar `crud_refacciones_alias_modal.dart`
- [x] 5.4 Migrar `crud_refacciones_compatibilidad_modal.dart`
- [x] 5.5 Migrar `crud_proveedor_refaccion_modal.dart`
- [x] 5.6 Migrar `crud_precio_refaccion_modal.dart`
- [x] 5.7 Migrar `crud_inventario_refacciones_modal.dart`
- [x] 5.8 Migrar `crud_movimientos_inventario_modal.dart`
- [x] 5.9 Migrar `crud_instalacion_refaccion_modal.dart`
- [x] 5.10 Migrar `crud_oportunidad_suministro_modal.dart`
- [x] 5.11 Migrar `crud_solicitud_refaccion_modal.dart`
- [x] 5.12 Migrar `crud_solicitud_refaccion_detalle_modal.dart`
- [x] 5.13 Migrar `crud_suministros_refaccion_modal.dart`
- [x] 5.14 Migrar `crud_suministros_refaccion_detalle_modal.dart`

## 6. Migración de Modales CRUD — Igualas

- [x] 6.1 Migrar `crud_igualas_modal.dart`
- [x] 6.2 Migrar `crud_iguala_servicios_modal.dart`
- [x] 6.3 Migrar `crud_iguala_condiciones_modal.dart`

## 7. Verificación

- [x] 7.1 Ejecutar `flutter analyze` y corregir cualquier error o advertencia
- [x] 7.2 Verificar visualmente paginación y búsqueda en el modal de Municipios (catálogo con más registros)
