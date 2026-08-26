## Purpose

Gestión completa de los Equipos físicos de las tiendas, incluyendo sus características operativas y ubicación.

## ADDED Requirements

### Requirement: Listado de Equipos con dependencias resueltas
El sistema SHALL mostrar los equipos físicos con los nombres legibles de su Tienda y su Tipo de Equipo correspondientes.

#### Scenario: Visualización del catálogo de equipos
- **WHEN** el usuario accede al CRUD de Equipos
- **THEN** visualiza la tabla que incluye el nombre de la Tienda y el nombre del Tipo de Equipo (no sus IDs internos).

### Requirement: Registro de características operativas
El sistema SHALL requerir obligatoriamente el ingreso del estado operativo y la criticidad al dar de alta un equipo.

#### Scenario: Creación de un equipo nuevo
- **WHEN** el usuario completa el formulario de Equipo incluyendo "Estado Operativo" y "Criticidad"
- **THEN** el equipo se registra correctamente en la base de datos

### Requirement: Cambio de estado (Activación/Desactivación)
El sistema SHALL permitir alternar el estatus lógico del equipo en el catálogo.

#### Scenario: Desactivación de equipo
- **WHEN** el usuario desactiva un equipo
- **THEN** este cambia su estado lógico (activo=false) conservando su estado operativo original.
