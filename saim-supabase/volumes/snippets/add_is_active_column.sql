-- ==============================================================================
-- SAIM - Agregar campo para Habilitar/Deshabilitar Usuarios
-- ==============================================================================

-- 1. Agregar la columna is_active a la tabla user_profiles
ALTER TABLE public.user_profiles 
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

-- 2. Asegurar que los perfiles existentes tengan el campo en true
UPDATE public.user_profiles SET is_active = true WHERE is_active IS NULL;
