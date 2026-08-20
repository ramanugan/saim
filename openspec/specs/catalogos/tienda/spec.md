# Tienda Specification

## Purpose
Permite a los administradores gestionar el catálogo de tiendas, asociadas a los clientes, dentro de la plataforma SAIM.

## Requirements

### Requirement: CRUD de Tienda
El sistema MUST permitir la creación, lectura, actualización y eliminación lógica de tiendas a través de un modal.

#### Scenario: Tienda creada exitosamente
- **WHEN** un usuario administrador llena el modal de tienda asociando a un cliente y presiona guardar
- **THEN** el sistema inserta el registro en la tabla `tienda` y actualiza la lista.
