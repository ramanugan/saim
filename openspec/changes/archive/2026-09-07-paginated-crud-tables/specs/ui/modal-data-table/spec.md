## ADDED Requirements

### Requirement: Paginación Client-Side
El sistema MUST presentar los registros de cada tabla CRUD en bloques de 10, con controles de navegación que permitan avanzar y retroceder entre páginas, e indicar la página actual y el total de registros.

#### Scenario: Tabla con más de 10 registros
- **WHEN** una tabla CRUD contiene más de 10 registros
- **THEN** el sistema muestra únicamente los primeros 10 registros y presenta controles de paginación (anterior, siguiente, indicadores de página).

#### Scenario: Tabla con 10 o menos registros
- **WHEN** una tabla CRUD contiene 10 o menos registros
- **THEN** el sistema muestra todos los registros y los controles de paginación permanecen visibles indicando una sola página.

#### Scenario: Actualización reactiva de la paginación
- **WHEN** un registro se agrega, modifica o elimina mientras la tabla está abierta
- **THEN** la tabla se actualiza reactivamente conservando la página actual siempre que siga siendo válida; si la página actual queda vacía, el sistema retrocede a la última página con registros.

### Requirement: Búsqueda y Filtro en Línea
El sistema MUST permitir al usuario filtrar los registros visibles de una tabla CRUD mediante un campo de búsqueda de texto libre ubicado sobre la tabla.

#### Scenario: Filtrado por texto parcial
- **WHEN** el usuario escribe texto en el campo de búsqueda
- **THEN** la tabla muestra únicamente los registros cuyas columnas de datos contengan el texto ingresado (coincidencia parcial, insensible a mayúsculas/minúsculas) y la paginación se reinicia a la primera página.

#### Scenario: Búsqueda sin resultados
- **WHEN** el usuario escribe un texto que no coincide con ningún registro
- **THEN** la tabla muestra un mensaje indicando que no se encontraron resultados y los controles de paginación se ocultan o deshabilitan.

#### Scenario: Limpieza de búsqueda
- **WHEN** el usuario borra el contenido del campo de búsqueda
- **THEN** la tabla restaura todos los registros y la paginación se reinicia a la primera página.
