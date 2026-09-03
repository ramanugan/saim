## RENAMED Requirements

FROM:
### Requirement: Importación de zonas existentes
TO:
### Requirement: Selección de zonas de cobertura

## MODIFIED Requirements

### Requirement: Selección de zonas de cobertura
El sistema SHALL permitir al usuario en el paso "Zonas" del asistente de contratos, seleccionar zonas del catálogo maestro para asignarlas como zonas de cobertura del contrato actual.

#### Scenario: Selección de zona de cobertura
- **WHEN** el usuario hace clic en "Agregar Zona" y selecciona una zona del catálogo maestro
- **THEN** el contrato se vincula a la zona existente, sin duplicar ni crear un nuevo registro de zona independiente.

#### Scenario: Ausencia de zonas en el catálogo
- **WHEN** el usuario intenta agregar una zona y el catálogo maestro está vacío
- **THEN** el sistema indica que no hay zonas registradas y provee un enlace o mensaje indicando que deben crearse primero en el catálogo maestro.
