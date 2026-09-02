## Purpose
Permite la subida, almacenamiento seguro (en Supabase Storage) y descarga de archivos de documentos anexos a los contratos, calculando automáticamente su integridad (Hash SHA-256).

## ADDED Requirements

### Requirement: Subida y procesamiento de documentos
El sistema SHALL permitir la carga de un archivo para asociarlo como documento del contrato, almacenarlo en Supabase y retornar su ruta y hash SHA-256.

#### Scenario: Carga exitosa de documento
- **WHEN** el usuario selecciona un archivo en el paso "Documentos" del contrato
- **THEN** el archivo se sube asíncronamente al backend, se guarda en Supabase Storage, y se muestra automáticamente su ruta y hash SHA-256 en modo solo lectura.

### Requirement: Descarga de documentos existentes
El sistema SHALL permitir descargar el archivo asociado a un documento de contrato en modo edición.

#### Scenario: Descarga exitosa de un documento guardado
- **WHEN** el usuario hace clic en el botón de descarga de un documento existente
- **THEN** el sistema descarga el archivo asignándole el nombre especificado en el campo "Nombre Archivo".
