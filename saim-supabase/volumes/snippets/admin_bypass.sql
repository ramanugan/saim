-- ==============================================================================
-- SAIM - Superuser Bypass para Administradores
-- ==============================================================================

-- 1. Actualizar la vista my_permissions para que devuelva TODOS los permisos si es admin
CREATE OR REPLACE VIEW public.my_permissions AS
SELECT p.module, p.action
FROM public.permissions p
WHERE public.is_admin()
UNION
SELECT p.module, p.action
FROM public.user_profiles up
JOIN public.role_permissions rp ON up.role_id = rp.role_id
JOIN public.permissions p ON rp.permission_id = p.id
WHERE up.id = auth.uid();

-- 2. Actualizar la función central has_permission para que deje pasar si es admin
CREATE OR REPLACE FUNCTION public.has_permission(requested_module TEXT, requested_action TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT 
    public.is_admin() 
    OR 
    EXISTS (
      SELECT 1
      FROM user_profiles up
      JOIN role_permissions rp ON up.role_id = rp.role_id
      JOIN permissions p ON rp.permission_id = p.id
      WHERE up.id = auth.uid()
        AND p.module = requested_module
        AND p.action = requested_action
    );
$$;
