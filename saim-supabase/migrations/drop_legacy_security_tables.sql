-- Eliminar las tablas viejas (roles, user_profiles, role_permissions)
-- Se debe ejecutar con precaución ya que borra la información.
BEGIN;

-- Desactivar temporalmente los triggers si los hubiera en estas tablas, 
-- aunque al hacer drop cascade se eliminarán junto con la tabla.

-- Actualizar funciones que dependían de user_profiles, roles y role_permissions
CREATE OR REPLACE FUNCTION public.is_admin() RETURNS boolean AS $$ 
SELECT EXISTS (
  SELECT 1 FROM public.usuario u 
  JOIN public.usuario_rol ur ON u.id_usuario = ur.id_usuario 
  JOIN public.rol r ON ur.id_rol = r.id_rol 
  WHERE u.auth_id = auth.uid() AND ur.activo = true AND r.nombre = 'Administrador'
); 
$$ LANGUAGE sql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.has_permission(requested_module text, requested_action text) RETURNS boolean AS $$ 
SELECT public.is_admin() OR EXISTS ( 
  SELECT 1 FROM public.usuario u 
  JOIN public.usuario_rol ur ON u.id_usuario = ur.id_usuario 
  JOIN public.rol_permiso rp ON ur.id_rol = rp.id_rol 
  JOIN public.permissions p ON rp.id_permiso = p.id 
  WHERE u.auth_id = auth.uid() AND ur.activo = true AND p.module = requested_module AND p.action = requested_action 
); 
$$ LANGUAGE sql STABLE SECURITY DEFINER;

-- Eliminar las tablas viejas
DROP TABLE IF EXISTS public.role_permissions CASCADE;
DROP TABLE IF EXISTS public.user_profiles CASCADE;
DROP TABLE IF EXISTS public.roles CASCADE;

COMMIT;
