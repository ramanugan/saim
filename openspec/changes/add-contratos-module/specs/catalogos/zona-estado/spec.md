## Purpose

Permite gestionar la cobertura de estados (zona_estado) dentro de una zona de contrato.

## ADDED Requirements

### Requirement: CRUD de Zona Estado
El sistema MUST permitir la creación, lectura, actualización y eliminación de los registros de zona de estado desde un modal.

#### Scenario: Zona Estado asignada
- **WHEN** un usuario asigna un estado a una zona de contrato
- **THEN** se registra en la base de datos que dicho estado pertenece a esa zona contractual.
