# modal-data-table Specification

## Purpose
Define el comportamiento estándar para las tablas de datos (`DataTable`) contenidas dentro de modales (como los flujos CRUD), garantizando la visibilidad del contenido y la capacidad de desplazamiento en entornos web y de escritorio.

## Requirements

### Requirement: Comportamiento de Scroll Horizontal
El sistema MUST permitir a los usuarios desplazarse horizontalmente por el contenido de una tabla modal que excede el ancho disponible, utilizando tanto una barra de desplazamiento visible como la función de clic y arrastre con el cursor.

#### Scenario: Contenido excede el ancho del modal
- **WHEN** una tabla de datos dentro de un modal contiene columnas que superan el ancho máximo del contenedor
- **THEN** se muestra una barra de desplazamiento horizontal explícita (Scrollbar)
- **THEN** el usuario puede hacer clic y arrastrar horizontalmente para ver el contenido oculto.

### Requirement: Scroll Global con Puntero
El sistema MUST registrar globalmente los dispositivos de tipo "mouse" y "trackpad" para que soporten la acción de arrastrar para desplazar en cualquier vista con desplazamiento de la plataforma, emulando la experiencia de dispositivos táctiles.

#### Scenario: Navegación en navegador web o escritorio
- **WHEN** un usuario en navegador de escritorio intenta arrastrar horizontalmente el contenido de un componente `SingleChildScrollView`
- **THEN** el contenido se desplaza en lugar de solo seleccionar el texto.
