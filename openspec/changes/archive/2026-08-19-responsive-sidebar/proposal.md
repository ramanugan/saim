## Why

Actualmente, el menú lateral (AppDrawer) se implementa exclusivamente mediante la propiedad `drawer` del `Scaffold`. En Flutter, esto significa que el menú funciona como un modal/overlay (se oculta al perder el foco). Para mejorar la experiencia de usuario en pantallas grandes (escritorio/tablet), necesitamos un menú lateral que se mantenga persistente (fijo) y empuje el contenido principal de la aplicación, sin ocultarse al hacer clic en otra parte.

## What Changes

- Modificar el diseño general de la aplicación (`AppLayout`) para que sea responsivo.
- Pantallas grandes: El `AppLayout` utilizará un contenedor `Row` donde el `AppDrawer` estará fijo en la parte izquierda, y el contenido principal utilizará el espacio restante (`Expanded`).
- Pantallas pequeñas (Móviles): El `AppLayout` mantendrá el comportamiento actual utilizando la propiedad `drawer` del `Scaffold` con un botón de menú (hamburger menu) estándar.

## Capabilities

### New Capabilities
- `ui/responsive-layout`: Capacidad del layout principal de la aplicación para adaptar la disposición del menú lateral según el ancho de la pantalla (Desktop vs Mobile).

### Modified Capabilities

## Impact

- `lib/shared/layouts/app_layout.dart`: Necesita ser convertido en un widget responsivo usando `LayoutBuilder` o `MediaQuery`.
- `lib/shared/layouts/app_drawer.dart`: Podría requerir pequeños ajustes para asegurar que se muestre correctamente al ser utilizado de forma estática en lugar de modal.
