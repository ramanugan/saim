## 1. Provider (Estado Global)

- [x] 1.1 Editar `lib/features/catalogs/providers/zonas_contrato_provider.dart` para agregar `helperZonasContratoUnicasProvider`.
- [x] 1.2 Implementar en el provider el filtrado de `zonasContratoProvider` garantizando que los elementos sean únicos según su `codigo`.

## 2. UI y Flujo (Modal de Contratos)

- [x] 2.1 Importar el nuevo provider en `lib/features/catalogs/widgets/modals/crud_contratos_modal.dart`.
- [x] 2.2 Agregar el botón "Importar Existente" junto al botón "Agregar Zona".
- [x] 2.3 Crear la función `_mostrarDialogoZonasUnicas` que levante un `showDialog`.
- [x] 2.4 Implementar el `Consumer` dentro del diálogo que escuche a `helperZonasContratoUnicasProvider` y pinte un `ListView` con las zonas.
- [x] 2.5 Configurar el `onTap` de cada `ListTile` del diálogo para que agregue un nuevo elemento a `_zonas` con los valores recuperados y cierre el modal.
