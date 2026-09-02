## Purpose
Permite a los administradores del sistema gestionar el ciclo de vida de los proveedores (lectura, creación, actualización y borrado lógico), para que estén disponibles en otros módulos como suministros o contratos.

## ADDED Requirements

### Requirement: Consulta de proveedores
El sistema SHALL mostrar una lista paginada o completa de los proveedores activos en el sistema, visualizando su razón social, contacto, RFC, tipo y estatus.

#### Scenario: Visualización exitosa de proveedores activos
- **WHEN** el usuario ingresa al submódulo "Compras -> Proveedor"
- **THEN** el sistema despliega una tabla con los proveedores cuyo estado `activo` sea verdadero.

### Requirement: Alta de proveedores
El sistema SHALL permitir registrar un nuevo proveedor exigiendo como campos mínimos la Razón Social, el Tipo de Proveedor y el Estatus.

#### Scenario: Registro exitoso
- **WHEN** el usuario completa el formulario con campos válidos y presiona "Guardar"
- **THEN** el sistema crea un nuevo registro en la tabla `proveedor` y actualiza la tabla visible.

### Requirement: Baja lógica de proveedores
El sistema SHALL permitir "eliminar" un proveedor marcándolo como inactivo sin borrar el registro físico de la base de datos para preservar la integridad referencial.

#### Scenario: Borrado lógico exitoso
- **WHEN** el usuario confirma la acción de eliminar sobre un proveedor específico
- **THEN** el sistema actualiza el registro poniendo `activo = false` y este desaparece de la vista principal.
