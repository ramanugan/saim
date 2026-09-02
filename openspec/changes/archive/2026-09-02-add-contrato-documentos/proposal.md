## Why

Actualmente, el registro de documentos anexos a un contrato requiere que el usuario introduzca manualmente una "Ruta / URL" y un "Hash SHA-256". Esto es propenso a errores y poco amigable. Se requiere permitir la carga directa de archivos desde la interfaz, almacenarlos de manera segura (en Supabase Storage, procesados por el backend) y extraer automáticamente tanto la ruta resultante como el Hash SHA-256, para mejorar la integridad y usabilidad del sistema.

## What Changes

- Reemplazar el input manual de texto "Ruta / URL" por un botón/zona para seleccionar y subir un archivo.
- Enviar el archivo asíncronamente al backend para que este lo suba a Supabase Storage y calcule su Hash SHA-256.
- Rellenar automáticamente los inputs de "Ruta" y "Hash SHA-256" (este último en modo solo lectura) tras procesar el archivo en el servidor.
- En modo edición, si el documento ya tiene un archivo asociado, mostrar un botón para descargar el archivo utilizando el nombre especificado en "Nombre Archivo".
- Reemplazar el input manual de texto de "Fecha Documento" por un Date Picker estándar.

## Capabilities

### New Capabilities

- `catalogos/contrato-documentos`: Capacidad para subir y descargar archivos de documentos de contratos procesados a través del servidor y almacenados en Supabase Storage.

### Modified Capabilities

- `catalogos/contrato`: Se modifica el comportamiento del paso 5 (Documentos) para requerir carga de archivos asíncrona en lugar de captura manual de URLs.

## Impact

- **Frontend (`saim-frontend`)**: Modificaciones en `crud_contratos_modal.dart` (Paso 5) para soportar file picker, subida asíncrona (endpoint nuevo), inputs de solo lectura y Date Picker.
- **Backend (`saim-backend`)**: Creación de nuevos endpoints en el router de contratos (`POST /upload`, `GET /download` o manejo de URLs firmadas) para procesar archivos, calcular hashes y comunicarse con Supabase Storage.
- **Base de datos / Infraestructura (`saim-supabase`)**: Creación de un nuevo bucket en Supabase Storage (ej. `contratos-documentos`) para almacenar físicamente los archivos.
