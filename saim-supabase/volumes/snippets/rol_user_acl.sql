-- ==============================================================================
-- SAIM - RBAC (Role-Based Access Control) & ACL Schema
-- ==============================================================================

-- 1. Create Tables

-- Almacena los perfiles del sistema
CREATE TABLE public.roles (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

-- Define las acciones atómicas por módulo (ej. module: 'field_orders', action: 'create')
CREATE TABLE public.permissions (
    id SERIAL PRIMARY KEY,
    module TEXT NOT NULL,
    action TEXT NOT NULL,
    description TEXT,
    UNIQUE(module, action)
);

-- Tabla intermedia que vincula qué rol tiene qué permisos
CREATE TABLE public.role_permissions (
    role_id INTEGER REFERENCES public.roles(id) ON DELETE CASCADE,
    permission_id INTEGER REFERENCES public.permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

-- Perfil extendido del usuario vinculado a auth.users de Supabase (Relación 1 a 1)
-- Implementa la regla de negocio: "Un solo rol por usuario"
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    role_id INTEGER REFERENCES public.roles(id) ON DELETE SET NULL,
    first_name TEXT,
    last_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ==============================================================================
-- 2. Core Security Function
-- ==============================================================================
-- Esta función será el corazón de nuestras políticas RLS. 
-- Verifica si el usuario autenticado tiene el permiso requerido para un módulo.
-- Es "SECURITY DEFINER" para poder leer las tablas de permisos ignorando las políticas RLS.
-- Es "STABLE" para que PostgreSQL cachee el resultado durante la misma consulta.

CREATE OR REPLACE FUNCTION public.has_permission(requested_module TEXT, requested_action TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM user_profiles up
    JOIN role_permissions rp ON up.role_id = rp.role_id
    JOIN permissions p ON rp.permission_id = p.id
    WHERE up.id = auth.uid()
      AND p.module = requested_module
      AND p.action = requested_action
  );
$$;

-- ==============================================================================
-- 3. Row Level Security (RLS)
-- ==============================================================================

ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.role_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- Los roles y permisos son de solo lectura para los usuarios normales
CREATE POLICY "Cualquiera puede ver los roles" ON public.roles
    FOR SELECT USING (true);

CREATE POLICY "Cualquiera puede ver los permisos" ON public.permissions
    FOR SELECT USING (true);

-- Un usuario solo puede ver su propio perfil
CREATE POLICY "Usuarios pueden ver su propio perfil" ON public.user_profiles
    FOR SELECT USING (auth.uid() = id);

-- ==============================================================================
-- 4. Inserción de Roles Iniciales (Basado en el documento de requerimientos)
-- ==============================================================================

INSERT INTO public.roles (name, description) VALUES
('Administrador del sistema', 'Configura usuarios, roles, catálogos, parámetros y plantillas.'),
('Responsable de contrato', 'Gestiona contrato, versiones, zonas, alcances, SLA e igualas.'),
('Coordinador operativo', 'Programa mantenimientos y administra capacidad de cuadrillas.'),
('Supervisor técnico', 'Controla calidad, desviaciones y competencia técnica.'),
('Técnico', 'Ejecuta mantenimientos y registra información de campo.'),
('Capturista central', 'Transcribe órdenes elaboradas en papel.'),
('Validador documental', 'Revisa integridad y consistencia del expediente.'),
('Responsable de refacciones', 'Administra catálogo, solicitudes, suministro y backlog.'),
('Compras', 'Gestiona proveedores, precios y abastecimiento.'),
('Responsable de gastos', 'Autoriza y revisa gasolina, viáticos y accesorios.'),
('Facturación', 'Integra expediente y emite factura.'),
('Cobranza', 'Da seguimiento a cuentas por cobrar y pagos.'),
('Gerencia', 'Consulta resultados operativos, económicos y de riesgo.'),
('Usuario del cliente', 'Perfil futuro para reportar, autorizar, consultar o aceptar.')
ON CONFLICT (name) DO NOTHING;
