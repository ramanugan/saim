-- ==============================================================================
-- SAIM - Corregir Políticas RLS para Administradores
-- ==============================================================================

-- 1. Crear una función segura (bypassea RLS para evitar recursión infinita) 
-- que determine si el usuario actual es Administrador
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_profiles up
    JOIN public.roles r ON up.role_id = r.id
    WHERE up.id = auth.uid() AND r.name = 'Administrador'
  );
$$;

-- 2. Agregar política para que los administradores puedan LEER todos los perfiles
DROP POLICY IF EXISTS "Administradores pueden ver todos los perfiles" ON public.user_profiles;
CREATE POLICY "Administradores pueden ver todos los perfiles" 
ON public.user_profiles
FOR SELECT 
USING ( public.is_admin() );

-- 3. Agregar política para que los administradores puedan ACTUALIZAR (editar roles) de todos
DROP POLICY IF EXISTS "Administradores pueden editar todos los perfiles" ON public.user_profiles;
CREATE POLICY "Administradores pueden editar todos los perfiles" 
ON public.user_profiles
FOR UPDATE 
USING ( public.is_admin() );
