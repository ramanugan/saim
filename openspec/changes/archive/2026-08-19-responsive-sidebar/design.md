## Context
Actualmente `AppLayout` devuelve un `Scaffold` simple que usa `drawer: AppDrawer()`. Esto fuerza el menú a funcionar como overlay en todos los tamaños de pantalla. Se necesita un diseño que fije el menú en pantallas anchas (ver `proposal.md` y `spec.md`).

## Goals / Non-Goals

**Goals:**
- Implementar un diseño responsivo (Menú fijo a la izquierda, contenido a la derecha) para pantallas de escritorio.
- Mantener la experiencia nativa de "Drawer" (overlay) en móviles.

**Non-Goals:**
- No se van a modificar los colores ni el contenido estructural interno de las opciones del `AppDrawer`. Sólo su disposición general en la pantalla.
- No se añadirá funcionalidad de "mini-drawer" colapsable.

## Decisions

**Decisión 1: LayoutBuilder para Responsividad**
- Usaremos `LayoutBuilder` dentro del método `build` de `AppLayout`.
- El punto de quiebre (breakpoint) será de `800` px.
- Si el ancho disponible `constraints.maxWidth >= 800`: El `Scaffold` **no** usará la propiedad `drawer`. Su `body` será un `Row` con `AppDrawer` como ancho fijo y un `Expanded` conteniendo el contenido original.
- Si `constraints.maxWidth < 800`: Se devuelve el `Scaffold` tal y como estaba antes, con `drawer: AppDrawer()` y el `body` normal.

**Decisión 2: Cierre de Modal Drawer**
- **Problema:** En `AppDrawer` (`app_drawer.dart`), cada navegación termina con un `Navigator.pop(context);` para cerrar el menú superpuesto. Si se ejecuta `Navigator.pop(context)` cuando el drawer forma parte del `Row` fijo, cerrará la pantalla entera accidentalmente.
- **Solución:** Ajustar `app_drawer.dart` para comprobar si el modal está abierto antes de hacer pop. Se puede comprobar si `Scaffold.of(context).isDrawerOpen` o, más simple, que `AppLayout` pase un flag al constructor de `AppDrawer` (ej. `isModal: true`) indicando si está operando como un Drawer de overlay, y sólo invocar a `pop()` si `isModal` es cierto.

## Risks / Trade-offs

- **[Riesgo]** Rutas que asumen la estructura anterior podrían experimentar destellos o recargas innecesarias.
- **[Mitigación]** El estado de GoRouter y los Providers aseguran que la reconstrucción bajo `AppLayout` sea eficiente y sin redibujos drásticos.
