-- ==============================================================================
-- SAIM - Agregar Email a los Perfiles de Usuario
-- ==============================================================================

-- 1. Agregar columna email a user_profiles
ALTER TABLE public.user_profiles 
ADD COLUMN IF NOT EXISTS email TEXT;

-- 2. Migrar los correos existentes desde auth.users hacia user_profiles
UPDATE public.user_profiles up
SET email = au.email
FROM auth.users au
WHERE up.id = au.id AND up.email IS NULL;
