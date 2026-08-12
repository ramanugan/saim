-- ================================================================================
-- SAIM - SPRINT 5: CORRECTIVOS, FINANZAS, GASTOS Y RECURSOS
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. SOLICITUDES Y SERVICIOS CORRECTIVOS
-- --------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS solicitud_correctivo (
    id_solicitud_correctivo BIGSERIAL PRIMARY KEY,
    id_iguala BIGINT NOT NULL REFERENCES iguala(id_iguala),
    id_equipo BIGINT REFERENCES equipo(id_equipo),
    id_orden_origen BIGINT REFERENCES orden_servicio(id_orden_servicio),
    folio_cliente VARCHAR(50),
    fecha_hora_solicitud TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    solicitante_nombre VARCHAR(150),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario),
    actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT REFERENCES usuario(id_usuario),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS servicio_correctivo (
    id_servicio_correctivo BIGSERIAL PRIMARY KEY,
    id_servicio BIGINT NOT NULL REFERENCES servicio_mantenimiento(id_servicio),
    id_solicitud_correctivo BIGINT REFERENCES solicitud_correctivo(id_solicitud_correctivo),
    resultado_cobertura VARCHAR(50),
    fundamento_contractual TEXT,
    requiere_cotizacion BOOLEAN DEFAULT TRUE,
    monto_estimado DECIMAL(12,2),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS servicio_relacion (
    id_servicio_relacion BIGSERIAL PRIMARY KEY,
    id_servicio_origen BIGINT NOT NULL REFERENCES servicio_mantenimiento(id_servicio),
    id_servicio_destino BIGINT NOT NULL REFERENCES servicio_mantenimiento(id_servicio),
    tipo_relacion VARCHAR(50) NOT NULL,
    observacion VARCHAR(255),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------------------
-- 2. PROYECTOS, COTIZACIONES Y AUTORIZACIONES (CORRECTIVOS Y BACKLOG)
-- --------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS proyecto_correctivo (
    id_proyecto_correctivo BIGSERIAL PRIMARY KEY,
    id_servicio_correctivo BIGINT NOT NULL REFERENCES servicio_correctivo(id_servicio_correctivo),
    folio_proyecto VARCHAR(50) NOT NULL UNIQUE,
    titulo VARCHAR(200) NOT NULL,
    alcance TEXT,
    complejidad VARCHAR(50),
    fecha_inicio_planeada DATE,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS hito_proyecto (
    id_hito BIGSERIAL PRIMARY KEY,
    id_proyecto_correctivo BIGINT NOT NULL REFERENCES proyecto_correctivo(id_proyecto_correctivo),
    tipo_hito VARCHAR(50),
    fecha_hora TIMESTAMP WITH TIME ZONE,
    responsable VARCHAR(100),
    evidencia VARCHAR(255),
    comentario VARCHAR(255),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cotizacion (
    id_cotizacion BIGSERIAL PRIMARY KEY,
    id_servicio_correctivo BIGINT NOT NULL REFERENCES servicio_correctivo(id_servicio_correctivo),
    numero_cotizacion VARCHAR(50) NOT NULL UNIQUE,
    version INTEGER DEFAULT 1,
    fecha_emision DATE,
    vigencia_hasta DATE,
    subtotal DECIMAL(12,2),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario)
);

CREATE TABLE IF NOT EXISTS cotizacion_detalle (
    id_cotizacion_detalle BIGSERIAL PRIMARY KEY,
    id_cotizacion BIGINT NOT NULL REFERENCES cotizacion(id_cotizacion),
    id_unidad_medida BIGINT REFERENCES unidad_medida(id_unidad_medida),
    numero_partida INTEGER NOT NULL,
    tipo_concepto VARCHAR(50),
    descripcion VARCHAR(255),
    cantidad DECIMAL(10,2),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- (Pendiente de Sprint 4) Oportunidad de Suministro vinculada a Cotización
CREATE TABLE IF NOT EXISTS oportunidad_suministro (
    id_oportunidad BIGSERIAL PRIMARY KEY,
    id_solicitud_refaccion_detalle BIGINT NOT NULL REFERENCES solicitud_refaccion_detalle(id_solicitud_refaccion_detalle),
    id_cotizacion BIGINT REFERENCES cotizacion(id_cotizacion),
    fecha_deteccion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(150),
    cantidad_ofertable DECIMAL(10,2),
    monto_estimado DECIMAL(12,2),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS autorizacion_correctivo (
    id_autorizacion BIGSERIAL PRIMARY KEY,
    id_cotizacion BIGINT NOT NULL REFERENCES cotizacion(id_cotizacion),
    autorizado_por_nombre VARCHAR(150),
    autorizado_por_puesto VARCHAR(100),
    fecha_hora_autorizacion TIMESTAMP WITH TIME ZONE,
    monto_autorizado DECIMAL(12,2),
    alcance_autorizado TEXT,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cambio_alcance (
    id_cambio_alcance BIGSERIAL PRIMARY KEY,
    id_proyecto_correctivo BIGINT NOT NULL REFERENCES proyecto_correctivo(id_proyecto_correctivo),
    id_autorizacion BIGINT REFERENCES autorizacion_correctivo(id_autorizacion),
    numero_cambio INTEGER,
    fecha_solicitud TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    descripcion TEXT,
    monto_adicional DECIMAL(12,2),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------------------
-- 3. FINANZAS: PEDIDOS, FACTURAS Y PAGOS
-- --------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS pedido_cliente (
    id_pedido_cliente BIGSERIAL PRIMARY KEY,
    id_servicio_correctivo BIGINT REFERENCES servicio_correctivo(id_servicio_correctivo),
    numero_pedido VARCHAR(50) NOT NULL UNIQUE,
    fecha_emision DATE,
    monto DECIMAL(12,2),
    moneda CHAR(3) DEFAULT 'MXN',
    documento VARCHAR(255),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS factura (
    id_factura BIGSERIAL PRIMARY KEY,
    id_servicio_correctivo BIGINT REFERENCES servicio_correctivo(id_servicio_correctivo),
    id_pedido_cliente BIGINT REFERENCES pedido_cliente(id_pedido_cliente),
    serie VARCHAR(20),
    folio VARCHAR(20),
    uuid_fiscal CHAR(36),
    fecha_emision TIMESTAMP WITH TIME ZONE,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS pago (
    id_pago BIGSERIAL PRIMARY KEY,
    id_cliente BIGINT NOT NULL REFERENCES cliente(id_cliente),
    fecha_pago DATE NOT NULL,
    referencia VARCHAR(100),
    metodo_pago VARCHAR(50),
    monto DECIMAL(12,2) NOT NULL,
    moneda CHAR(3) DEFAULT 'MXN',
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS aplicacion_pago (
    id_aplicacion_pago BIGSERIAL PRIMARY KEY,
    id_pago BIGINT NOT NULL REFERENCES pago(id_pago),
    id_factura BIGINT NOT NULL REFERENCES factura(id_factura),
    monto_aplicado DECIMAL(12,2) NOT NULL,
    fecha_aplicacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tarea_cobranza (
    id_tarea_cobranza BIGSERIAL PRIMARY KEY,
    id_factura BIGINT REFERENCES factura(id_factura),
    id_servicio_correctivo BIGINT REFERENCES servicio_correctivo(id_servicio_correctivo),
    id_responsable BIGINT REFERENCES empleado(id_empleado),
    tipo_tarea VARCHAR(50),
    fecha_objetivo DATE,
    estado VARCHAR(50),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------------------
-- 4. RECURSOS Y GASTOS (VIÁTICOS, COMBUSTIBLE, ACTIVOS)
-- --------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS tipo_gasto (
    id_tipo_gasto BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    requiere_comprobante BOOLEAN DEFAULT TRUE,
    requiere_autorizacion BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS solicitud_recurso (
    id_solicitud_recurso BIGSERIAL PRIMARY KEY,
    id_empleado_solicita BIGINT NOT NULL REFERENCES empleado(id_empleado),
    id_tipo_gasto BIGINT NOT NULL REFERENCES tipo_gasto(id_tipo_gasto),
    id_servicio BIGINT REFERENCES servicio_mantenimiento(id_servicio),
    id_zona_contrato BIGINT REFERENCES zona_contrato(id_zona_contrato),
    fecha_solicitud TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    monto_solicitado DECIMAL(12,2),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS autorizacion_recurso (
    id_autorizacion_recurso BIGSERIAL PRIMARY KEY,
    id_solicitud_recurso BIGINT NOT NULL REFERENCES solicitud_recurso(id_solicitud_recurso),
    id_usuario_autoriza BIGINT NOT NULL REFERENCES usuario(id_usuario),
    fecha_autorizacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    monto_autorizado DECIMAL(12,2),
    resultado VARCHAR(50),
    condiciones VARCHAR(255),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS anticipo (
    id_anticipo BIGSERIAL PRIMARY KEY,
    id_solicitud_recurso BIGINT NOT NULL REFERENCES solicitud_recurso(id_solicitud_recurso),
    id_empleado BIGINT NOT NULL REFERENCES empleado(id_empleado),
    fecha_entrega DATE,
    monto_entregado DECIMAL(12,2),
    monto_comprobado DECIMAL(12,2) DEFAULT 0,
    saldo_devolver DECIMAL(12,2) GENERATED ALWAYS AS (monto_entregado - monto_comprobado) STORED,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS gasto (
    id_gasto BIGSERIAL PRIMARY KEY,
    id_tipo_gasto BIGINT NOT NULL REFERENCES tipo_gasto(id_tipo_gasto),
    id_empleado BIGINT NOT NULL REFERENCES empleado(id_empleado),
    id_anticipo BIGINT REFERENCES anticipo(id_anticipo),
    fecha_hora TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    proveedor_nombre VARCHAR(150),
    importe DECIMAL(12,2) NOT NULL,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS gasto_comprobante (
    id_gasto_comprobante BIGSERIAL PRIMARY KEY,
    id_gasto BIGINT NOT NULL REFERENCES gasto(id_gasto),
    tipo_documento VARCHAR(50),
    nombre_archivo VARCHAR(255),
    ruta_archivo VARCHAR(500),
    hash_sha256 CHAR(64),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS gasto_aplicacion (
    id_gasto_aplicacion BIGSERIAL PRIMARY KEY,
    id_gasto BIGINT NOT NULL REFERENCES gasto(id_gasto),
    tipo_destino VARCHAR(50),
    id_destino BIGINT,
    monto_aplicado DECIMAL(12,2),
    porcentaje DECIMAL(5,2),
    criterio_prorrateo VARCHAR(100),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS vehiculo (
    id_vehiculo BIGSERIAL PRIMARY KEY,
    numero_economico VARCHAR(50) NOT NULL UNIQUE,
    placas VARCHAR(20) NOT NULL,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    anio INTEGER,
    capacidad_tanque_litros DECIMAL(10,2),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS carga_combustible (
    id_carga_combustible BIGSERIAL PRIMARY KEY,
    id_gasto BIGINT NOT NULL REFERENCES gasto(id_gasto),
    id_vehiculo BIGINT NOT NULL REFERENCES vehiculo(id_vehiculo),
    id_conductor BIGINT REFERENCES empleado(id_empleado),
    litros DECIMAL(10,2) NOT NULL,
    precio_litro DECIMAL(10,2),
    importe_calculado DECIMAL(12,2),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS activo_accesorio (
    id_activo_accesorio BIGSERIAL PRIMARY KEY,
    codigo_activo VARCHAR(50) NOT NULL UNIQUE,
    tipo_activo VARCHAR(50),
    descripcion VARCHAR(255),
    marca VARCHAR(100),
    numero_serie VARCHAR(100),
    estado_fisico VARCHAR(50),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS custodia_activo (
    id_custodia BIGSERIAL PRIMARY KEY,
    id_activo_accesorio BIGINT NOT NULL REFERENCES activo_accesorio(id_activo_accesorio),
    id_empleado BIGINT NOT NULL REFERENCES empleado(id_empleado),
    id_servicio BIGINT REFERENCES servicio_mantenimiento(id_servicio),
    fecha_entrega TIMESTAMP WITH TIME ZONE,
    fecha_devolucion TIMESTAMP WITH TIME ZONE,
    estado_entrega VARCHAR(50),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
