# ui/responsive-layout Specification

## Purpose
Adapta la estructura principal (AppLayout) y el comportamiento del menú lateral (AppDrawer) según el ancho de la pantalla para una mejor experiencia de escritorio y móvil.

## Requirements

### Requirement: Layout Responsivo
The system SHALL display the navigation drawer differently depending on the screen width.

#### Scenario: Pantalla ancha (Desktop/Tablet)
- **WHEN** el ancho de la pantalla es mayor o igual a 800px
- **THEN** el sistema debe mostrar el AppDrawer de forma estática y persistente a la izquierda del contenido principal.
- **THEN** el AppDrawer no debe superponerse al contenido, sino empujarlo (estar a su lado).

#### Scenario: Pantalla pequeña (Móvil)
- **WHEN** el ancho de la pantalla es menor a 800px
- **THEN** el sistema debe ocultar el AppDrawer por defecto.
- **THEN** el sistema debe mostrar un botón de menú (hamburger menu) en el AppBar.
- **THEN** al presionar el botón de menú, el AppDrawer debe mostrarse como un overlay (superpuesto al contenido) que se oculta al perder el foco.
