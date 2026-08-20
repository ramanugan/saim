## 1. Backend: Base de Datos

- [x] 1.1 Crear el Stored Procedure `crear_contrato_completo` en Supabase (PL/pgSQL) para manejar la transacción de las 6 tablas.
- [x] 1.2 Probar manualmente la ejecución del SP con un JSON simulado para asegurar la funcionalidad y el Rollback.

## 2. Frontend: Modales Simples

- [x] 2.1 Crear `CrudClientesModal` y conectarlo a `app_drawer.dart`. (ya existía, conectado en Contratos)
- [x] 2.2 Crear `CrudTiendasModal` y conectarlo a `app_drawer.dart`.
- [x] 2.3 Crear `CrudZonaEstadoModal` y conectarlo a `app_drawer.dart`. (ya existía, conectado en Contratos)
- [x] 2.4 Crear `CrudZonaTiendaModal` y conectarlo a `app_drawer.dart`.
- [x] 2.5 Crear y probar los providers (StateNotifier) necesarios para estos 4 modales. (`tiendas_provider`, `zonas_tienda_provider` creados; `clientes_provider` y `zonas_estado_provider` ya existían)

## 3. Frontend: Modal Stepper (Contrato)

- [x] 3.1 Crear la estructura base `CrudContratosModal` con el widget `Stepper` de Flutter.
- [x] 3.2 Implementar Paso 1: Datos Generales (`contrato`).
- [x] 3.3 Implementar Paso 2: Versión Inicial (`contrato_version`).
- [x] 3.4 Implementar Paso 3: Zonas Geográficas (`zona_contrato`).
- [x] 3.5 Implementar Paso 4: Alcances y SLA (`contrato_alcance`, `contrato_sla`).
- [x] 3.6 Implementar Paso 5: Documentos (`contrato_documento`).
- [x] 3.7 El estado del Wizard se maneja en memoria dentro del widget (sin provider separado, por simplicidad y cohesión).
- [x] 3.8 Conectar la confirmación final al método RPC `crear_contrato_completo` en Supabase y manejar errores/éxito en la UI.

## 4. Menú Lateral

- [x] 4.1 Agregar submenú 'Contratos' en `app_drawer.dart` debajo de 'Refacciones'.
- [x] 4.2 Conectar los 5 subitems: Cliente, Tienda, Zona Estado, Zona Tienda, Contrato.
