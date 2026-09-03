## Purpose
Permite administrar un catálogo maestro de Zonas geográficas independientes de los contratos, de modo que sirvan como punto único de registro para agrupar tiendas y otorgar cobertura contractual.

## ADDED Requirements

### Requirement: CRUD del Catálogo Zonas
El sistema SHALL permitir la creación, lectura, actualización y desactivación de zonas (código, nombre, descripción y coordinador responsable) en un catálogo maestro independiente.

#### Scenario: Creación de nueva zona
- **WHEN** un administrador registra una nueva zona con su código, nombre y coordinador
- **THEN** el sistema persiste la zona en el catálogo maestro y queda disponible para asignarle tiendas o contratos.

#### Scenario: Visualización del catálogo de zonas
- **WHEN** el usuario navega a la sección de Catálogos -> Zonas
- **THEN** el sistema muestra una lista paginada de todas las zonas registradas en el catálogo maestro.
