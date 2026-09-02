## Purpose

Define el comportamiento de sincronización en tiempo real del sistema, asegurando que los cambios externos se reflejen instantáneamente en las listas y catálogos de todos los clientes conectados.

## ADDED Requirements

### Requirement: Sincronización automática de listas de datos
El sistema SHALL actualizar automáticamente cualquier lista de datos (catálogos, módulos operativos) que dependa de la base de datos principal, sin requerir intervención manual del usuario.

#### Scenario: Cambio externo en un registro
- **WHEN** un registro en la base de datos es modificado, creado o eliminado por cualquier medio (otro usuario u operación directa en DB)
- **THEN** el sistema refresca los datos mostrados en pantalla para reflejar el estado más reciente de manera inmediata.

### Requirement: Persistencia de estado en UI
El sistema SHALL mantener la consistencia de los datos en memoria para todas las pantallas mientras existan sesiones activas escuchando cambios en la tabla subyacente.

#### Scenario: Suscripción a cambios
- **WHEN** un usuario entra a un módulo o vista que muestra datos tabulares
- **THEN** el sistema se suscribe silenciosamente a los eventos de la base de datos correspondientes a los datos visualizados.
