## Why

Actualmente, las opciones del menú lateral se han ido agregando de forma empírica y desordenada. Además, el modelo de base de datos define claramente un módulo de Seguridad (con tablas como `usuario`, `rol`, `usuario_rol` y `organizacion_proveedora`) que no tiene representación en el frontend. Implementar estos CRUDs y reorganizar la navegación de manera semántica brindará a los administradores las herramientas necesarias para gestionar los accesos, y mejorará dramáticamente la experiencia de usuario general.

## What Changes

- **Reestructuración del Menú Lateral**: Reagrupar las opciones actuales en categorías lógicas (por ejemplo: "Catálogos", "Seguridad", "Órdenes de Servicio").
- **Nuevo Módulo de Seguridad**: Creación del submenú "Seguridad" en el drawer principal.
- **CRUD de Roles**: Pantalla e integración para gestionar los roles del sistema.
- **CRUD de Usuarios**: Pantalla e integración para crear y modificar usuarios, orquestando la creación silenciosa en Supabase Auth mediante API de Admin o Edge Functions.
- **CRUD de Usuario-Rol**: Asignación de roles a usuarios, con selectores reactivos.
- **CRUD de Organización Proveedora**: Pantalla e integración para gestionar `organizacion_proveedora`.

## Capabilities

### New Capabilities
- `seguridad/usuarios`: Gestión completa de la identidad, incluyendo la integración silenciosa con Supabase Auth (API Admin).
- `seguridad/roles`: Gestión del catálogo de roles del sistema.
- `seguridad/usuario-rol`: Asignación de roles a usuarios, con posibles restricciones de ámbito (cliente o zona).
- `seguridad/organizacion-proveedora`: Gestión de la organización (razón social, RFC, etc.).
- `core/navegacion`: Definición de la estructura y agrupación semántica del menú lateral izquierdo.

### Modified Capabilities
- Ninguna.

## Impact

- **Frontend (Flutter)**: Refactorización del widget del menú lateral (Drawer) y enrutador principal (`GoRouter`). Se crearán 4 nuevos módulos completos de presentación (Modales/Pantallas, Notifiers Riverpod y modelos).
- **Backend (Supabase)**: Se activarán los endpoints estándar para las 4 tablas mencionadas y, muy probablemente, se requiera habilitar/usar la función `supabase.auth.admin` (service role) desde el lado del cliente (si es seguro/interno) o vía Edge Functions para la creación de cuentas sin desloguear al admin.
