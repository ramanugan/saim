## Why

Actualmente los usuarios deben capturar las zonas geográficas manualmente para cada contrato nuevo. Dado que muchas zonas se repiten (ej. "Centro Occidente"), existe la necesidad de "reutilizar" o importar zonas que ya fueron dadas de alta en otros contratos para agilizar la captura y evitar errores tipográficos, manteniendo la integridad de que cada zona pertenece a una versión específica de contrato.

## What Changes

- Se añadirá un botón de "Importar Existente" en el paso 3 ("Zonas") del asistente de contratos.
- Se implementará un diálogo modal que listará las zonas únicas previamente registradas en el sistema.
- Se agregará un *helper provider* en Riverpod para obtener la lista de zonas únicas, cumpliendo con la regla de diseño reactivo (sin llamadas aisladas con `FutureProvider`).
- Al seleccionar una zona del diálogo, se añadirá automáticamente a la lista de zonas del contrato actual.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `catalogos/contrato`: Se modifica el requerimiento de creación de zonas para permitir la importación de zonas existentes como mecanismo de auto-completado.

## Impact

- **Frontend**: `crud_contratos_modal.dart` (UI del paso 3) y `zonas_contrato_provider.dart` (nuevo helper provider).
- **Backend/DB**: Ninguno. Las zonas seguirán guardándose de forma independiente para cada versión de contrato, copiando los valores seleccionados en el frontend.
