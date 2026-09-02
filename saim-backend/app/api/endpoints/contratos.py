import hashlib
import uuid
from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File
from typing import List
from app.schemas.contrato import ContratoCreate, ContratoUpdate, ContratoResponse
from app.services.contrato_service import ContratoService
from app.api.dependencies import get_contrato_service
from app.core.database import supabase_client

router = APIRouter()

@router.get("/", response_model=List[ContratoResponse])
def get_contratos(service: ContratoService = Depends(get_contrato_service)):
    """Obtiene la lista de contratos activos."""
    return service.get_all()

@router.get("/{contrato_id}", response_model=ContratoResponse)
def get_contrato(contrato_id: int, service: ContratoService = Depends(get_contrato_service)):
    """Obtiene un contrato por su ID."""
    contrato = service.get_by_id(contrato_id)
    if not contrato:
        raise HTTPException(status_code=404, detail="Contrato no encontrado")
    return contrato

@router.get("/cliente/{cliente_id}", response_model=List[ContratoResponse])
def get_contratos_por_cliente(cliente_id: int, service: ContratoService = Depends(get_contrato_service)):
    """Obtiene todos los contratos activos asociados a un cliente específico."""
    return service.get_by_cliente(cliente_id)

@router.post("/", response_model=ContratoResponse, status_code=status.HTTP_201_CREATED)
def create_contrato(contrato_in: ContratoCreate, service: ContratoService = Depends(get_contrato_service)):
    """Crea un nuevo contrato."""
    return service.create(contrato_in)

@router.put("/{contrato_id}", response_model=ContratoResponse)
def update_contrato(contrato_id: int, contrato_in: ContratoUpdate, service: ContratoService = Depends(get_contrato_service)):
    """Actualiza la información de un contrato existente."""
    contrato = service.update(contrato_id, contrato_in)
    if not contrato:
        raise HTTPException(status_code=404, detail="Contrato no encontrado")
    return contrato

@router.delete("/{contrato_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_contrato(contrato_id: int, service: ContratoService = Depends(get_contrato_service)):
    """Desactiva un contrato (Soft Delete)."""
    success = service.delete(contrato_id)
    if not success:
        raise HTTPException(status_code=404, detail="Contrato no encontrado")
    return None

@router.post("/documentos/upload", status_code=status.HTTP_201_CREATED)
def upload_documento(file: UploadFile = File(...)):
    """Sube un documento a Supabase Storage y retorna la ruta y hash SHA-256."""
    try:
        content = file.file.read()
        
        # Calcular Hash SHA-256
        sha256_hash = hashlib.sha256(content).hexdigest()
        
        # Generar nombre único
        ext = file.filename.split(".")[-1] if "." in file.filename else "bin"
        file_name = f"{uuid.uuid4()}.{ext}"
        bucket_path = f"{file_name}"
        
        # Subir a Supabase
        supabase_client.storage.from_("contratos-documentos").upload(
            bucket_path,
            content,
            {"content-type": file.content_type}
        )
        
        # La ruta que guardaremos será la del bucket
        ruta = f"obj://contratos-documentos/{bucket_path}"
        
        return {"ruta": ruta, "hash": sha256_hash}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        file.file.close()

@router.get("/documentos/download")
def download_documento(ruta: str):
    """Genera una URL firmada para descargar el documento desde Supabase Storage."""
    if not ruta.startswith("obj://contratos-documentos/"):
        raise HTTPException(status_code=400, detail="Ruta de documento inválida")
        
    bucket_path = ruta.replace("obj://contratos-documentos/", "")
    try:
        # Generar URL firmada válida por 1 hora (3600 segundos)
        res = supabase_client.storage.from_("contratos-documentos").create_signed_url(bucket_path, 3600)
        
        if not res or "signedURL" not in res:
             raise HTTPException(status_code=404, detail="No se pudo generar la URL de descarga")
             
        url = res["signedURL"]
        if "kong:8000" in url:
            url = url.replace("kong:8000", "localhost:8000")
             
        return {"url": url}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
