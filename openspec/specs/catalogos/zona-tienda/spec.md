# Zona Tienda Specification

## Purpose
Permite gestionar la asignación de tiendas individuales (zona_tienda) a zonas contractuales.

## Requirements

### Requirement: CRUD de Zona Tienda
El sistema MUST permitir la creación, lectura, actualización y eliminación de los registros de asignación de tiendas a zonas geográficas (catálogo maestro) desde un modal, sin duplicar la zona geográfica.

#### Scenario: Tienda específica agregada a zona del catálogo maestro
- **WHEN** un usuario asigna una tienda específica a una zona del catálogo maestro
- **THEN** el sistema registra la tienda como perteneciente a dicha zona, lo cual automáticamente incluirá a la tienda en cualquier contrato que cubra esa misma zona.
