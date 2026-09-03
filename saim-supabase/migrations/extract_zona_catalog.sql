-- 1. Create the standalone `zona` catalog table
CREATE TABLE public.zona (
  id_zona BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  codigo CHARACTER VARYING(40) NOT NULL,
  nombre CHARACTER VARYING(150) NOT NULL,
  descripcion CHARACTER VARYING(500) NULL,
  creado_en TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  creado_por BIGINT NOT NULL,
  actualizado_en TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  actualizado_por BIGINT NOT NULL,
  activo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT zona_pkey PRIMARY KEY (id_zona),
  CONSTRAINT fk_zona_actualizado_por FOREIGN KEY (actualizado_por) REFERENCES public.usuario (id_usuario),
  CONSTRAINT fk_zona_creado_por FOREIGN KEY (creado_por) REFERENCES public.usuario (id_usuario),
  CONSTRAINT zona_codigo_key UNIQUE (codigo)
) TABLESPACE pg_default;


-- 2. Populate the `zona` table with unique zones from `zona_contrato`
INSERT INTO public.zona (codigo, nombre, descripcion, creado_por, actualizado_por)
SELECT DISTINCT ON (codigo)
    codigo, 
    nombre, 
    descripcion, 
    creado_por, 
    actualizado_por
FROM public.zona_contrato
ORDER BY codigo, actualizado_en DESC;

-- 3. Add `id_zona` to `zona_contrato`
ALTER TABLE public.zona_contrato ADD COLUMN id_zona BIGINT NULL;

-- 4. Backfill `id_zona` in `zona_contrato` based on `codigo`
UPDATE public.zona_contrato zc
SET id_zona = z.id_zona
FROM public.zona z
WHERE zc.codigo = z.codigo;

-- Make `id_zona` NOT NULL and add foreign key constraint
ALTER TABLE public.zona_contrato ALTER COLUMN id_zona SET NOT NULL;
ALTER TABLE public.zona_contrato ADD CONSTRAINT fk_zona_contrato_id_zona FOREIGN KEY (id_zona) REFERENCES public.zona (id_zona);

-- 5. Drop redundant columns from `zona_contrato`
-- We drop these since they now live in the `zona` table
ALTER TABLE public.zona_contrato 
  DROP COLUMN codigo,
  DROP COLUMN nombre,
  DROP COLUMN descripcion;

-- 6. Modify `zona_tienda` to point to `id_zona` instead of `id_zona_contrato`
-- Wait, currently `zona_tienda` points to `id_zona_contrato`.
-- We need to change the FK and the column.
ALTER TABLE public.zona_tienda ADD COLUMN id_zona BIGINT NULL;

-- Backfill `id_zona` in `zona_tienda` using the relation through `zona_contrato`
UPDATE public.zona_tienda zt
SET id_zona = zc.id_zona
FROM public.zona_contrato zc
WHERE zt.id_zona_contrato = zc.id_zona_contrato;

-- Now drop the old column and rename the new one, add constraints
ALTER TABLE public.zona_tienda DROP CONSTRAINT fk_zona_tienda_id_zona_contrato;
ALTER TABLE public.zona_tienda DROP COLUMN id_zona_contrato;

ALTER TABLE public.zona_tienda ALTER COLUMN id_zona SET NOT NULL;
ALTER TABLE public.zona_tienda ADD CONSTRAINT fk_zona_tienda_id_zona FOREIGN KEY (id_zona) REFERENCES public.zona (id_zona);

-- ============================================================
-- 7. Update Stored Procedures to work with the new schema
-- ============================================================

CREATE OR REPLACE FUNCTION crear_contrato_completo(payload JSONB)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_id_contrato     BIGINT;
  v_id_version      BIGINT;
  v_id_zona_contrato BIGINT;
  zona_item         JSONB;
  alcance_item      JSONB;
  sla_item          JSONB;
  doc_item          JSONB;
  v_resultado       JSONB;
BEGIN
  -- ---- Paso 1: contrato ----
  INSERT INTO public.contrato (
    id_cliente,
    numero_contrato,
    nombre,
    fecha_firma,
    fecha_inicio,
    fecha_fin,
    moneda,
    monto_global,
    periodicidad_facturacion,
    estatus,
    creado_por,
    actualizado_por
  ) VALUES (
    (payload->>'id_cliente')::BIGINT,
    payload->>'numero_contrato',
    payload->>'nombre',
    NULLIF(payload->>'fecha_firma', '')::DATE,
    (payload->>'fecha_inicio')::DATE,
    (payload->>'fecha_fin')::DATE,
    payload->>'moneda',
    NULLIF(payload->>'monto_global', '')::NUMERIC,
    payload->>'periodicidad_facturacion',
    payload->>'estatus',
    (payload->>'creado_por')::BIGINT,
    (payload->>'creado_por')::BIGINT
  )
  RETURNING id_contrato INTO v_id_contrato;

  -- ---- Paso 2: contrato_version ----
  INSERT INTO public.contrato_version (
    id_contrato,
    numero_version,
    fecha_inicio_vigencia,
    fecha_fin_vigencia,
    motivo_version,
    estatus,
    creado_por,
    actualizado_por
  ) VALUES (
    v_id_contrato,
    (payload->'version'->>'numero_version')::INTEGER,
    (payload->'version'->>'fecha_inicio_vigencia')::DATE,
    NULLIF(payload->'version'->>'fecha_fin_vigencia', '')::DATE,
    payload->'version'->>'motivo_version',
    'VIGENTE',
    (payload->>'creado_por')::BIGINT,
    (payload->>'creado_por')::BIGINT
  )
  RETURNING id_contrato_version INTO v_id_version;

  -- ---- Paso 3: zona_contrato (puente) ----
  FOR zona_item IN SELECT * FROM jsonb_array_elements(payload->'zonas')
  LOOP
    INSERT INTO public.zona_contrato (
      id_contrato_version,
      id_zona,
      fecha_inicio,
      creado_por,
      actualizado_por
    ) VALUES (
      v_id_version,
      (zona_item->>'id_zona')::BIGINT,
      (payload->'version'->>'fecha_inicio_vigencia')::DATE,
      (payload->>'creado_por')::BIGINT,
      (payload->>'creado_por')::BIGINT
    )
    RETURNING id_zona_contrato INTO v_id_zona_contrato;

    -- ---- Paso 4: contrato_alcance (por zona) ----
    FOR alcance_item IN SELECT * FROM jsonb_array_elements(zona_item->'alcances')
    LOOP
      INSERT INTO public.contrato_alcance (
        id_contrato_version,
        id_zona_contrato,
        id_tipo_servicio,
        descripcion,
        creado_por,
        actualizado_por
      ) VALUES (
        v_id_version,
        v_id_zona_contrato,
        (alcance_item->>'id_tipo_servicio')::BIGINT,
        alcance_item->>'descripcion',
        (payload->>'creado_por')::BIGINT,
        (payload->>'creado_por')::BIGINT
      );
    END LOOP;

    -- ---- Paso 7: contrato_sla (por zona) ----
    FOR sla_item IN SELECT * FROM jsonb_array_elements(zona_item->'slas')
    LOOP
      INSERT INTO public.contrato_sla (
        id_contrato_version,
        id_zona_contrato,
        prioridad,
        horario_cobertura,
        minutos_respuesta,
        minutos_llegada,
        minutos_solucion_objetivo,
        regla_escalamiento,
        creado_por,
        actualizado_por
      ) VALUES (
        v_id_version,
        v_id_zona_contrato,
        sla_item->>'prioridad',
        sla_item->>'horario_cobertura',
        (sla_item->>'minutos_respuesta')::INTEGER,
        NULLIF(sla_item->>'minutos_llegada', '')::INTEGER,
        NULLIF(sla_item->>'minutos_solucion_objetivo', '')::INTEGER,
        sla_item->>'regla_escalamiento',
        (payload->>'creado_por')::BIGINT,
        (payload->>'creado_por')::BIGINT
      );
    END LOOP;
  END LOOP;

  -- ---- Paso 6: contrato_documento (array global de la version) ----
  FOR doc_item IN SELECT * FROM jsonb_array_elements(payload->'documentos')
  LOOP
    INSERT INTO public.contrato_documento (
      id_contrato_version,
      tipo_documento,
      nombre_archivo,
      ruta_archivo,
      hash_sha256,
      fecha_documento,
      es_vigente,
      creado_por,
      actualizado_por
    ) VALUES (
      v_id_version,
      doc_item->>'tipo_documento',
      doc_item->>'nombre_archivo',
      doc_item->>'ruta_archivo',
      doc_item->>'hash_sha256',
      NULLIF(doc_item->>'fecha_documento', '')::DATE,
      (doc_item->>'es_vigente')::BOOLEAN,
      (payload->>'creado_por')::BIGINT,
      (payload->>'creado_por')::BIGINT
    );
  END LOOP;

  -- Retorna los IDs creados para confirmación en el front-end
  v_resultado := jsonb_build_object(
    'id_contrato', v_id_contrato,
    'id_contrato_version', v_id_version
  );

  RETURN v_resultado;
END;
$$;

CREATE OR REPLACE FUNCTION actualizar_contrato_completo(payload JSONB)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_id_contrato        BIGINT;
  v_old_version        BIGINT;
  v_id_nueva_version   BIGINT;
  v_id_zona_contrato   BIGINT;
  zona_item            JSONB;
  alcance_item         JSONB;
  sla_item             JSONB;
  doc_item             JSONB;
  v_resultado          JSONB;
  v_usuario            BIGINT;
BEGIN
  v_id_contrato := (payload->>'id_contrato')::BIGINT;
  v_old_version := (payload->'version'->>'id_contrato_version')::BIGINT;
  v_usuario := (payload->>'actualizado_por')::BIGINT;

  -- 1. Actualizar cabecera del contrato
  UPDATE public.contrato
  SET 
    numero_contrato = payload->>'numero_contrato',
    nombre = payload->>'nombre',
    fecha_firma = NULLIF(payload->>'fecha_firma', '')::DATE,
    fecha_inicio = (payload->>'fecha_inicio')::DATE,
    fecha_fin = (payload->>'fecha_fin')::DATE,
    moneda = payload->>'moneda',
    monto_global = NULLIF(payload->>'monto_global', '')::NUMERIC,
    periodicidad_facturacion = payload->>'periodicidad_facturacion',
    estatus = payload->>'estatus',
    actualizado_por = v_usuario,
    actualizado_en = CURRENT_TIMESTAMP
  WHERE id_contrato = v_id_contrato;

  -- 2. Soft-delete versión anterior
  UPDATE public.contrato_version
  SET 
    activo = false,
    fecha_fin_vigencia = CURRENT_DATE,
    actualizado_por = v_usuario,
    actualizado_en = CURRENT_TIMESTAMP
  WHERE id_contrato_version = v_old_version;

  -- 3. Crear nueva versión del contrato
  INSERT INTO public.contrato_version (
    id_contrato,
    numero_version,
    fecha_inicio_vigencia,
    fecha_fin_vigencia,
    motivo_version,
    estatus,
    creado_por,
    actualizado_por
  ) VALUES (
    v_id_contrato,
    (payload->'version'->>'numero_version')::INTEGER,
    CURRENT_DATE,
    NULLIF(payload->'version'->>'fecha_fin_vigencia', '')::DATE,
    'Nueva versión generada tras edición.',
    'VIGENTE',
    v_usuario,
    v_usuario
  )
  RETURNING id_contrato_version INTO v_id_nueva_version;

  -- 4. Duplicar zonas, alcances y SLAs asociados
  FOR zona_item IN SELECT * FROM jsonb_array_elements(payload->'zonas')
  LOOP
    -- Insertamos la zona SIEMPRE para enlazarla a la nueva versión
    INSERT INTO public.zona_contrato (
      id_contrato_version,
      id_zona,
      fecha_inicio,
      creado_por,
      actualizado_por
    ) VALUES (
      v_id_nueva_version,
      (zona_item->>'id_zona')::BIGINT,
      CURRENT_DATE,
      v_usuario,
      v_usuario
    )
    RETURNING id_zona_contrato INTO v_id_zona_contrato;

    -- Si la zona provenía de la versión anterior (tenía un id_zona_contrato en el payload), copiar sus estados.
    -- Las tiendas ahora están asociadas al catálogo id_zona, así que ya NO necesitamos copiar zona_tienda!
    -- ¡Es correcto! La tienda pertenece a la zona. Al crear nueva versión de contrato que cubre a la misma zona,
    -- NO necesitamos clonar las tiendas porque las tiendas están amarradas a id_zona, no a id_zona_contrato.
    IF (zona_item->>'id_zona_contrato') IS NOT NULL THEN
       -- Copiar zona_estado activos (asumiendo que zona_estado sí depende de zona_contrato)
       INSERT INTO public.zona_estado (id_zona_contrato, id_estado, creado_por, actualizado_por)
       SELECT v_id_zona_contrato, id_estado, v_usuario, v_usuario
       FROM public.zona_estado 
       WHERE id_zona_contrato = (zona_item->>'id_zona_contrato')::BIGINT AND activo = true;

       -- Soft-delete de la asignacion puente vieja
       UPDATE public.zona_contrato 
       SET activo = false, actualizado_por = v_usuario, actualizado_en = CURRENT_TIMESTAMP
       WHERE id_zona_contrato = (zona_item->>'id_zona_contrato')::BIGINT;
    END IF;

    -- Alcances de la zona
    FOR alcance_item IN SELECT * FROM jsonb_array_elements(zona_item->'alcances')
    LOOP
      INSERT INTO public.contrato_alcance (
        id_contrato_version,
        id_zona_contrato,
        id_tipo_servicio,
        descripcion,
        creado_por,
        actualizado_por
      ) VALUES (
        v_id_nueva_version,
        v_id_zona_contrato,
        (alcance_item->>'id_tipo_servicio')::BIGINT,
        alcance_item->>'descripcion',
        v_usuario,
        v_usuario
      );
    END LOOP;

    -- SLAs de la zona
    FOR sla_item IN SELECT * FROM jsonb_array_elements(zona_item->'slas')
    LOOP
      INSERT INTO public.contrato_sla (
        id_contrato_version,
        id_zona_contrato,
        prioridad,
        horario_cobertura,
        minutos_respuesta,
        minutos_llegada,
        minutos_solucion_objetivo,
        regla_escalamiento,
        creado_por,
        actualizado_por
      ) VALUES (
        v_id_nueva_version,
        v_id_zona_contrato,
        sla_item->>'prioridad',
        sla_item->>'horario_cobertura',
        (sla_item->>'minutos_respuesta')::INTEGER,
        NULLIF(sla_item->>'minutos_llegada', '')::INTEGER,
        NULLIF(sla_item->>'minutos_solucion_objetivo', '')::INTEGER,
        sla_item->>'regla_escalamiento',
        v_usuario,
        v_usuario
      );
    END LOOP;
  END LOOP;

  -- 5. Documentos globales de la versión
  FOR doc_item IN SELECT * FROM jsonb_array_elements(payload->'documentos')
  LOOP
    INSERT INTO public.contrato_documento (
      id_contrato_version,
      tipo_documento,
      nombre_archivo,
      ruta_archivo,
      hash_sha256,
      fecha_documento,
      es_vigente,
      creado_por,
      actualizado_por
    ) VALUES (
      v_id_nueva_version,
      doc_item->>'tipo_documento',
      doc_item->>'nombre_archivo',
      doc_item->>'ruta_archivo',
      doc_item->>'hash_sha256',
      NULLIF(doc_item->>'fecha_documento', '')::DATE,
      (doc_item->>'es_vigente')::BOOLEAN,
      v_usuario,
      v_usuario
    );
  END LOOP;

  -- 6. Soft-delete zonas_contrato de la versión vieja que no vinieron en el payload
  UPDATE public.zona_contrato
  SET activo = false, actualizado_por = v_usuario, actualizado_en = CURRENT_TIMESTAMP
  WHERE id_contrato_version = v_old_version AND activo = true;

  v_resultado := jsonb_build_object(
    'id_contrato', v_id_contrato,
    'id_contrato_version', v_id_nueva_version
  );

  RETURN v_resultado;
END;
$$;
