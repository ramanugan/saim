---
name: flutter-optimization
description: Úsala para revisar, mejorar y optimizar archivos o componentes de Flutter en el frontend (saim-frontend). Aplica mejores prácticas de rendimiento, Riverpod, y asegura el cumplimiento del sistema de diseño (AppTheme).
---

# Skill: Optimización de Código Flutter (SAIM)

Cuando el usuario invoque esta skill o solicite "optimizar un widget/archivo", debes seguir este flujo de trabajo estrictamente para mejorar el rendimiento y la calidad del código.

## 1. Análisis de Reconstrucciones (Rebuilds) y Constructores `const`
- **Modificadores `const`**: Analiza el árbol de widgets y agrega el modificador `const` a todos los constructores de widgets que sean inmutables. Esto es crítico para el rendimiento en Flutter.
- **División de Widgets**: Si ves que el método `build` es muy grande o tiene métodos auxiliares que retornan widgets (ej. `Widget _buildCuerpo()`), refactorízalos convirtiéndolos en clases separadas (StatelessWidget) independientes. Esto permite usar `const` en ellos y aísla sus reconstrucciones.

## 2. Optimización de Estado (Riverpod)
Dado que el proyecto usa Riverpod (`flutter_riverpod`):
- **`ref.watch` vs `ref.read`**: Asegúrate de que **nunca** se use `ref.read()` dentro de un método `build()`. Usa `ref.watch()`.
- **Selectores**: Si un widget solo necesita escuchar una parte específica de un estado complejo, utiliza `.select()` para evitar que todo el widget se reconstruya cuando cambien propiedades irrelevantes (ej. `ref.watch(miProvider.select((state) => state.propiedadEspecifica))`).
- **ConsumerWidget**: En lugar de envolver todo el árbol en un `Consumer`, asegúrate de que el widget principal extienda `ConsumerWidget` o usar el widget `Consumer` solo en las partes de la UI que realmente cambian.

## 3. Regla Estricta de UI y Temas (¡Crítico!)
El proyecto tiene soporte para modo oscuro/claro y prohíbe colores estáticos.
- **NO HARDCODEAR COLORES**: Busca e identifica colores estáticos como `Colors.white`, `Colors.black`, `AppColors.navy`, etc.
- **Reemplazo Temático**: Reemplaza cualquier color estático por las extensiones temáticas del contexto. Ejemplos permitidos:
  - `context.surfaceColor`
  - `context.textColor`
  - `context.backgroundColor`
  - `context.primaryColor`
*(Estas extensiones provienen de `lib/core/theme/app_theme.dart`).*

## 4. Limpieza y Estática
- Remueve "dead code" (código comentado, variables sin usar, imports sin usar).
- Añade comas finales (`,`) en las propiedades de los widgets para que el formateador de Flutter estructure bien el código.

## 5. Verificación Final
Después de aplicar todos estos cambios al archivo, debes indicarle al usuario que corra el análisis estático (o correrlo tú si tienes permiso):
```bash
cd saim-frontend
flutter analyze
```

---
**Formato de Respuesta:** Al terminar, muestra un resumen claro de los cambios realizados mediante una lista de viñetas, destacando especialmente dónde se mejoró el rendimiento (ej. "Se extrajo la lista en un widget separado para evitar rebuilds") y dónde se corrigieron colores hardcodeados.
