## Why

Se requiere implementar la sección "Contratos" en la aplicación para gestionar la relación contractual con los clientes, tiendas, SLA's, versiones y documentos operativos. El proceso es complejo y requiere inserciones atómicas, por lo que demanda un diseño específico (como un formulario *Wizard* con validación final conectada a un procedimiento almacenado en PostgreSQL).

## What Changes

- **Nuevos menús**: Se agrega el submenú `Contratos` en `Catálogos`, con las opciones de: Cliente, Tienda, Contrato, Zona Estado y Zona Tienda.
- **Nuevos modales de CRUD simples**:
  - `CrudClientesModal`: Para la tabla `cliente`.
  - `CrudTiendasModal`: Para la tabla `tienda`.
  - `CrudZonaEstadoModal`: Para la tabla `zona_estado`.
  - `CrudZonaTiendaModal`: Para la tabla `zona_tienda`.
- **Nuevo modal Stepper para Contrato**: Un wizard multi-pasos para registrar atómicamente la jerarquía completa (`contrato`, `contrato_version`, `zona_contrato`, `contrato_alcance`, `contrato_sla`, `contrato_documento`).
- **Función RPC en Supabase**: Un Stored Procedure `crear_contrato_completo(payload JSON)` que procesa la inserción de las 6 tablas bajo una misma transacción de base de datos.
- **Providers Riverpod**: Proveedores correspondientes para la consulta, almacenamiento e hidratación de listados.

## Capabilities

### New Capabilities
- `catalogos/cliente`: Catálogo para administrar Clientes.
- `catalogos/tienda`: Catálogo para administrar Tiendas.
- `catalogos/contrato`: Gestión transaccional de contratos con múltiples etapas (Versiones, SLA, Zonas, Alcance y Documentos).
- `catalogos/zona-estado`: Gestión de exclusiones/asignaciones por estado (Zona Estado).
- `catalogos/zona-tienda`: Gestión de asignaciones por tienda (Zona Tienda).

### Modified Capabilities

- Ninguna

## Impact

- Modificación de la barra de navegación lateral `app_drawer.dart`.
- Nuevos scripts SQL que se añadirán a la base de datos `saim-supabase`.
- Nuevos repositorios y providers que ampliarán la capa de estado de Riverpod.
