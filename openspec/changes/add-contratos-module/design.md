## Context

Se agregará un nuevo módulo de Contratos. Debido a que el proceso involucra múltiples entidades con relaciones de llave foránea (Contrato -> Versión -> Alcance/Zonas/Documentos/SLA), y Supabase PostgREST no soporta de forma nativa transacciones multipasos desde Flutter en peticiones aisladas, se requiere un enfoque de diseño particular para garantizar la integridad referencial.

## Goals / Non-Goals

**Goals:**
- Asegurar que la creación de un contrato (con todos sus detalles) sea transaccional.
- Proveer una experiencia de usuario dividida en pasos lógicos (Stepper) usando Flutter Riverpod para retener el estado en memoria.
- Implementar los CRUD sencillos de los catálogos satélites: Cliente, Tienda, Zona Estado, Zona Tienda.

**Non-Goals:**
- No se diseñará por ahora el flujo de edición profunda (updates masivos a versiones existentes), el enfoque inicial es la creación y visualización de la estructura.

## Decisions

**1. Transacciones en Base de Datos vía RPC:**
- *Alternativas consideradas*: Insertar tabla por tabla desde Flutter controlando los fallos localmente.
- *Decisión*: Se utilizará una función almacenada (Stored Procedure / RPC) en PostgreSQL llamada `crear_contrato_completo`. Flutter enviará todo el payload en formato JSONB.
- *Racional*: Es la única manera 100% robusta de asegurar un ROLLBACK completo si alguna llave foránea falla.

**2. Estado en Memoria (Riverpod):**
- *Alternativas consideradas*: Guardar datos parciales en una base de datos local SQLite (Drift) durante el proceso.
- *Decisión*: Usar un `StateNotifierProvider` que mantenga en memoria los datos de cada paso (Dart objects o Map) hasta que se envíe el JSONB.
- *Racional*: El asistente no es tan prolongado como para requerir guardado local asíncrono, y el Stepper form provee validación en cliente paso por paso.

## Risks / Trade-offs

- **[Risk]** Si el JSON enviado al RPC es mal formado o tiene llaves incorrectas, PostgreSQL retornará un error genérico difícil de parsear en el front-end.
  - *Mitigación*: Tipado estricto en Flutter usando Clases (`ContratoPayload`, `ContratoVersionPayload`, etc.) y sus métodos `toJson()` antes de hacer la petición RPC.
