## Purpose

Permite la creación, lectura y actualización del catálogo de roles funcionales del sistema SAIM.

## ADDED Requirements

### Requirement: CRUD de Roles
El sistema SHALL proveer una interfaz para el catálogo de roles.

#### Scenario: Listado Activo
- **WHEN** el administrador entra al catálogo de roles
- **THEN** el sistema lista los roles donde `activo` = true.

#### Scenario: Creación de rol
- **WHEN** el usuario agrega un rol proporcionando un código, nombre y descripción
- **THEN** el rol se persiste en la base de datos con las marcas de auditoría y `activo` = true por defecto.
