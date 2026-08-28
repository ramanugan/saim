## 1. Core Framework

- [x] 1.1 Crear `lib/core/providers/base_crud_notifier.dart` con la clase `SupabaseCrudNotifier<T>`
- [x] 1.2 Implementar los métodos genéricos: `fetch`, `add`, `update`, `delete` y `toggleStatus`
- [x] 1.3 Validar que el método `update` elimine el `primaryKey` del mapa JSON antes de enviarlo a Supabase

## 2. Refactor (Lote 1 - Piloto)

- [x] 2.1 Refactorizar `tiendas_provider.dart` para que extienda de `SupabaseCrudNotifier`
- [x] 2.2 Refactorizar `clientes_provider.dart`
- [x] 2.3 Refactorizar `equipos_provider.dart`
- [x] 2.4 Correr la app localmente y verificar que los flujos CRUD de estos tres catálogos funcionen correctamente y sin errores de base de datos

## 3. Refactor (Lote 2 - Catálogos Restantes)

- [x] 3.1 Refactorizar los providers de refacciones (`refacciones_provider.dart`, `precios_refaccion_provider.dart`, etc.)
- [x] 3.2 Refactorizar los providers de contratos e igualas (`contratos_provider.dart`, `igualas_provider.dart`, etc.)
- [x] 3.3 Refactorizar catálogos del sistema (`zonas_tienda_provider.dart`, `zonas_estado_provider.dart`, `tipos_equipo_provider.dart`, etc.)
- [x] 3.4 Correr `flutter analyze` para asegurar que no hay errores de sintaxis o tipo tras el refactor masivo
