## Purpose

Permite gestionar la asignación de tiendas individuales (zona_tienda) a zonas contractuales.

## ADDED Requirements

### Requirement: CRUD de Zona Tienda
El sistema MUST permitir la creación, lectura, actualización y eliminación de los registros de zonas de tiendas desde un modal.

#### Scenario: Tienda específica agregada a zona
- **WHEN** un usuario asigna una tienda específica a una zona
- **THEN** el sistema registra la tienda como parte de la cobertura de dicha zona contractual.
