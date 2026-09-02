## 1. Habilitación de Supabase Realtime (Base de Datos)

- [x] 1.1 Identificar las tablas core de catálogos y operaciones (cliente, contrato, tienda, etc.).
- [x] 1.2 Ejecutar comandos SQL (ALTER PUBLICATION supabase_realtime ADD TABLE) para habilitar REPLICA IDENTITY FULL y suscripción a Realtime en las tablas operativas.

## 2. Refactorización de Capa Base (Frontend)

- [x] 2.1 Modificar `lib/core/providers/base_crud_notifier.dart` para declarar un `RealtimeChannel? _channel`.
- [x] 2.2 Crear el método `_setupRealtime()` en la inicialización para suscribirse a `public:$tableName`.
- [x] 2.3 Conectar el callback de `PostgresChangeEvent.all` para ejecutar `fetch()` tras cada evento, manejando de-bouncing si es necesario.
- [x] 2.4 Sobrescribir `dispose()` para limpiar y cancelar (`unsubscribe()`) la conexión de WebSocket al destruir el notifier.

## 3. Pruebas y Validación

- [x] 3.1 Probar inserción local de un catálogo y verificar que el `fetch()` actualiza correctamente.
- [x] 3.2 Probar eliminación externa directamente desde Supabase y validar que la UI reacciona sin recargar.
- [x] 3.3 Revisar la consola del navegador para confirmar que no haya fugas de memoria o canales suscritos permanentemente.
