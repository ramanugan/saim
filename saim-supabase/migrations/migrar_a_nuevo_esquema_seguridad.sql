BEGIN;

-- 2. Migrar los perfiles de usuario antiguos a la nueva tabla 'usuario'
-- Primero migramos usuarios para asegurarnos de que existan y podamos usar su ID como 'creado_por'
UPDATE public.usuario usr
SET 
    auth_id = u.id,
    nombre_usuario = COALESCE(up.first_name || ' ' || up.last_name, split_part(u.email, '@', 1)),
    estado_cuenta = CASE WHEN up.is_active THEN 'ACTIVA' ELSE 'INACTIVA' END
FROM auth.users u
LEFT JOIN public.user_profiles up ON up.id = u.id
WHERE usr.correo = u.email;

INSERT INTO public.usuario (auth_id, correo, nombre_usuario, estado_cuenta, requiere_mfa, creado_por, actualizado_por)
SELECT 
    u.id, 
    u.email, 
    COALESCE(up.first_name || ' ' || up.last_name, split_part(u.email, '@', 1)),
    CASE WHEN up.is_active THEN 'ACTIVA' ELSE 'INACTIVA' END,
    false,
    1, 
    1
FROM auth.users u
LEFT JOIN public.user_profiles up ON up.id = u.id
WHERE NOT EXISTS (
    SELECT 1 FROM public.usuario existing WHERE existing.correo = u.email
);

-- 1. Insertar todos los roles antiguos en la nueva tabla 'rol'
INSERT INTO public.rol (id_rol, codigo, nombre, descripcion, activo, creado_por, actualizado_por)
OVERRIDING SYSTEM VALUE
SELECT 
    id, 
    UPPER(REPLACE(name, ' ', '_')), 
    name, 
    description,
    true,
    1,
    1
FROM public.roles
ON CONFLICT (id_rol) DO NOTHING;

-- Asegurarnos de que el serial de 'rol' avance correctamente después de insertar explícitamente IDs
SELECT setval('rol_id_rol_seq', (SELECT MAX(id_rol) FROM public.rol));

-- 3. Asignar los roles correspondientes en 'usuario_rol'
INSERT INTO public.usuario_rol (id_usuario, id_rol, activo, fecha_inicio, creado_por, actualizado_por)
SELECT 
    usr.id_usuario,
    up.role_id,
    true,
    CURRENT_DATE,
    1,
    1
FROM public.user_profiles up
JOIN auth.users au ON au.id = up.id
JOIN public.usuario usr ON usr.auth_id = au.id
WHERE up.role_id IS NOT NULL
AND NOT EXISTS (
    SELECT 1 FROM public.usuario_rol ur 
    WHERE ur.id_usuario = usr.id_usuario AND ur.id_rol = up.role_id
);

-- 4. Crear la tabla transicional para permisos (rol_permiso)
CREATE TABLE IF NOT EXISTS public.rol_permiso (
    id_rol integer NOT NULL REFERENCES public.rol(id_rol) ON DELETE CASCADE,
    id_permiso integer NOT NULL REFERENCES public.permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (id_rol, id_permiso)
);

-- Habilitar RLS en rol_permiso
ALTER TABLE public.rol_permiso ENABLE ROW LEVEL SECURITY;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE policyname = 'Admins pueden gestionar rol_permiso' AND tablename = 'rol_permiso'
    ) THEN
        CREATE POLICY "Admins pueden gestionar rol_permiso" ON public.rol_permiso
            FOR ALL
            USING (is_admin());
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE policyname = 'Cualquiera puede leer rol_permiso' AND tablename = 'rol_permiso'
    ) THEN
        CREATE POLICY "Cualquiera puede leer rol_permiso" ON public.rol_permiso
            FOR SELECT
            USING (true);
    END IF;
END $$;

-- 5. Migrar los permisos desde 'role_permissions'
INSERT INTO public.rol_permiso (id_rol, id_permiso)
SELECT role_id, permission_id
FROM public.role_permissions
ON CONFLICT (id_rol, id_permiso) DO NOTHING;

COMMIT;
