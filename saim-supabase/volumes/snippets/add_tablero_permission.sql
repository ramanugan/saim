-- ==============================================================================
-- SAIM - Agregar permiso de Tablero
-- ==============================================================================

INSERT INTO public.permissions (module, action, description) 
VALUES ('tablero', 'ver', 'Ver el tablero de control principal')
ON CONFLICT (module, action) DO NOTHING;
