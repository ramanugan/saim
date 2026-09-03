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

#### Scenario: Documentos con archivos subidos previamente
- **WHEN** el usuario guarda un contrato que contiene documentos con archivos ya subidos asíncronamente
- **THEN** el contrato guarda las referencias (ruta y hash) obtenidas durante la subida, manteniendo la atomicidad del registro principal.

### Requirement: Selección de zonas de cobertura
El sistema SHALL permitir al usuario en el paso "Zonas" del asistente de contratos, seleccionar zonas del catálogo maestro para asignarlas como zonas de cobertura del contrato actual.

#### Scenario: Selección de zona de cobertura
- **WHEN** el usuario hace clic en "Agregar Zona" y selecciona una zona del catálogo maestro
- **THEN** el contrato se vincula a la zona existente, sin duplicar ni crear un nuevo registro de zona independiente.

#### Scenario: Ausencia de zonas en el catálogo
- **WHEN** el usuario intenta agregar una zona y el catálogo maestro está vacío
- **THEN** el sistema indica que no hay zonas registradas y provee un enlace o mensaje indicando que deben crearse primero en el catálogo maestro.
