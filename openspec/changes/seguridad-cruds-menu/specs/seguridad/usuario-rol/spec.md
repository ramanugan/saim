## Purpose

Permite asociar roles específicos a los usuarios, estableciendo ámbitos restrictivos como zonas y clientes.

## ADDED Requirements

### Requirement: CRUD de Usuario-Rol
El sistema SHALL permitir asignar, editar y revocar roles a los usuarios registrados.

#### Scenario: Asignación global
- **WHEN** se asigna un rol sin definir ámbito (ni cliente, ni zona)
- **THEN** la fecha de inicio es requerida y el usuario adquiere acceso global a ese rol.

#### Scenario: Asignación restrictiva
- **WHEN** se define un ámbito_cliente o ámbito_zona
- **THEN** el usuario adquiere dicho rol de manera focalizada para los recursos indicados.
