## Why

Se requiere implementar el módulo de "Equipamiento" en la plataforma SAIM para permitir la gestión completa del ciclo de vida de los equipos físicos instalados en las tiendas de los clientes. La base de datos ya cuenta con las tablas `equipo` y `tipo_equipo` debidamente configuradas con la estructura correcta (incluyendo campos de auditoría, ubicación, y criticidad), por lo que ahora es necesario construir las capas de Backend y Frontend para exponer esta funcionalidad a los usuarios de manera integrada.

## What Changes

- **Backend (FastAPI)**:
  - Creación de modelos Pydantic (`Equipo`, `EquipoCreate`, `EquipoUpdate`, y lo equivalente para `TipoEquipo`).
  - Implementación de Endpoints CRUD completos para `/api/v1/equipos` y `/api/v1/tipos-equipo`.
  - Consultas avanzadas (JOINs) en el listado de equipos para retornar los nombres correspondientes de `Tienda` y `Tipo de Equipo`.
- **Frontend (Flutter)**:
  - Nueva opción en el menú lateral de navegación: "Equipamiento" con dos submenús ("Tipos de Equipo" y "Equipos").
  - Creación de Providers de Riverpod para gestionar el estado y la comunicación HTTP de ambos catálogos.
  - Implementación de Modales CRUD completos con el nuevo estándar de `ModalDataTable` para listar y editar registros de forma amigable, agrupando visualmente los numerosos campos de la tabla `equipo`.

## Capabilities

### New Capabilities
- `catalogos/tipo-equipo`: Gestión del catálogo de Tipos de Equipo.
- `catalogos/equipo`: Gestión completa de los Equipos físicos de las tiendas, incluyendo sus características operativas (ubicación interna, estado operativo, criticidad y números de serie).

### Modified Capabilities
- `<Ninguna>`

## Impact

- **Navegación UI**: Se añade un nuevo subárbol al layout principal del Frontend.
- **API Backend**: Se exponen 2 nuevos dominios (routers) RESTful.
- **Base de Datos**: Ninguno estructural (las tablas y validaciones `NOT NULL` ya fueron creadas exitosamente), pero habrá inserción de datos nuevos.
