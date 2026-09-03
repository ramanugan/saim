## Context

Actualmente `zona_contrato` se utiliza para guardar el registro de las zonas asignadas a una versión específica de contrato. Cuando una zona se asigna a múltiples contratos o versiones, se crean registros duplicados (con diferente ID pero mismo código/nombre). Esto causa problemas en las UI relacionadas, como el catálogo de "Zona Tienda", donde los nombres se duplican y dificultan la vinculación. Ver proposal.md para detalles.

## Goals / Non-Goals

**Goals:**
- Normalizar la base de datos creando un catálogo independiente de `zona`.
- Evitar redundancia de datos (nombres y códigos de zona duplicados).
- Refactorizar las APIs y UI para seleccionar zonas en lugar de crearlas dentro del wizard de contratos.

**Non-Goals:**
- No se modificará la estructura de `contrato_alcance` o `contrato_sla` más allá de actualizar su llave foránea.

## Decisions

**Decisión 1: Estructura de BD para el Catálogo de Zonas**
- Se creará una tabla `zona` pura, sin dependencia a ningún contrato.
- Las tablas `contrato_alcance` y `contrato_sla` actualmente referencian a `id_zona_contrato`. En lugar de refactorizarlas para que referencien `id_zona` Y `id_contrato_version` por separado, renombraremos y adaptaremos la tabla actual `zona_contrato` para que actúe únicamente como **tabla puente** entre `contrato_version` y `zona`. 
- Es decir, `zona_contrato` perderá sus columnas `codigo`, `nombre`, `descripcion` (que se mueven a `zona`), y añadirá una llave foránea `id_zona`.
*Rationale*: Esto minimiza el impacto en las tablas dependientes (`contrato_alcance` y `contrato_sla`), ya que seguirán referenciando el registro que representa "esta zona en este contrato".

**Decisión 2: Migración de Datos**
- Se creará un script SQL para poblar la nueva tabla `zona` haciendo un `SELECT DISTINCT ON (codigo)` desde la tabla actual `zona_contrato`.
- Después se actualizarán los registros de `zona_contrato` para que apunten al nuevo `id_zona` generado.
*Rationale*: Preserva la información existente en producción sin pérdida de datos.

## Risks / Trade-offs

- **Risk:** Romper los queries existentes que asumían que `zona_contrato` contenía el `codigo` y `nombre`.
  **Mitigation:** Auditar todos los endpoints del backend que utilicen `zona_contrato` y hacer un JOIN con la nueva tabla `zona` para devolver la información plana como lo espera el frontend en las lecturas, o actualizar los modelos Pydantic.

- **Risk:** Interrupción del Wizard de Contratos en Flutter si se envía un JSON incompatible.
  **Mitigation:** El DTO de Flutter para enviar el contrato completo (`ContratoCreate`) se adaptará para que en el array de `zonas` solo envíe una lista de IDs de zona (o la estructura mínima necesaria) en lugar de los datos completos.
