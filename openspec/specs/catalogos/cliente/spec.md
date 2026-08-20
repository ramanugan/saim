# Cliente Specification

## Purpose
Permite a los administradores gestionar el catálogo de clientes dentro de la plataforma SAIM.

## Requirements

### Requirement: CRUD de Cliente
El sistema MUST permitir la creación, lectura, actualización y eliminación lógica de clientes a través de un modal.

#### Scenario: Cliente creado exitosamente
- **WHEN** un usuario administrador llena el modal de cliente con datos válidos (código, razón social, rfc) y presiona guardar
- **THEN** el sistema inserta el registro en la tabla `cliente` y actualiza la lista en pantalla.
