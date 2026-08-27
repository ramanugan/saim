# tipo-equipo Specification

## Purpose
Gestión del catálogo de Tipos de Equipo para clasificar el equipamiento de las tiendas.

## Requirements

### Requirement: Listado de Tipos de Equipo
El sistema SHALL permitir consultar la lista completa de tipos de equipo activos e inactivos.

#### Scenario: Visualización del catálogo
- **WHEN** el usuario accede al CRUD de Tipo Equipo
- **THEN** visualiza una tabla con las columnas: Código, Nombre, Descripción y Estatus

### Requirement: Registro y Modificación
El sistema SHALL permitir la creación de nuevos tipos de equipo y la edición de los existentes, garantizando que el código sea único.

#### Scenario: Creación exitosa
- **WHEN** el usuario guarda un nuevo tipo con un código que no existe
- **THEN** el registro se guarda correctamente y aparece en el catálogo

### Requirement: Cambio de estado (Activación/Desactivación)
El sistema SHALL permitir alternar el estatus operativo del tipo de equipo de activo a inactivo y viceversa.

#### Scenario: Desactivación de tipo
- **WHEN** el usuario desactiva un tipo de equipo
- **THEN** este cambia su estado a inactivo en la base de datos
