## 1. Migración de Base de Datos

- [x] 1.1 Crear un archivo SQL en `saim-supabase/migrations/` para insertar el nuevo bucket `contratos-documentos` en `storage.buckets` y configurar sus políticas de RLS.
- [x] 1.2 Ejecutar el script SQL en la base de datos local usando `psql` o el CLI de Supabase para inicializar el bucket.

## 2. Backend (FastAPI)

- [x] 2.1 En `saim-backend/app/api/endpoints/contrato.py` (o donde correspondan los endpoints de contratos), agregar el endpoint `POST /upload-documento`.
- [x] 2.2 Implementar en el endpoint la lógica para recibir el archivo, calcular su hash SHA-256 usando `hashlib`, subirlo a `contratos-documentos` usando `supabase-py`, y retornar un JSON con `ruta` y `hash`.
- [x] 2.3 Agregar el endpoint `GET /download-documento` que genere una URL firmada o descargue directamente el archivo desde Supabase usando la ruta proporcionada.

## 3. Frontend (Flutter UI)

- [x] 3.1 Agregar/actualizar la dependencia `file_picker` en el `pubspec.yaml` de `saim-frontend` si no está instalada.
- [x] 3.2 En `crud_contratos_modal.dart` (Paso 5: Documentos), reemplazar el `TextFormField` de "Ruta / URL" por un componente que lance el `FilePicker` al ser clickeado.
- [x] 3.3 Reemplazar el `TextFormField` de "Fecha Documento" por un Date Picker (usando `showDatePicker`).
- [x] 3.4 Configurar el `TextFormField` de "Hash SHA-256" para ser de solo lectura (`readOnly: true`).
- [x] 3.5 Implementar la función de subida en Flutter: al seleccionar el archivo, enviarlo mediante una petición HTTP POST `multipart/form-data` al nuevo endpoint `/upload-documento`.
- [x] 3.6 Actualizar el estado de la tarjeta del documento (Ruta y Hash) tras recibir la respuesta exitosa del backend.
- [x] 3.7 En modo edición (cuando el input "Ruta" ya tiene un valor de backend), mostrar un botón de "Descargar" que apunte al endpoint `GET /download-documento` forzando la descarga con el valor de "Nombre Archivo".
