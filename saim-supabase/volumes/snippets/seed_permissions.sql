-- ==============================================================================
-- SAIM - Semilla Inicial de Permisos (Catálogo Base)
-- ==============================================================================

INSERT INTO public.permissions (module, action, description) VALUES
-- Módulo Usuarios
('usuarios', 'ver', 'Ver la lista de usuarios'),
('usuarios', 'crear', 'Registrar un nuevo usuario'),
('usuarios', 'editar', 'Modificar perfil y roles de usuario'),
('usuarios', 'eliminar', 'Eliminar o deshabilitar usuario'),

-- Módulo Tablero
('tablero', 'ver', 'Ver el tablero de control principal'),
('tablero', 'crear', 'Crear widgets o paneles en tablero'),
('tablero', 'editar', 'Modificar configuración del tablero'),
('tablero', 'eliminar', 'Eliminar paneles del tablero'),

-- Módulo Catálogos
('catalogos', 'ver', 'Consultar catálogos del sistema'),
('catalogos', 'crear', 'Agregar elementos a los catálogos'),
('catalogos', 'editar', 'Modificar elementos de catálogos'),
('catalogos', 'eliminar', 'Eliminar elementos de catálogos'),

-- Módulo Orden de Campo
('orden_campo', 'ver', 'Ver las órdenes de campo'),
('orden_campo', 'crear', 'Crear una nueva orden de campo'),
('orden_campo', 'editar', 'Modificar o reasignar orden de campo'),
('orden_campo', 'eliminar', 'Cancelar o eliminar orden de campo'),

-- Módulo Contratos
('contratos', 'ver', 'Consultar detalles de contratos'),
('contratos', 'crear', 'Dar de alta un nuevo contrato'),
('contratos', 'editar', 'Modificar alcance y zonas del contrato'),
('contratos', 'eliminar', 'Dar de baja un contrato'),

-- Módulo Iguala de tienda
('iguala', 'ver', 'Consultar información de iguala de tienda'),
('iguala', 'crear', 'Crear registros de iguala'),
('iguala', 'editar', 'Modificar registros de iguala'),
('iguala', 'eliminar', 'Eliminar registros de iguala'),

-- Módulo Calendario
('calendario', 'ver', 'Ver el calendario operativo'),
('calendario', 'crear', 'Agregar eventos al calendario'),
('calendario', 'editar', 'Modificar eventos del calendario'),
('calendario', 'eliminar', 'Eliminar eventos del calendario'),

-- Módulo Cuadrillas
('cuadrillas', 'ver', 'Consultar información de cuadrillas'),
('cuadrillas', 'crear', 'Dar de alta nuevas cuadrillas'),
('cuadrillas', 'editar', 'Modificar asignaciones de cuadrillas'),
('cuadrillas', 'eliminar', 'Dar de baja cuadrillas'),

-- Módulo Captura central
('captura_central', 'ver', 'Consultar expedientes de captura central'),
('captura_central', 'crear', 'Crear registros de captura central'),
('captura_central', 'editar', 'Modificar registros de captura central'),
('captura_central', 'eliminar', 'Eliminar registros de captura central'),

-- Módulo Validación
('validacion', 'ver', 'Ver módulo de validación documental'),
('validacion', 'crear', 'Crear registros de validación'),
('validacion', 'editar', 'Modificar estatus de validación'),
('validacion', 'eliminar', 'Eliminar registros de validación'),

-- Módulo Refacciones y backlog
('refacciones', 'ver', 'Consultar inventario y backlog de refacciones'),
('refacciones', 'crear', 'Crear solicitudes de refacciones'),
('refacciones', 'editar', 'Modificar solicitudes de refacciones'),
('refacciones', 'eliminar', 'Eliminar solicitudes de refacciones'),

-- Módulo Correctivos
('correctivos', 'ver', 'Consultar embudo y tickets correctivos'),
('correctivos', 'crear', 'Levantar nuevos tickets correctivos'),
('correctivos', 'editar', 'Modificar tickets correctivos'),
('correctivos', 'eliminar', 'Eliminar tickets correctivos'),

-- Módulo Gastos y recursos
('gastos', 'ver', 'Consultar gastos operativos y recursos'),
('gastos', 'crear', 'Registrar nuevos gastos'),
('gastos', 'editar', 'Modificar registros de gastos'),
('gastos', 'eliminar', 'Eliminar registros de gastos'),

-- Módulo Facturación y cobranza
('cobranza', 'ver', 'Consultar facturación y cobranza'),
('cobranza', 'crear', 'Crear registros de facturación'),
('cobranza', 'editar', 'Modificar estado de cobranza'),
('cobranza', 'eliminar', 'Eliminar registros de facturación')

ON CONFLICT (module, action) DO NOTHING;
