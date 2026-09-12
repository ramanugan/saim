-- 1. Alterar tabla public.usuario para enlazarla con auth.users
ALTER TABLE public.usuario ADD COLUMN auth_id UUID REFERENCES auth.users(id);
ALTER TABLE public.usuario ALTER COLUMN hash_contrasena DROP NOT NULL;

-- 2. Función del trigger para sincronizar nuevo usuario
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.usuario (
    auth_id, 
    correo, 
    nombre_usuario, 
    estado_cuenta, 
    requiere_mfa, 
    creado_por, 
    actualizado_por
  )
  VALUES (
    NEW.id,
    NEW.email,
    split_part(NEW.email, '@', 1), -- Usar la primera parte del correo como nombre_usuario
    'ACTIVA', 
    FALSE,
    1, -- Asignamos al usuario admin temporalmente
    1  -- Asignamos al usuario admin temporalmente
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Trigger en auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
