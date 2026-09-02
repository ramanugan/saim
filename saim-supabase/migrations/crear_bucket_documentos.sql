INSERT INTO storage.buckets (id, name, public) 
VALUES ('contratos-documentos', 'contratos-documentos', false)
ON CONFLICT (id) DO NOTHING;
