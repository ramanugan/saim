-- Script SQL Generado para Sprint 3: Cuadrillas y Planes Preventivos

CREATE TABLE IF NOT EXISTS cuadrilla (
    id_cuadrilla BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_zona_contrato BIGINT NOT NULL,
    codigo VARCHAR(40) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    estatus VARCHAR(30) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_cuadrilla)
);

CREATE TABLE IF NOT EXISTS cuadrilla_miembro (
    id_cuadrilla_miembro BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_cuadrilla BIGINT NOT NULL,
    id_empleado BIGINT NOT NULL,
    rol_cuadrilla VARCHAR(50) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_cuadrilla_miembro)
);

CREATE TABLE IF NOT EXISTS plan_mantenimiento (
    id_plan_mantenimiento BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_iguala BIGINT NOT NULL,
    id_iguala_servicio BIGINT NULL,
    id_iguala_condicion BIGINT NULL,
    nombre VARCHAR(200) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_plan_mantenimiento)
);

CREATE TABLE IF NOT EXISTS plan_actividad (
    id_plan_actividad BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_plan_mantenimiento BIGINT NOT NULL,
    orden INTEGER NOT NULL,
    codigo VARCHAR(40) NOT NULL,
    descripcion VARCHAR(500) NOT NULL,
    obligatoria BOOLEAN NOT NULL DEFAULT TRUE,
    requiere_evidencia BOOLEAN NOT NULL DEFAULT FALSE,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_plan_actividad)
);

CREATE TABLE IF NOT EXISTS servicio_mantenimiento (
    id_servicio BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_iguala BIGINT NULL,
    id_iguala_servicio BIGINT NULL,
    tipo_mantenimiento VARCHAR(50) NOT NULL,
    folio_interno VARCHAR(100) NOT NULL,
    origen VARCHAR(50) NOT NULL,
    prioridad VARCHAR(30) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_servicio)
);

CREATE TABLE IF NOT EXISTS servicio_preventivo (
    id_servicio_preventivo BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_servicio BIGINT NOT NULL,
    id_plan_mantenimiento BIGINT NOT NULL,
    periodo VARCHAR(50) NOT NULL,
    duracion_programada_min INTEGER NOT NULL,
    jornadas_programadas INTEGER NOT NULL,
    tecnicos_programados INTEGER NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_servicio_preventivo)
);

CREATE TABLE IF NOT EXISTS servicio_programado (
    id_servicio_programado BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_servicio_preventivo BIGINT NOT NULL,
    fecha_programada DATE NOT NULL,
    ventana_inicio TIMESTAMP NULL,
    ventana_fin TIMESTAMP NULL,
    hora_inicio_prevista TIME NULL,
    hora_fin_prevista TIME NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_servicio_programado)
);

CREATE TABLE IF NOT EXISTS reprogramacion_servicio (
    id_reprogramacion BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_servicio_programado BIGINT NOT NULL,
    autorizado_por BIGINT NULL,
    fecha_anterior DATE NOT NULL,
    fecha_nueva DATE NOT NULL,
    motivo VARCHAR(500) NOT NULL,
    solicitado_por_tipo VARCHAR(50) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_reprogramacion)
);

CREATE TABLE IF NOT EXISTS asignacion_servicio (
    id_asignacion BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_servicio BIGINT NOT NULL,
    id_cuadrilla BIGINT NOT NULL,
    fecha_asignacion TIMESTAMP NOT NULL,
    fecha_inicio_vigencia TIMESTAMP NOT NULL,
    fecha_fin_vigencia TIMESTAMP NULL,
    motivo_cambio VARCHAR(500) NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_asignacion)
);

CREATE TABLE IF NOT EXISTS asignacion_tecnico (
    id_asignacion_tecnico BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_asignacion BIGINT NOT NULL,
    id_empleado BIGINT NOT NULL,
    rol VARCHAR(50) NOT NULL,
    es_planeado BOOLEAN NOT NULL DEFAULT TRUE,
    confirmado BOOLEAN NOT NULL DEFAULT FALSE,
    hora_inicio_asignada TIMESTAMP NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_asignacion_tecnico)
);

CREATE TABLE IF NOT EXISTS jornada_servicio (
    id_jornada BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_servicio BIGINT NOT NULL,
    numero_jornada INTEGER NOT NULL,
    fecha DATE NOT NULL,
    hora_llegada TIMESTAMP NULL,
    hora_inicio_efectivo TIMESTAMP NULL,
    hora_fin_efectivo TIMESTAMP NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_jornada)
);

CREATE TABLE IF NOT EXISTS jornada_tecnico (
    id_jornada_tecnico BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_jornada BIGINT NOT NULL,
    id_empleado BIGINT NOT NULL,
    hora_inicio TIMESTAMP NULL,
    hora_fin TIMESTAMP NULL,
    minutos_efectivos INTEGER NULL,
    participacion VARCHAR(50) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_jornada_tecnico)
);

CREATE TABLE IF NOT EXISTS motivo_desviacion (
    id_motivo_desviacion BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(40) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    clasificacion VARCHAR(50) NOT NULL,
    requiere_evidencia BOOLEAN NOT NULL DEFAULT FALSE,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_motivo_desviacion)
);

CREATE TABLE IF NOT EXISTS desviacion_servicio (
    id_desviacion BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_servicio BIGINT NOT NULL,
    id_motivo_desviacion BIGINT NOT NULL,
    id_supervisor_valida BIGINT NULL,
    minutos_programados INTEGER NOT NULL,
    minutos_reales INTEGER NOT NULL,
    desviacion_minutos INTEGER NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_por BIGINT NOT NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_por BIGINT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_desviacion)
);

-- Llaves Foráneas (Sprint 3)

ALTER TABLE cuadrilla ADD CONSTRAINT fk_cuadrilla_id_zona_contrato FOREIGN KEY (id_zona_contrato) REFERENCES zona_contrato(id_zona_contrato);
ALTER TABLE cuadrilla ADD CONSTRAINT fk_cuadrilla_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE cuadrilla ADD CONSTRAINT fk_cuadrilla_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);

ALTER TABLE cuadrilla_miembro ADD CONSTRAINT fk_cuadrilla_miembro_id_cuadrilla FOREIGN KEY (id_cuadrilla) REFERENCES cuadrilla(id_cuadrilla);
ALTER TABLE cuadrilla_miembro ADD CONSTRAINT fk_cuadrilla_miembro_id_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado);
ALTER TABLE cuadrilla_miembro ADD CONSTRAINT fk_cuadrilla_miembro_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE cuadrilla_miembro ADD CONSTRAINT fk_cuadrilla_miembro_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);

ALTER TABLE plan_mantenimiento ADD CONSTRAINT fk_plan_mantenimiento_id_iguala FOREIGN KEY (id_iguala) REFERENCES iguala(id_iguala);
ALTER TABLE plan_mantenimiento ADD CONSTRAINT fk_plan_mantenimiento_id_iguala_servicio FOREIGN KEY (id_iguala_servicio) REFERENCES iguala_servicio(id_iguala_servicio);
ALTER TABLE plan_mantenimiento ADD CONSTRAINT fk_plan_mantenimiento_id_iguala_condicion FOREIGN KEY (id_iguala_condicion) REFERENCES iguala_condicion(id_iguala_condicion);
ALTER TABLE plan_mantenimiento ADD CONSTRAINT fk_plan_mantenimiento_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE plan_mantenimiento ADD CONSTRAINT fk_plan_mantenimiento_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);

ALTER TABLE plan_actividad ADD CONSTRAINT fk_plan_actividad_id_plan_mantenimiento FOREIGN KEY (id_plan_mantenimiento) REFERENCES plan_mantenimiento(id_plan_mantenimiento);
ALTER TABLE plan_actividad ADD CONSTRAINT fk_plan_actividad_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE plan_actividad ADD CONSTRAINT fk_plan_actividad_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);

ALTER TABLE servicio_mantenimiento ADD CONSTRAINT fk_servicio_mantenimiento_id_iguala FOREIGN KEY (id_iguala) REFERENCES iguala(id_iguala);
ALTER TABLE servicio_mantenimiento ADD CONSTRAINT fk_servicio_mantenimiento_id_iguala_servicio FOREIGN KEY (id_iguala_servicio) REFERENCES iguala_servicio(id_iguala_servicio);
ALTER TABLE servicio_mantenimiento ADD CONSTRAINT fk_servicio_mantenimiento_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE servicio_mantenimiento ADD CONSTRAINT fk_servicio_mantenimiento_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);

ALTER TABLE servicio_preventivo ADD CONSTRAINT fk_servicio_preventivo_id_servicio FOREIGN KEY (id_servicio) REFERENCES servicio_mantenimiento(id_servicio);
ALTER TABLE servicio_preventivo ADD CONSTRAINT fk_servicio_preventivo_id_plan_mantenimiento FOREIGN KEY (id_plan_mantenimiento) REFERENCES plan_mantenimiento(id_plan_mantenimiento);
ALTER TABLE servicio_preventivo ADD CONSTRAINT fk_servicio_preventivo_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE servicio_preventivo ADD CONSTRAINT fk_servicio_preventivo_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);

ALTER TABLE servicio_programado ADD CONSTRAINT fk_servicio_programado_id_servicio_preventivo FOREIGN KEY (id_servicio_preventivo) REFERENCES servicio_preventivo(id_servicio_preventivo);
ALTER TABLE servicio_programado ADD CONSTRAINT fk_servicio_programado_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE servicio_programado ADD CONSTRAINT fk_servicio_programado_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);

ALTER TABLE reprogramacion_servicio ADD CONSTRAINT fk_reprogramacion_servicio_id_servicio_programado FOREIGN KEY (id_servicio_programado) REFERENCES servicio_programado(id_servicio_programado);
ALTER TABLE reprogramacion_servicio ADD CONSTRAINT fk_reprogramacion_servicio_autorizado_por FOREIGN KEY (autorizado_por) REFERENCES empleado(id_empleado);
ALTER TABLE reprogramacion_servicio ADD CONSTRAINT fk_reprogramacion_servicio_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE reprogramacion_servicio ADD CONSTRAINT fk_reprogramacion_servicio_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);

ALTER TABLE asignacion_servicio ADD CONSTRAINT fk_asignacion_servicio_id_servicio FOREIGN KEY (id_servicio) REFERENCES servicio_mantenimiento(id_servicio);
ALTER TABLE asignacion_servicio ADD CONSTRAINT fk_asignacion_servicio_id_cuadrilla FOREIGN KEY (id_cuadrilla) REFERENCES cuadrilla(id_cuadrilla);
ALTER TABLE asignacion_servicio ADD CONSTRAINT fk_asignacion_servicio_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE asignacion_servicio ADD CONSTRAINT fk_asignacion_servicio_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);

ALTER TABLE asignacion_tecnico ADD CONSTRAINT fk_asignacion_tecnico_id_asignacion FOREIGN KEY (id_asignacion) REFERENCES asignacion_servicio(id_asignacion);
ALTER TABLE asignacion_tecnico ADD CONSTRAINT fk_asignacion_tecnico_id_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado);
ALTER TABLE asignacion_tecnico ADD CONSTRAINT fk_asignacion_tecnico_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE asignacion_tecnico ADD CONSTRAINT fk_asignacion_tecnico_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);

ALTER TABLE jornada_servicio ADD CONSTRAINT fk_jornada_servicio_id_servicio FOREIGN KEY (id_servicio) REFERENCES servicio_mantenimiento(id_servicio);
ALTER TABLE jornada_servicio ADD CONSTRAINT fk_jornada_servicio_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE jornada_servicio ADD CONSTRAINT fk_jornada_servicio_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);

ALTER TABLE jornada_tecnico ADD CONSTRAINT fk_jornada_tecnico_id_jornada FOREIGN KEY (id_jornada) REFERENCES jornada_servicio(id_jornada);
ALTER TABLE jornada_tecnico ADD CONSTRAINT fk_jornada_tecnico_id_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado);
ALTER TABLE jornada_tecnico ADD CONSTRAINT fk_jornada_tecnico_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE jornada_tecnico ADD CONSTRAINT fk_jornada_tecnico_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);

ALTER TABLE motivo_desviacion ADD CONSTRAINT fk_motivo_desviacion_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE motivo_desviacion ADD CONSTRAINT fk_motivo_desviacion_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);

ALTER TABLE desviacion_servicio ADD CONSTRAINT fk_desviacion_servicio_id_servicio FOREIGN KEY (id_servicio) REFERENCES servicio_mantenimiento(id_servicio);
ALTER TABLE desviacion_servicio ADD CONSTRAINT fk_desviacion_servicio_id_motivo_desviacion FOREIGN KEY (id_motivo_desviacion) REFERENCES motivo_desviacion(id_motivo_desviacion);
ALTER TABLE desviacion_servicio ADD CONSTRAINT fk_desviacion_servicio_id_supervisor_valida FOREIGN KEY (id_supervisor_valida) REFERENCES empleado(id_empleado);
ALTER TABLE desviacion_servicio ADD CONSTRAINT fk_desviacion_servicio_creado_por FOREIGN KEY (creado_por) REFERENCES usuario(id_usuario);
ALTER TABLE desviacion_servicio ADD CONSTRAINT fk_desviacion_servicio_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES usuario(id_usuario);
