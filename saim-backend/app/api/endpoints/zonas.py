from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.zona import ZonaCreate, ZonaUpdate, ZonaResponse
from app.services.zona_service import ZonaService

router = APIRouter()

def get_zona_service():
    return ZonaService()

@router.get("/", response_model=List[ZonaResponse])
def get_zonas(service: ZonaService = Depends(get_zona_service)):
    """Obtiene la lista de zonas (catálogo maestro)."""
    return service.get_all()

@router.get("/{id_zona}", response_model=ZonaResponse)
def get_zona(id_zona: int, service: ZonaService = Depends(get_zona_service)):
    """Obtiene una zona por su ID."""
    zona = service.get_by_id(id_zona)
    if not zona:
        raise HTTPException(status_code=404, detail="Zona no encontrada")
    return zona

@router.post("/", response_model=ZonaResponse, status_code=status.HTTP_201_CREATED)
def create_zona(zona_in: ZonaCreate, service: ZonaService = Depends(get_zona_service)):
    """Crea una nueva zona en el catálogo maestro."""
    return service.create(zona_in)

@router.put("/{id_zona}", response_model=ZonaResponse)
def update_zona(id_zona: int, zona_in: ZonaUpdate, service: ZonaService = Depends(get_zona_service)):
    """Actualiza la información de una zona existente."""
    zona = service.update(id_zona, zona_in)
    if not zona:
        raise HTTPException(status_code=404, detail="Zona no encontrada")
    return zona

@router.delete("/{id_zona}", status_code=status.HTTP_204_NO_CONTENT)
def delete_zona(id_zona: int, actualizado_por: int, service: ZonaService = Depends(get_zona_service)):
    """Desactiva una zona (Soft Delete)."""
    success = service.delete(id_zona, actualizado_por)
    if not success:
        raise HTTPException(status_code=404, detail="Zona no encontrada")
    return None
