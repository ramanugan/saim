-- ================================================================================
-- SAIM - SPRINT 4: ÓRDENES, EVIDENCIAS, REFACCIONES E INVENTARIO
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. CATÁLOGOS BASE (Unidad de Medida, Tipo de Equipo, Tipo Evidencia)
-- --------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS unidad_medida (
    id_unidad_medida BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    simbolo VARCHAR(10),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario),
    actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT REFERENCES usuario(id_usuario),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS tipo_equipo (
    id_tipo_equipo BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario),
    actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT REFERENCES usuario(id_usuario),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS tipo_evidencia (
    id_tipo_evidencia BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    permite_video BOOLEAN DEFAULT FALSE,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario),
    actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT REFERENCES usuario(id_usuario),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS categoria_refaccion (
    id_categoria_refaccion BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario),
    actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT REFERENCES usuario(id_usuario),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS proveedor (
    id_proveedor BIGSERIAL PRIMARY KEY,
    razon_social VARCHAR(150) NOT NULL,
    rfc VARCHAR(20),
    contacto VARCHAR(100),
    correo VARCHAR(100),
    telefono VARCHAR(20),
    tipo_proveedor VARCHAR(50),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario),
    actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT REFERENCES usuario(id_usuario),
    activo BOOLEAN DEFAULT TRUE
);

-- --------------------------------------------------------------------------------
-- 2. EQUIPOS, REFACCIONES Y ALMACÉN
-- --------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS equipo (
    id_equipo BIGSERIAL PRIMARY KEY,
    id_tienda BIGINT NOT NULL REFERENCES tienda(id_tienda),
    id_tipo_equipo BIGINT NOT NULL REFERENCES tipo_equipo(id_tipo_equipo),
    codigo_activo_cliente VARCHAR(100),
    marca VARCHAR(100),
    modelo VARCHAR(100),
    numero_serie VARCHAR(100),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario),
    actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT REFERENCES usuario(id_usuario),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS refaccion (
    id_refaccion BIGSERIAL PRIMARY KEY,
    id_categoria_refaccion BIGINT NOT NULL REFERENCES categoria_refaccion(id_categoria_refaccion),
    id_unidad_medida BIGINT NOT NULL REFERENCES unidad_medida(id_unidad_medida),
    codigo_interno VARCHAR(50) NOT NULL UNIQUE,
    descripcion_homologada VARCHAR(255) NOT NULL,
    marca VARCHAR(100),
    numero_parte VARCHAR(100),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario),
    actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT REFERENCES usuario(id_usuario),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS refaccion_alias (
    id_refaccion_alias BIGSERIAL PRIMARY KEY,
    id_refaccion BIGINT NOT NULL REFERENCES refaccion(id_refaccion),
    validado_por BIGINT REFERENCES usuario(id_usuario),
    alias VARCHAR(255) NOT NULL,
    origen VARCHAR(50),
    confianza_match DECIMAL(5,2),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS refaccion_compatibilidad (
    id_compatibilidad BIGSERIAL PRIMARY KEY,
    id_refaccion BIGINT NOT NULL REFERENCES refaccion(id_refaccion),
    id_tipo_equipo BIGINT NOT NULL REFERENCES tipo_equipo(id_tipo_equipo),
    marca_equipo VARCHAR(100),
    modelo_equipo VARCHAR(100),
    nivel_compatibilidad VARCHAR(50),
    observacion VARCHAR(255),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS proveedor_refaccion (
    id_proveedor_refaccion BIGSERIAL PRIMARY KEY,
    id_proveedor BIGINT NOT NULL REFERENCES proveedor(id_proveedor),
    id_refaccion BIGINT NOT NULL REFERENCES refaccion(id_refaccion),
    codigo_proveedor VARCHAR(100),
    plazo_entrega_dias INTEGER,
    es_preferente BOOLEAN DEFAULT FALSE,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS precio_refaccion (
    id_precio_refaccion BIGSERIAL PRIMARY KEY,
    id_refaccion BIGINT NOT NULL REFERENCES refaccion(id_refaccion),
    id_proveedor BIGINT NOT NULL REFERENCES proveedor(id_proveedor),
    tipo_precio VARCHAR(50),
    precio DECIMAL(12,2) NOT NULL,
    moneda CHAR(3) DEFAULT 'MXN',
    fecha_inicio DATE,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS almacen (
    id_almacen BIGSERIAL PRIMARY KEY,
    id_estado BIGINT REFERENCES estado(id_estado),
    id_municipio BIGINT REFERENCES municipio(id_municipio),
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(255),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario),
    actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT REFERENCES usuario(id_usuario),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS inventario_refaccion (
    id_inventario BIGSERIAL PRIMARY KEY,
    id_almacen BIGINT NOT NULL REFERENCES almacen(id_almacen),
    id_refaccion BIGINT NOT NULL REFERENCES refaccion(id_refaccion),
    existencia DECIMAL(10,2) DEFAULT 0,
    reservado DECIMAL(10,2) DEFAULT 0,
    disponible DECIMAL(10,2) GENERATED ALWAYS AS (existencia - reservado) STORED,
    stock_minimo DECIMAL(10,2) DEFAULT 0,
    actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS movimiento_inventario (
    id_movimiento BIGSERIAL PRIMARY KEY,
    id_almacen BIGINT NOT NULL REFERENCES almacen(id_almacen),
    id_refaccion BIGINT NOT NULL REFERENCES refaccion(id_refaccion),
    tipo_movimiento VARCHAR(20) NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    fecha_hora TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    referencia_entidad VARCHAR(100),
    registrado_por BIGINT REFERENCES usuario(id_usuario)
);

-- --------------------------------------------------------------------------------
-- 3. PLANTILLAS Y FORMATOS DE SERVICIO
-- --------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS formato_servicio (
    id_formato_servicio BIGSERIAL PRIMARY KEY,
    id_cliente BIGINT NOT NULL REFERENCES cliente(id_cliente),
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    tipo_mantenimiento VARCHAR(50),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario),
    actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT REFERENCES usuario(id_usuario),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS formato_version (
    id_formato_version BIGSERIAL PRIMARY KEY,
    id_formato_servicio BIGINT NOT NULL REFERENCES formato_servicio(id_formato_servicio),
    numero_version INTEGER NOT NULL,
    fecha_inicio_vigencia DATE NOT NULL,
    fecha_fin_vigencia DATE,
    logo_archivo VARCHAR(255),
    plantilla_pdf VARCHAR(255),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario)
);

CREATE TABLE IF NOT EXISTS formato_campo (
    id_formato_campo BIGSERIAL PRIMARY KEY,
    id_formato_version BIGINT NOT NULL REFERENCES formato_version(id_formato_version),
    seccion VARCHAR(100),
    codigo_campo VARCHAR(50) NOT NULL,
    etiqueta VARCHAR(255) NOT NULL,
    tipo_dato VARCHAR(50) NOT NULL,
    orden INTEGER,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS formato_requisito_firma (
    id_requisito_firma BIGSERIAL PRIMARY KEY,
    id_formato_version BIGINT NOT NULL REFERENCES formato_version(id_formato_version),
    codigo_rol_firmante VARCHAR(50) NOT NULL,
    etiqueta_puesto VARCHAR(100),
    obligatoria BOOLEAN DEFAULT TRUE,
    sello_obligatorio BOOLEAN DEFAULT FALSE,
    orden INTEGER
);

CREATE TABLE IF NOT EXISTS formato_requisito_evidencia (
    id_requisito_evidencia BIGSERIAL PRIMARY KEY,
    id_formato_version BIGINT NOT NULL REFERENCES formato_version(id_formato_version),
    tipo_evidencia VARCHAR(50),
    cantidad_minima INTEGER DEFAULT 1,
    momento VARCHAR(50),
    ubicacion_obligatoria BOOLEAN DEFAULT FALSE,
    observacion VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS tipo_medicion (
    id_tipo_medicion BIGSERIAL PRIMARY KEY,
    id_unidad_medida BIGINT NOT NULL REFERENCES unidad_medida(id_unidad_medida),
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    permite_set_point BOOLEAN DEFAULT FALSE,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------------------
-- 4. ÓRDENES DE SERVICIO (EL CORE DEL FRONTEND MÓVIL)
-- --------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS orden_servicio (
    id_orden_servicio BIGSERIAL PRIMARY KEY,
    id_servicio BIGINT NOT NULL REFERENCES servicio_mantenimiento(id_servicio),
    id_formato_version BIGINT REFERENCES formato_version(id_formato_version),
    id_tecnico_responsable BIGINT REFERENCES empleado(id_empleado),
    id_capturista BIGINT REFERENCES usuario(id_usuario),
    id_validador BIGINT REFERENCES usuario(id_usuario),
    folio_orden VARCHAR(100) NOT NULL UNIQUE,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario),
    actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT REFERENCES usuario(id_usuario),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS orden_equipo (
    id_orden_equipo BIGSERIAL PRIMARY KEY,
    id_orden_servicio BIGINT NOT NULL REFERENCES orden_servicio(id_orden_servicio),
    id_equipo BIGINT NOT NULL REFERENCES equipo(id_equipo),
    problema_especifico VARCHAR(255),
    resultado VARCHAR(100),
    observaciones TEXT,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orden_medicion (
    id_orden_medicion BIGSERIAL PRIMARY KEY,
    id_orden_equipo BIGINT NOT NULL REFERENCES orden_equipo(id_orden_equipo),
    id_tipo_medicion BIGINT NOT NULL REFERENCES tipo_medicion(id_tipo_medicion),
    id_unidad_medida BIGINT NOT NULL REFERENCES unidad_medida(id_unidad_medida),
    valor DECIMAL(12,4),
    valor_texto VARCHAR(255),
    set_point DECIMAL(12,4),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orden_actividad (
    id_orden_actividad BIGSERIAL PRIMARY KEY,
    id_orden_servicio BIGINT NOT NULL REFERENCES orden_servicio(id_orden_servicio),
    id_plan_actividad BIGINT REFERENCES plan_actividad(id_plan_actividad),
    descripcion VARCHAR(255),
    resultado VARCHAR(100),
    observacion TEXT,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orden_material (
    id_orden_material BIGSERIAL PRIMARY KEY,
    id_orden_servicio BIGINT NOT NULL REFERENCES orden_servicio(id_orden_servicio),
    id_refaccion BIGINT REFERENCES refaccion(id_refaccion),
    id_unidad_medida BIGINT REFERENCES unidad_medida(id_unidad_medida),
    descripcion_capturada VARCHAR(255),
    cantidad DECIMAL(10,2),
    costo_unitario DECIMAL(12,2),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orden_refaccion (
    id_orden_refaccion BIGSERIAL PRIMARY KEY,
    id_orden_servicio BIGINT NOT NULL REFERENCES orden_servicio(id_orden_servicio),
    id_equipo BIGINT REFERENCES equipo(id_equipo),
    id_refaccion BIGINT NOT NULL REFERENCES refaccion(id_refaccion),
    id_unidad_medida BIGINT NOT NULL REFERENCES unidad_medida(id_unidad_medida),
    descripcion_capturada VARCHAR(255),
    cantidad_necesaria DECIMAL(10,2),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orden_evidencia (
    id_evidencia BIGSERIAL PRIMARY KEY,
    id_orden_servicio BIGINT NOT NULL REFERENCES orden_servicio(id_orden_servicio),
    id_tipo_evidencia BIGINT REFERENCES tipo_evidencia(id_tipo_evidencia),
    nombre_archivo VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100),
    tamanio_bytes BIGINT,
    ruta_archivo VARCHAR(500) NOT NULL,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario)
);

CREATE TABLE IF NOT EXISTS orden_ubicacion (
    id_orden_ubicacion BIGSERIAL PRIMARY KEY,
    id_orden_servicio BIGINT NOT NULL REFERENCES orden_servicio(id_orden_servicio),
    tipo_evento VARCHAR(50),
    latitud DECIMAL(10,8),
    longitud DECIMAL(11,8),
    precision_metros DECIMAL(8,2),
    fecha_hora_dispositivo TIMESTAMP WITH TIME ZONE,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orden_firma (
    id_orden_firma BIGSERIAL PRIMARY KEY,
    id_orden_servicio BIGINT NOT NULL REFERENCES orden_servicio(id_orden_servicio),
    id_requisito_firma BIGINT REFERENCES formato_requisito_firma(id_requisito_firma),
    tipo_firmante VARCHAR(50),
    nombre_firmante VARCHAR(150),
    puesto_firmante VARCHAR(100),
    fecha_firma TIMESTAMP WITH TIME ZONE,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orden_validacion (
    id_validacion BIGSERIAL PRIMARY KEY,
    id_orden_servicio BIGINT NOT NULL REFERENCES orden_servicio(id_orden_servicio),
    id_validador BIGINT REFERENCES usuario(id_usuario),
    corregida_por BIGINT REFERENCES usuario(id_usuario),
    numero_revision INTEGER,
    fecha_revision TIMESTAMP WITH TIME ZONE,
    resultado VARCHAR(50),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orden_documento (
    id_orden_documento BIGSERIAL PRIMARY KEY,
    id_orden_servicio BIGINT NOT NULL REFERENCES orden_servicio(id_orden_servicio),
    tipo_documento VARCHAR(50),
    numero_version INTEGER,
    nombre_archivo VARCHAR(255),
    ruta_archivo VARCHAR(500),
    hash_sha256 CHAR(64),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------------------
-- 5. SOLICITUDES Y SUMINISTRO DE REFACCIONES
-- --------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS solicitud_refaccion (
    id_solicitud_refaccion BIGSERIAL PRIMARY KEY,
    id_iguala BIGINT NOT NULL REFERENCES iguala(id_iguala),
    id_orden_servicio BIGINT REFERENCES orden_servicio(id_orden_servicio),
    solicitado_por BIGINT NOT NULL REFERENCES empleado(id_empleado),
    folio VARCHAR(50) NOT NULL UNIQUE,
    fecha_solicitud TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    prioridad VARCHAR(20),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT REFERENCES usuario(id_usuario),
    actualizado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT REFERENCES usuario(id_usuario),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS solicitud_refaccion_detalle (
    id_solicitud_refaccion_detalle BIGSERIAL PRIMARY KEY,
    id_solicitud_refaccion BIGINT NOT NULL REFERENCES solicitud_refaccion(id_solicitud_refaccion),
    id_refaccion BIGINT NOT NULL REFERENCES refaccion(id_refaccion),
    id_equipo BIGINT REFERENCES equipo(id_equipo),
    descripcion_original VARCHAR(255),
    cantidad_necesaria DECIMAL(10,2) NOT NULL,
    cantidad_solicitada DECIMAL(10,2) NOT NULL,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS suministro_refaccion (
    id_suministro BIGSERIAL PRIMARY KEY,
    id_solicitud_refaccion BIGINT NOT NULL REFERENCES solicitud_refaccion(id_solicitud_refaccion),
    id_proveedor BIGINT REFERENCES proveedor(id_proveedor),
    id_almacen BIGINT REFERENCES almacen(id_almacen),
    fuente_suministro VARCHAR(50),
    fecha_suministro TIMESTAMP WITH TIME ZONE,
    documento_referencia VARCHAR(100),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS suministro_refaccion_detalle (
    id_suministro_detalle BIGSERIAL PRIMARY KEY,
    id_suministro BIGINT NOT NULL REFERENCES suministro_refaccion(id_suministro),
    id_solicitud_refaccion_detalle BIGINT NOT NULL REFERENCES solicitud_refaccion_detalle(id_solicitud_refaccion_detalle),
    cantidad_entregada DECIMAL(10,2) NOT NULL,
    cantidad_rechazada DECIMAL(10,2) DEFAULT 0,
    motivo_rechazo VARCHAR(255),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS instalacion_refaccion (
    id_instalacion BIGSERIAL PRIMARY KEY,
    id_solicitud_refaccion_detalle BIGINT NOT NULL REFERENCES solicitud_refaccion_detalle(id_solicitud_refaccion_detalle),
    id_orden_servicio BIGINT REFERENCES orden_servicio(id_orden_servicio),
    id_equipo BIGINT REFERENCES equipo(id_equipo),
    cantidad_instalada DECIMAL(10,2) NOT NULL,
    fecha_instalacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    resultado_prueba VARCHAR(100),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
