## 1. AppDrawer modifications

- [x] 1.1 Modificar `AppDrawer` en `lib/shared/layouts/app_drawer.dart` para que reciba un parámetro opcional `bool isModal = true`.
- [x] 1.2 Actualizar las llamadas a `Navigator.pop(context)` dentro de `AppDrawer` para que sólo se ejecuten si `isModal == true`, evitando que cierre la pantalla entera en modo escritorio fijo.

## 2. AppLayout refactor

- [x] 2.1 Refactorizar `AppLayout` en `lib/shared/layouts/app_layout.dart` para envolver el contenido del `build` en un `LayoutBuilder`.
- [x] 2.2 Implementar lógica condicional en `LayoutBuilder`: Si `constraints.maxWidth >= 800`, devolver un `Scaffold` **sin** propiedad `drawer`. Su `body` contendrá un `Row` con un contenedor de ancho fijo para el `AppDrawer(isModal: false)` y un `Expanded` con el contenido de la pantalla.
- [x] 2.3 Mantener la lógica original para `constraints.maxWidth < 800`: devolver el `Scaffold` con `drawer: AppDrawer(isModal: true)` y el `body` original.
