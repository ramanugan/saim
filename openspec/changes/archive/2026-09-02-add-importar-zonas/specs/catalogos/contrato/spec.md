## ADDED Requirements

### Requirement: Importación de zonas existentes
El sistema SHALL permitir al usuario en el paso "Zonas" del asistente de contratos, seleccionar zonas previamente registradas en el sistema para agregarlas a la lista de zonas del contrato actual, autocompletando su código, nombre y descripción.

#### Scenario: Selección de zona existente
- **WHEN** el usuario hace clic en "Importar Existente" y selecciona una zona de la lista
- **THEN** la información de la zona seleccionada se carga como una nueva tarjeta apilada en el contrato actual y se cierra el diálogo.

#### Scenario: Ausencia de zonas previas
- **WHEN** el usuario hace clic en "Importar Existente" y no hay zonas registradas en el sistema
- **THEN** el diálogo muestra un mensaje indicando que no hay zonas previas registradas.
