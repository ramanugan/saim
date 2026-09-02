# Contrato Specification

## Purpose
Permite gestionar el ciclo de vida completo de los contratos a través de un asistente paso a paso, garantizando que todos los registros relacionados se guarden atómicamente.

## Requirements

### Requirement: Registro Atómico de Contrato
El sistema MUST asegurar que al finalizar el formulario multi-paso de contrato, la información de `contrato`, `contrato_version`, `zona_contrato`, `contrato_alcance`, `contrato_sla` y `contrato_documento` se inserte de manera atómica (todo o nada).

#### Scenario: Transacción fallida en el backend
- **WHEN** el payload de contrato se envía al servidor y hay un error de constraint en alguna de las sub-tablas
- **THEN** el sistema descarta toda la transacción (rollback) y no crea registros huérfanos.

#### Scenario: Registro de contrato exitoso
- **WHEN** el usuario completa todos los pasos del asistente con datos válidos y confirma
- **THEN** el sistema registra el contrato con todas sus jerarquías y notifica el éxito.

### Requirement: Importación de zonas existentes
El sistema SHALL permitir al usuario en el paso "Zonas" del asistente de contratos, seleccionar zonas previamente registradas en el sistema para agregarlas a la lista de zonas del contrato actual, autocompletando su código, nombre y descripción.

#### Scenario: Selección de zona existente
- **WHEN** el usuario hace clic en "Importar Existente" y selecciona una zona de la lista
- **THEN** la información de la zona seleccionada se carga como una nueva tarjeta apilada en el contrato actual y se cierra el diálogo.

#### Scenario: Ausencia de zonas previas
- **WHEN** el usuario hace clic en "Importar Existente" y no hay zonas registradas en el sistema
- **THEN** el diálogo muestra un mensaje indicando que no hay zonas previas registradas.
