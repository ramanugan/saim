-- ==============================================================================
-- SAIM - Sincronizar usuarios de Auth con Perfiles Públicos
-- ==============================================================================

-- 1. Crear función que se ejecutará automáticamente al crear un usuario nuevo
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  -- 1. Insert into user_profiles
  INSERT INTO public.user_profiles (id, first_name, last_name, email)
  VALUES (new.id, '', '', new.email);
  
  -- 2. Insert into usuario
  INSERT INTO public.usuario (nombre_usuario, correo, hash_contrasena, estado_cuenta, requiere_mfa, creado_por, actualizado_por, activo)
  VALUES (new.email, new.email, 'supabase-auth', 'Activa', false, 1, 1, true)
  ON CONFLICT DO NOTHING;

  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Crear un Trigger en la tabla auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- 3. Sincronizar (Backfill) usuarios existentes que no tienen perfil
INSERT INTO public.user_profiles (id, first_name, last_name, email)
SELECT id, '', '', email FROM auth.users
WHERE id NOT IN (SELECT id FROM public.user_profiles)
ON CONFLICT (id) DO NOTHING;
