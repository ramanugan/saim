-- Script SQL Generado para Sprint 2: Contratos e Igualas

CREATE TABLE IF NOT EXISTS cliente (
    id_cliente BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(30) NOT NULL,
    razon_social VARCHAR(220) NOT NULL,
    nombre_comercial VARCHAR(160) NOT NULL,
    rfc VARCHAR(20) NULL,
    correo_contacto VARCHAR(200) NULL,
    telefono_contacto VARCHAR(30) NULL,
    estatus VARCHAR(30) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_cliente)
);

CREATE TABLE IF NOT EXISTS contrato (
    id_contrato BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_cliente BIGINT NOT NULL,
    numero_contrato VARCHAR(100) NOT NULL,
    nombre VARCHAR(220) NOT NULL,
    fecha_firma DATE NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    moneda CHAR(3) NOT NULL,
    monto_global DECIMAL(18,2) NULL,
    periodicidad_facturacion VARCHAR(30) NOT NULL,
    estatus VARCHAR(30) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_contrato)
);

CREATE TABLE IF NOT EXISTS contrato_version (
    id_contrato_version BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_contrato BIGINT NOT NULL,
    numero_version INTEGER NOT NULL,
    fecha_inicio_vigencia DATE NOT NULL,
    fecha_fin_vigencia DATE NULL,
    motivo_version VARCHAR(500) NOT NULL,
    estatus VARCHAR(30) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_contrato_version)
);

CREATE TABLE IF NOT EXISTS contrato_documento (
    id_contrato_documento BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_contrato_version BIGINT NOT NULL,
    tipo_documento VARCHAR(50) NOT NULL,
    nombre_archivo VARCHAR(255) NOT NULL,
    ruta_archivo VARCHAR(500) NOT NULL,
    hash_sha256 CHAR(64) NOT NULL,
    fecha_documento DATE NULL,
    es_vigente BOOLEAN NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_contrato_documento)
);

CREATE TABLE IF NOT EXISTS contrato_alcance (
    id_contrato_alcance BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_contrato_version BIGINT NOT NULL,
    id_zona_contrato BIGINT NULL,
    id_tipo_servicio BIGINT NULL,
    clasificacion VARCHAR(30) NOT NULL,
    concepto VARCHAR(250) NOT NULL,
    descripcion TEXT NOT NULL,
    limite_economico DECIMAL(18,2) NULL,
    requiere_autorizacion BOOLEAN NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_contrato_alcance)
);

CREATE TABLE IF NOT EXISTS contrato_sla (
    id_contrato_sla BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_contrato_version BIGINT NOT NULL,
    id_zona_contrato BIGINT NULL,
    prioridad VARCHAR(20) NOT NULL,
    horario_cobertura VARCHAR(120) NOT NULL,
    minutos_respuesta INTEGER NOT NULL,
    minutos_llegada INTEGER NULL,
    minutos_solucion_objetivo INTEGER NULL,
    regla_escalamiento TEXT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_contrato_sla)
);

CREATE TABLE IF NOT EXISTS zona_contrato (
    id_zona_contrato BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_contrato_version BIGINT NOT NULL,
    codigo VARCHAR(40) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion VARCHAR(500) NULL,
    coordinador_responsable BIGINT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_zona_contrato)
);

CREATE TABLE IF NOT EXISTS zona_estado (
    id_zona_estado BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_zona_contrato BIGINT NOT NULL,
    id_estado BIGINT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    es_excepcion BOOLEAN NOT NULL,
    justificacion VARCHAR(500) NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_zona_estado)
);

CREATE TABLE IF NOT EXISTS tienda (
    id_tienda BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_cliente BIGINT NOT NULL,
    id_tipo_tienda BIGINT NOT NULL,
    id_estado BIGINT NOT NULL,
    id_municipio BIGINT NOT NULL,
    determinante VARCHAR(30) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    direccion VARCHAR(500) NULL,
    codigo_postal VARCHAR(12) NULL,
    latitud DECIMAL(10,7) NULL,
    longitud DECIMAL(10,7) NULL,
    telefono VARCHAR(30) NULL,
    estatus VARCHAR(30) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_tienda)
);

CREATE TABLE IF NOT EXISTS zona_tienda (
    id_zona_tienda BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_zona_contrato BIGINT NOT NULL,
    id_tienda BIGINT NOT NULL,
    fecha_inicio_cobertura DATE NOT NULL,
    fecha_fin_cobertura DATE NULL,
    numero_anexo VARCHAR(100) NULL,
    id_documento_inclusion BIGINT NULL,
    estatus VARCHAR(30) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_zona_tienda)
);

CREATE TABLE IF NOT EXISTS iguala (
    id_iguala BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_zona_tienda BIGINT NOT NULL,
    codigo_iguala VARCHAR(60) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estatus VARCHAR(30) NOT NULL,
    motivo_baja VARCHAR(500) NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_iguala)
);

CREATE TABLE IF NOT EXISTS iguala_servicio (
    id_iguala_servicio BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_iguala BIGINT NOT NULL,
    id_tipo_servicio BIGINT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    es_principal BOOLEAN NOT NULL,
    alcance_particular TEXT NULL,
    estatus VARCHAR(30) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_iguala_servicio)
);

CREATE TABLE IF NOT EXISTS iguala_condicion (
    id_iguala_condicion BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_iguala BIGINT NOT NULL,
    id_iguala_servicio BIGINT NULL,
    fecha_inicio_vigencia DATE NOT NULL,
    fecha_fin_vigencia DATE NULL,
    periodicidad_preventivo VARCHAR(30) NOT NULL,
    periodicidad_facturacion VARCHAR(30) NOT NULL,
    monto_periodico DECIMAL(18,2) NOT NULL,
    moneda CHAR(3) NOT NULL,
    duracion_estandar_minutos INTEGER NOT NULL,
    numero_jornadas INTEGER NOT NULL,
    horas_por_jornada DECIMAL(5,2) NOT NULL,
    tecnicos_minimos INTEGER NOT NULL,
    tecnicos_objetivo INTEGER NOT NULL,
    tolerancia_desviacion_pct DECIMAL(5,2) NOT NULL,
    incluye_diagnostico_correctivo BOOLEAN NOT NULL,
    limite_correctivo_incluido DECIMAL(18,2) NULL,
    alcance_particular TEXT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_iguala_condicion)
);

-- Llaves Foráneas (Sprint 2)

ALTER TABLE cliente ADD CONSTRAINT fk_cliente_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE cliente ADD CONSTRAINT fk_cliente_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE contrato ADD CONSTRAINT fk_contrato_id_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente);
ALTER TABLE contrato ADD CONSTRAINT fk_contrato_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE contrato ADD CONSTRAINT fk_contrato_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE contrato_version ADD CONSTRAINT fk_contrato_version_id_contrato FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato);
ALTER TABLE contrato_version ADD CONSTRAINT fk_contrato_version_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE contrato_version ADD CONSTRAINT fk_contrato_version_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE contrato_documento ADD CONSTRAINT fk_contrato_documento_id_contrato_version FOREIGN KEY (id_contrato_version) REFERENCES contrato_version(id_contrato_version);
ALTER TABLE contrato_documento ADD CONSTRAINT fk_contrato_documento_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE contrato_documento ADD CONSTRAINT fk_contrato_documento_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE contrato_alcance ADD CONSTRAINT fk_contrato_alcance_id_contrato_version FOREIGN KEY (id_contrato_version) REFERENCES contrato_version(id_contrato_version);
ALTER TABLE contrato_alcance ADD CONSTRAINT fk_contrato_alcance_id_zona_contrato FOREIGN KEY (id_zona_contrato) REFERENCES zona_contrato(id_zona_contrato);
ALTER TABLE contrato_alcance ADD CONSTRAINT fk_contrato_alcance_id_tipo_servicio FOREIGN KEY (id_tipo_servicio) REFERENCES tipo_servicio(id_tipo_servicio);
ALTER TABLE contrato_alcance ADD CONSTRAINT fk_contrato_alcance_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE contrato_alcance ADD CONSTRAINT fk_contrato_alcance_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE contrato_sla ADD CONSTRAINT fk_contrato_sla_id_contrato_version FOREIGN KEY (id_contrato_version) REFERENCES contrato_version(id_contrato_version);
ALTER TABLE contrato_sla ADD CONSTRAINT fk_contrato_sla_id_zona_contrato FOREIGN KEY (id_zona_contrato) REFERENCES zona_contrato(id_zona_contrato);
ALTER TABLE contrato_sla ADD CONSTRAINT fk_contrato_sla_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE contrato_sla ADD CONSTRAINT fk_contrato_sla_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE zona_contrato ADD CONSTRAINT fk_zona_contrato_id_contrato_version FOREIGN KEY (id_contrato_version) REFERENCES contrato_version(id_contrato_version);
ALTER TABLE zona_contrato ADD CONSTRAINT fk_zona_contrato_coordinador_responsable FOREIGN KEY (coordinador_responsable) REFERENCES empleado(id_empleado);
ALTER TABLE zona_contrato ADD CONSTRAINT fk_zona_contrato_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE zona_contrato ADD CONSTRAINT fk_zona_contrato_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE zona_estado ADD CONSTRAINT fk_zona_estado_id_zona_contrato FOREIGN KEY (id_zona_contrato) REFERENCES zona_contrato(id_zona_contrato);
ALTER TABLE zona_estado ADD CONSTRAINT fk_zona_estado_id_estado FOREIGN KEY (id_estado) REFERENCES estado(id_estado);
ALTER TABLE zona_estado ADD CONSTRAINT fk_zona_estado_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE zona_estado ADD CONSTRAINT fk_zona_estado_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE tienda ADD CONSTRAINT fk_tienda_id_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente);
ALTER TABLE tienda ADD CONSTRAINT fk_tienda_id_tipo_tienda FOREIGN KEY (id_tipo_tienda) REFERENCES tipo_tienda(id_tipo_tienda);
ALTER TABLE tienda ADD CONSTRAINT fk_tienda_id_estado FOREIGN KEY (id_estado) REFERENCES estado(id_estado);
ALTER TABLE tienda ADD CONSTRAINT fk_tienda_id_municipio FOREIGN KEY (id_municipio) REFERENCES municipio(id_municipio);
ALTER TABLE tienda ADD CONSTRAINT fk_tienda_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE tienda ADD CONSTRAINT fk_tienda_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE zona_tienda ADD CONSTRAINT fk_zona_tienda_id_zona_contrato FOREIGN KEY (id_zona_contrato) REFERENCES zona_contrato(id_zona_contrato);
ALTER TABLE zona_tienda ADD CONSTRAINT fk_zona_tienda_id_tienda FOREIGN KEY (id_tienda) REFERENCES tienda(id_tienda);
ALTER TABLE zona_tienda ADD CONSTRAINT fk_zona_tienda_id_documento_inclusion FOREIGN KEY (id_documento_inclusion) REFERENCES contrato_documento(id_contrato_documento);
ALTER TABLE zona_tienda ADD CONSTRAINT fk_zona_tienda_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE zona_tienda ADD CONSTRAINT fk_zona_tienda_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE iguala ADD CONSTRAINT fk_iguala_id_zona_tienda FOREIGN KEY (id_zona_tienda) REFERENCES zona_tienda(id_zona_tienda);
ALTER TABLE iguala ADD CONSTRAINT fk_iguala_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE iguala ADD CONSTRAINT fk_iguala_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE iguala_servicio ADD CONSTRAINT fk_iguala_servicio_id_iguala FOREIGN KEY (id_iguala) REFERENCES iguala(id_iguala);
ALTER TABLE iguala_servicio ADD CONSTRAINT fk_iguala_servicio_id_tipo_servicio FOREIGN KEY (id_tipo_servicio) REFERENCES tipo_servicio(id_tipo_servicio);
ALTER TABLE iguala_servicio ADD CONSTRAINT fk_iguala_servicio_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE iguala_servicio ADD CONSTRAINT fk_iguala_servicio_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE iguala_condicion ADD CONSTRAINT fk_iguala_condicion_id_iguala FOREIGN KEY (id_iguala) REFERENCES iguala(id_iguala);
ALTER TABLE iguala_condicion ADD CONSTRAINT fk_iguala_condicion_id_iguala_servicio FOREIGN KEY (id_iguala_servicio) REFERENCES iguala_servicio(id_iguala_servicio);
ALTER TABLE iguala_condicion ADD CONSTRAINT fk_iguala_condicion_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE iguala_condicion ADD CONSTRAINT fk_iguala_condicion_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);

-- Llaves Foráneas rezagadas de Sprint 1 hacia Sprint 2
ALTER TABLE usuario_rol ADD CONSTRAINT fk_usuario_rol_ambito_cliente FOREIGN KEY (ambito_cliente) REFERENCES cliente(id_cliente);
ALTER TABLE usuario_rol ADD CONSTRAINT fk_usuario_rol_ambito_zona FOREIGN KEY (ambito_zona) REFERENCES zona_contrato(id_zona_contrato);