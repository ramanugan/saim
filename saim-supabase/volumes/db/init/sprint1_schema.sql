-- Script SQL Generado para Sprint 1: Seguridad y Catálogos

CREATE TABLE IF NOT EXISTS organizacion_proveedora (
    id_organizacion BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    razon_social VARCHAR(200) NOT NULL,
    nombre_comercial VARCHAR(150) NULL,
    rfc VARCHAR(20) NOT NULL,
    domicilio_fiscal VARCHAR(500) NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_organizacion)
);

CREATE TABLE IF NOT EXISTS usuario (
    id_usuario BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_empleado BIGINT NULL,
    nombre_usuario VARCHAR(100) NOT NULL,
    correo VARCHAR(200) NOT NULL,
    hash_contrasena VARCHAR(255) NOT NULL,
    estado_cuenta VARCHAR(30) NOT NULL,
    ultimo_acceso TIMESTAMP NULL,
    requiere_mfa BOOLEAN NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_usuario)
);

CREATE TABLE IF NOT EXISTS rol (
    id_rol BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(50) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    descripcion VARCHAR(500) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_rol)
);

CREATE TABLE IF NOT EXISTS usuario_rol (
    id_usuario_rol BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_rol BIGINT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    ambito_cliente BIGINT NULL,
    ambito_zona BIGINT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_usuario_rol)
);

CREATE TABLE IF NOT EXISTS bitacora_auditoria (
    id_bitacora BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_usuario BIGINT NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    accion VARCHAR(50) NOT NULL,
    entidad VARCHAR(100) NOT NULL,
    id_registro VARCHAR(100) NOT NULL,
    valor_anterior JSON NULL,
    valor_nuevo JSON NULL,
    motivo VARCHAR(500) NULL,
    direccion_ip VARCHAR(64) NULL,
    dispositivo VARCHAR(300) NULL,
    PRIMARY KEY (id_bitacora)
);

CREATE TABLE IF NOT EXISTS empleado (
    id_empleado BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    numero_empleado VARCHAR(30) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100) NULL,
    telefono VARCHAR(30) NULL,
    correo VARCHAR(200) NULL,
    puesto VARCHAR(120) NOT NULL,
    tipo_empleado VARCHAR(40) NOT NULL,
    fecha_ingreso DATE NOT NULL,
    estado_laboral VARCHAR(30) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_empleado)
);

CREATE TABLE IF NOT EXISTS especialidad (
    id_especialidad BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(50) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    requiere_certificacion BOOLEAN NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_especialidad)
);

CREATE TABLE IF NOT EXISTS empleado_especialidad (
    id_empleado_especialidad BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_empleado BIGINT NOT NULL,
    id_especialidad BIGINT NOT NULL,
    nivel VARCHAR(30) NOT NULL,
    numero_certificado VARCHAR(100) NULL,
    vigencia_hasta DATE NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_empleado_especialidad)
);

CREATE TABLE IF NOT EXISTS pais (
    id_pais BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo_iso CHAR(3) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_pais)
);

CREATE TABLE IF NOT EXISTS estado (
    id_estado BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_pais BIGINT NOT NULL,
    clave_inegi VARCHAR(5) NULL,
    nombre VARCHAR(120) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_estado)
);

CREATE TABLE IF NOT EXISTS municipio (
    id_municipio BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_estado BIGINT NOT NULL,
    clave_inegi VARCHAR(10) NULL,
    nombre VARCHAR(160) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_municipio)
);

CREATE TABLE IF NOT EXISTS tipo_tienda (
    id_tipo_tienda BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(30) NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    descripcion VARCHAR(300) NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_tipo_tienda)
);

CREATE TABLE IF NOT EXISTS tipo_servicio (
    id_tipo_servicio BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(40) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    descripcion VARCHAR(300) NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_tipo_servicio)
);

CREATE TABLE IF NOT EXISTS unidad_medida (
    id_unidad_medida BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    simbolo VARCHAR(20) NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_unidad_medida)
);

-- Llaves Foráneas

ALTER TABLE organizacion_proveedora ADD CONSTRAINT fk_organizacion_proveedora_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE organizacion_proveedora ADD CONSTRAINT fk_organizacion_proveedora_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE usuario ADD CONSTRAINT fk_usuario_id_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado);
ALTER TABLE usuario ADD CONSTRAINT fk_usuario_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE usuario ADD CONSTRAINT fk_usuario_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE rol ADD CONSTRAINT fk_rol_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE rol ADD CONSTRAINT fk_rol_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE usuario_rol ADD CONSTRAINT fk_usuario_rol_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario);
ALTER TABLE usuario_rol ADD CONSTRAINT fk_usuario_rol_id_rol FOREIGN KEY (id_rol) REFERENCES rol(id_rol);
-- SKIPPED: ALTER TABLE usuario_rol ADD CONSTRAINT fk_usuario_rol_ambito_cliente FOREIGN KEY (ambito_cliente) REFERENCES cliente(id_cliente); -- cliente no está en Sprint 1
-- SKIPPED: ALTER TABLE usuario_rol ADD CONSTRAINT fk_usuario_rol_ambito_zona FOREIGN KEY (ambito_zona) REFERENCES zona_contrato(id_zona_contrato); -- zona_contrato no está en Sprint 1
ALTER TABLE usuario_rol ADD CONSTRAINT fk_usuario_rol_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE usuario_rol ADD CONSTRAINT fk_usuario_rol_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE empleado ADD CONSTRAINT fk_empleado_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE empleado ADD CONSTRAINT fk_empleado_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE especialidad ADD CONSTRAINT fk_especialidad_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE especialidad ADD CONSTRAINT fk_especialidad_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE empleado_especialidad ADD CONSTRAINT fk_empleado_especialidad_id_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado);
ALTER TABLE empleado_especialidad ADD CONSTRAINT fk_empleado_especialidad_id_especialidad FOREIGN KEY (id_especialidad) REFERENCES especialidad(id_especialidad);
ALTER TABLE empleado_especialidad ADD CONSTRAINT fk_empleado_especialidad_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE empleado_especialidad ADD CONSTRAINT fk_empleado_especialidad_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE bitacora_auditoria ADD CONSTRAINT fk_bitacora_auditoria_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario);
ALTER TABLE pais ADD CONSTRAINT fk_pais_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE pais ADD CONSTRAINT fk_pais_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE estado ADD CONSTRAINT fk_estado_id_pais FOREIGN KEY (id_pais) REFERENCES pais(id_pais);
ALTER TABLE estado ADD CONSTRAINT fk_estado_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE estado ADD CONSTRAINT fk_estado_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE municipio ADD CONSTRAINT fk_municipio_id_estado FOREIGN KEY (id_estado) REFERENCES estado(id_estado);
ALTER TABLE municipio ADD CONSTRAINT fk_municipio_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE municipio ADD CONSTRAINT fk_municipio_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE tipo_tienda ADD CONSTRAINT fk_tipo_tienda_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE tipo_tienda ADD CONSTRAINT fk_tipo_tienda_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE tipo_servicio ADD CONSTRAINT fk_tipo_servicio_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE tipo_servicio ADD CONSTRAINT fk_tipo_servicio_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
ALTER TABLE unidad_medida ADD CONSTRAINT fk_unidad_medida_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE unidad_medida ADD CONSTRAINT fk_unidad_medida_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);