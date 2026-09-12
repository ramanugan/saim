## Purpose

Permite gestionar la identidad de los usuarios y su vínculo con los perfiles del sistema sin exponer credenciales directamente en el backend local.

## ADDED Requirements

### Requirement: CRUD de Usuarios
El sistema SHALL permitir al administrador visualizar, crear y modificar usuarios.

#### Scenario: Visualización
- **WHEN** el administrador accede a la sección de Usuarios
- **THEN** observa una tabla listando a los usuarios registrados (solo aquellos con `activo` = true) incluyendo su correo y estado_cuenta.

#### Scenario: Creación silenciosa en Supabase Auth
- **WHEN** el administrador crea un nuevo usuario con correo, contraseña temporal y rol
- **THEN** el sistema invoca la API (edge function / service role) para crear el usuario en Supabase Auth de forma que la sesión del administrador no se cierre, y la base de datos se encargará de crear el perfil.

#### Scenario: Asignar a un empleado
- **WHEN** el administrador asocia un usuario a un empleado del sistema
- **THEN** el perfil público del usuario se actualiza con su respectivo `id_empleado`.
