-- ============================================================
-- STORED PROCEDURE: crear_contrato_completo
-- Propósito: Inserta atomicamente el contrato y todas sus
-- entidades relacionadas. Si cualquier insert falla, toda
-- la transacción se revierte (ROLLBACK automático de PL/pgSQL).
-- ============================================================
CREATE OR REPLACE FUNCTION crear_contrato_completo(payload JSONB)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_id_contrato     BIGINT;
  v_id_version      BIGINT;
  v_id_zona         BIGINT;
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
    descripcion,
    creado_por,
    actualizado_por
  ) VALUES (
    v_id_contrato,
    (payload->'version'->>'numero_version')::INTEGER,
    (payload->'version'->>'fecha_inicio_vigencia')::DATE,
    NULLIF(payload->'version'->>'fecha_fin_vigencia', '')::DATE,
    payload->'version'->>'descripcion',
    (payload->>'creado_por')::BIGINT,
    (payload->>'creado_por')::BIGINT
  )
  RETURNING id_contrato_version INTO v_id_version;

  -- ---- Paso 3: zona_contrato (array) ----
  FOR zona_item IN SELECT * FROM jsonb_array_elements(payload->'zonas')
  LOOP
    INSERT INTO public.zona_contrato (
      id_contrato_version,
      codigo,
      nombre,
      descripcion,
      creado_por,
      actualizado_por
    ) VALUES (
      v_id_version,
      zona_item->>'codigo',
      zona_item->>'nombre',
      zona_item->>'descripcion',
      (payload->>'creado_por')::BIGINT,
      (payload->>'creado_por')::BIGINT
    )
    RETURNING id_zona_contrato INTO v_id_zona;

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
        v_id_zona,
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
        v_id_zona,
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
