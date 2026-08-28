## Context
Actualmente, los `StateNotifier` de catálogos mezclan responsabilidades: gestionan el estado de Riverpod y construyen manualmente las peticiones a la API de Supabase (`insert`, `update`, `delete`, `toggleStatus`). Esto ha causado errores repetitivos, como olvidar eliminar la llave primaria del payload JSON antes de un `UPDATE`, ocasionando errores en PostgreSQL por columnas `GENERATED ALWAYS AS IDENTITY`.

## Goals / Non-Goals

**Goals:**
- Centralizar las peticiones CRUD de Supabase en una clase base (`SupabaseCrudNotifier`).
- Prevenir vulnerabilidades y errores de base de datos (e.g., eliminando automáticamente la PK en las actualizaciones).
- Mantener compatibilidad con la estructura actual de Riverpod (`AsyncValue<List<T>>`).

**Non-Goals:**
- No se migrarán providers que no sean CRUD estándar (ej. providers de autenticación o reportes complejos).
- No se agregará manejo avanzado de caché offline u optimizaciones de red fuera del alcance del CRUD.

## Decisions

### 1. `SupabaseCrudNotifier<T>` (Base Class)
**Decisión**: Crear una clase abstracta `SupabaseCrudNotifier<T> extends StateNotifier<AsyncValue<List<T>>>` que contenga los métodos estándar (`fetch`, `add`, `update`, `delete`, `toggleStatus`).
**Alternativa considerada**: Crear una clase `Repository` pura separada y que los Notifiers la llamen por composición. 
**Rationale**: Ya que la app está fuertemente acoplada a `StateNotifier`, utilizar herencia reduce dramáticamente el boilerplate, permitiendo que un provider de catálogo necesite sólo ~15 líneas en lugar de las 100 actuales.

### 2. Configuración por Entidad
Para que la clase base funcione genéricamente, requerirá:
- `tableName`: El nombre de la tabla (ej. `'cliente'`).
- `primaryKey`: El nombre de la columna llave (ej. `'id_cliente'`).
- `fromJson`: Un constructor de fábrica `(Map<String, dynamic> json) => T`.
- `toJson`: Un método `(T item) => Map<String, dynamic>`.
- `getId`: Un método para extraer el ID genérico `(T item) => item.id`.

### 3. Saneamiento de Payload Automático
En el método `update` de la clase base, se ejecutará obligatoriamente:
```dart
final data = item.toJson();
data.remove(primaryKey); // <-- Prevención del error GENERATED ALWAYS
data['actualizado_por'] = idUsuario;
```

## Risks / Trade-offs
- **[Riesgo] Pérdida de flexibilidad en catálogos atípicos** → *Mitigación*: La clase base permitirá sobrescribir (override) los métodos estándar si un catálogo necesita lógica especial antes o después de guardar.
- **[Riesgo] Conflictos en el refactor masivo** → *Mitigación*: Se migrarán los providers en lotes pequeños, empezando por los catálogos más simples y corriendo el analyzer de Flutter.

## Migration Plan
1. Crear el archivo `lib/core/providers/base_crud_notifier.dart` con la nueva clase base.
2. Refactorizar un catálogo de prueba (e.g. `TiendasNotifier`) para que herede de la clase base.
3. Verificar el comportamiento (Create, Update, Delete) en la UI.
4. Refactorizar el resto de los catálogos en lotes.
