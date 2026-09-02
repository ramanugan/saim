## Context
El sistema SAIM pasará de registrar rutas de archivos en texto plano a gestionar la subida real de archivos al proveedor de almacenamiento (Supabase Storage). Ver `proposal.md` para la motivación.

## Goals / Non-Goals

**Goals:**
- Subir archivos asíncronamente desde el frontend en el paso 5 del CRUD de Contratos.
- Procesar los archivos en el servidor FastAPI para calcular el hash SHA-256 de manera segura.
- Almacenar los archivos en un bucket dedicado de Supabase Storage.
- Retornar al frontend la ruta del storage y el hash calculado, integrando esto al payload final del contrato.
- Permitir la descarga del archivo en modo edición preservando el nombre de archivo ingresado.

**Non-Goals:**
- Migración de datos existentes (los documentos anteriores creados con rutas manuales no serán validados ni subidos, la nueva funcionalidad aplicará a los nuevos documentos cargados).
- Pre-visualización de documentos dentro de la interfaz (sólo se permitirá la descarga).

## Decisions

1. **Uso de Supabase Storage:**
   - *Rationale:* Dado que SAIM ya utiliza Supabase (y el backend usa la librería `supabase-py`), es el paso lógico. Evita problemas de volúmenes docker efímeros en FastAPI.
   - *Alternative:* Filesystem local en FastAPI (descartado porque requiere alterar volúmenes en `docker-compose.yml` y es menos escalable).

2. **Cálculo de Hash en el Servidor (FastAPI):**
   - *Rationale:* Enviar el archivo a un nuevo endpoint `POST /api/v1/contratos/documentos/upload` mediante `multipart/form-data` centraliza la lógica de carga, calcula el hash en memoria/tmp y luego sube al bucket, todo en un solo movimiento desde la perspectiva del cliente, devolviendo un payload limpio `{ "ruta": "...", "hash": "..." }`.

3. **Bucket Privado:**
   - *Rationale:* Los contratos contienen información sensible. El bucket `contratos-documentos` debe ser privado. El endpoint de descarga será `GET /api/v1/contratos/documentos/download` que generará un signed URL desde Supabase y retornará el archivo, o directamente se devolverá el archivo pipeado por el servidor para forzar el nombre de descarga.

## Risks / Trade-offs

- **[Risk]** Carga de archivos muy grandes que excedan el límite en memoria de FastAPI o el body size permitido.
  - *Mitigation:* Limitar el tamaño de carga en FastAPI (ej. 10MB) y usar chunks o `SpooledTemporaryFile`.
- **[Risk]** Archivos "basura" en el bucket (documentos subidos pero cuyo contrato nunca se guardó, al darle "Cancelar").
  - *Mitigation:* Se puede implementar un job de limpieza posteriormente (cron) o simplemente aceptar el overhead, ya que los archivos se subirán bajo un id único (ej. `temp/UUID_archivo.ext`) y al momento de guardar el contrato, no se requiere moverlos, solo vincular su ruta.

## Migration Plan

1. Ejecutar un script SQL (o vía Supabase UI si se hace manual) para crear el bucket `contratos-documentos`.
2. Actualizar el código del backend (`saim-backend`) con los nuevos endpoints y el cliente de storage.
3. Actualizar el código del frontend (`saim-frontend`) para usar `file_picker` en `crud_contratos_modal.dart`.
