-- ==============================================================================
-- SAIM - Asegurar RLS en role_permissions para Administración
-- ==============================================================================

-- 1. Permitir que los Administradores puedan Insertar (Asignar permisos a roles)
DROP POLICY IF EXISTS "Admins pueden insertar en role_permissions" ON public.role_permissions;
CREATE POLICY "Admins pueden insertar en role_permissions" ON public.role_permissions
    FOR INSERT 
    WITH CHECK ( public.is_admin() );

-- 2. Permitir que los Administradores puedan Eliminar (Quitar permisos a roles)
DROP POLICY IF EXISTS "Admins pueden eliminar en role_permissions" ON public.role_permissions;
CREATE POLICY "Admins pueden eliminar en role_permissions" ON public.role_permissions
    FOR DELETE 
    USING ( public.is_admin() );
