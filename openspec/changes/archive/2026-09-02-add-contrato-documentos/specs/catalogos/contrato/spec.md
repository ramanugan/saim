## MODIFIED Requirements

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
