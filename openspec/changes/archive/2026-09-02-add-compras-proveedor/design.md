## Context

La tabla `proveedor` ya existe en Supabase con los tipos y longitudes correctas, mapeando sus `BIGINT` a enteros en Dart. El proyecto utiliza Riverpod para manejo de estado, basándose en la clase abstracta `SupabaseCrudNotifier` introducida recientemente, y una interfaz de usuario estandarizada mediante `ModalDataTable` para listar registros y modales como `Crud[Entidad]Modal` para la edición.

## Goals / Non-Goals

**Goals:**
- Extender el ecosistema de CRUDs existentes al dominio de Compras (Proveedores).
- Reutilizar `SupabaseCrudNotifier` y la UI unificada para minimizar boilerplate.
- Manejar de forma segura el casting de números `BIGINT` de Supabase a Dart.

**Non-Goals:**
- Modificar el esquema de la base de datos (ya está completo y alineado con el diccionario).
- Implementar transacciones o joins complejos, dado que el catálogo de proveedores es de nivel raíz y no tiene llaves foráneas a otras tablas maestras aparte de los metadatos de auditoría (usuario creador/actualizador).

## Decisions

1. **Uso de `(json['campo'] as num).toInt()` en el Modelo**
   - **Racional**: En Flutter Web, Supabase retorna enteros (BIGINT/INT) como `double` dentro de los JSON. Usar un casteo estricto `as int` provoca assertions silenciosas. Se estandariza el casteo a numérico previo.
2. **Ubicación en el Sidebar**
   - **Racional**: Se creará una nueva sección padre llamada "Compras" en el menú, distinta a "Catálogos", para darle un sentido semántico modular acorde a un ERP, y ahí alojar "Proveedor".
3. **Tipo de Proveedor en Formulario**
   - **Racional**: Dado que `tipo_proveedor` es un `VARCHAR(40)`, usaremos un DropdownButtonFormField estandarizado si los tipos son fijos (ej. SERVICIOS, REFACCIONES), o un TextFormField si es texto libre. Por simplicidad inicial (al no tener tabla de catálogo de tipos de proveedor), se usará un `TextFormField` con validación de obligatoriedad, salvo que el usuario confirme si los valores deben estar restringidos.

## Risks / Trade-offs

- **[Risk] Cascada de borrados accidentales** → Se mitigará implementando exclusivamente *Borrado Lógico* actualizando la columna `activo = false` mediante el método `deleteItem` / `toggleStatus` ya existente en `SupabaseCrudNotifier`, protegiendo la integridad referencial.
