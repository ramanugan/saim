-- ==============================================================================
-- SAIM - Vista de Permisos del Usuario Actual
-- ==============================================================================

-- 1. Crear vista para obtener los permisos del usuario autenticado
CREATE OR REPLACE VIEW public.my_permissions AS
SELECT p.module, p.action
FROM public.user_profiles up
JOIN public.role_permissions rp ON up.role_id = rp.role_id
JOIN public.permissions p ON rp.permission_id = p.id
WHERE up.id = auth.uid();

-- 2. Conceder permisos de lectura a la API (PostgREST)
GRANT SELECT ON public.my_permissions TO authenticated;

-- 3. Asegurar que los usuarios puedan leer la tabla puente 'role_permissions'
-- (Faltaba esta política RLS en el esquema original para que la vista pueda funcionar)
DROP POLICY IF EXISTS "Cualquiera puede ver role_permissions" ON public.role_permissions;
CREATE POLICY "Cualquiera puede ver role_permissions" ON public.role_permissions
    FOR SELECT USING (true);
