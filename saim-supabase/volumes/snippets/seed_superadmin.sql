-- ==============================================================================
-- SAIM - Seed First Superadmin User
-- ==============================================================================
-- Ejecutar en el SQL Editor de Supabase (Studio)

-- 1. Definir variables
DO $$
DECLARE
  new_user_id UUID := gen_random_uuid();
  admin_role_id INTEGER;
BEGIN
  -- 2. Asegurar que existe el rol 'Administrador'
  SELECT id INTO admin_role_id FROM public.roles WHERE name = 'Administrador' LIMIT 1;
  
  IF admin_role_id IS NULL THEN
    INSERT INTO public.roles (name, description) 
    VALUES ('Administrador', 'Acceso total al sistema sin restricciones')
    RETURNING id INTO admin_role_id;
  END IF;

  -- 3. Insertar en auth.users (el módulo de autenticación)
  -- Nota: Usa un password conocido, aquí: SuperAdmin123!
  INSERT INTO auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at,
    confirmation_token,
    recovery_token,
    email_change_token_new,
    email_change
  ) VALUES (
    '00000000-0000-0000-0000-000000000000',
    new_user_id,
    'authenticated',
    'authenticated',
    'superadmin@saim.com',
    crypt('SuperAdmin123!', gen_salt('bf')),
    now(),
    now(),
    now(),
    '',
    '',
    '',
    ''
  );

  -- 4. Insertar en identidades de auth (necesario en versiones recientes de Supabase)
  INSERT INTO auth.identities (
    id,
    user_id,
    identity_data,
    provider,
    provider_id,
    last_sign_in_at,
    created_at,
    updated_at
  ) VALUES (
    gen_random_uuid(),
    new_user_id,
    format('{"sub":"%s","email":"%s"}', new_user_id::text, 'superadmin@saim.com')::jsonb,
    'email',
    new_user_id::text,
    now(),
    now(),
    now()
  );

  -- 5. Vincular y crear su perfil en public.user_profiles
  -- Nota: Si tienes un trigger que crea el user_profile automáticamente tras un INSERT en auth.users,
  -- esta consulta podría fallar por llave duplicada (dependiendo de cómo implementaste tu trigger).
  -- En ese caso, usa UPDATE. Aquí usaremos un UPSERT (ON CONFLICT).
  INSERT INTO public.user_profiles (id, first_name, last_name, role_id)
  VALUES (new_user_id, 'Super', 'Admin', admin_role_id)
  ON CONFLICT (id) DO UPDATE 
  SET role_id = admin_role_id, 
      first_name = 'Super',
      last_name = 'Admin';

END $$;
