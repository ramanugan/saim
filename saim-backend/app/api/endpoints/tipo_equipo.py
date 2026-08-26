from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.tipo_equipo import TipoEquipoCreate, TipoEquipoUpdate, TipoEquipoResponse
from app.services.tipo_equipo_service import TipoEquipoService
from app.api.dependencies import get_tipo_equipo_service

router = APIRouter()

@router.get("/", response_model=List[TipoEquipoResponse])
def get_tipos_equipo(service: TipoEquipoService = Depends(get_tipo_equipo_service)):
    """Obtiene la lista de tipos de equipo activos."""
    return service.get_all()

@router.get("/{tipo_equipo_id}", response_model=TipoEquipoResponse)
def get_tipo_equipo(tipo_equipo_id: int, service: TipoEquipoService = Depends(get_tipo_equipo_service)):
    """Obtiene un tipo de equipo por su ID."""
    tipo = service.get_by_id(tipo_equipo_id)
    if not tipo:
        raise HTTPException(status_code=404, detail="Tipo de equipo no encontrado")
    return tipo

@router.post("/", response_model=TipoEquipoResponse, status_code=status.HTTP_201_CREATED)
def create_tipo_equipo(tipo_in: TipoEquipoCreate, service: TipoEquipoService = Depends(get_tipo_equipo_service)):
    """Crea un nuevo tipo de equipo."""
    return service.create(tipo_in)

@router.put("/{tipo_equipo_id}", response_model=TipoEquipoResponse)
def update_tipo_equipo(tipo_equipo_id: int, tipo_in: TipoEquipoUpdate, service: TipoEquipoService = Depends(get_tipo_equipo_service)):
    """Actualiza la información de un tipo de equipo existente."""
    tipo = service.update(tipo_equipo_id, tipo_in)
    if not tipo:
        raise HTTPException(status_code=404, detail="Tipo de equipo no encontrado")
    return tipo

@router.delete("/{tipo_equipo_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_tipo_equipo(tipo_equipo_id: int, service: TipoEquipoService = Depends(get_tipo_equipo_service)):
    """Desactiva un tipo de equipo (Soft Delete)."""
    success = service.delete(tipo_equipo_id)
    if not success:
        raise HTTPException(status_code=404, detail="Tipo de equipo no encontrado")
    return None
