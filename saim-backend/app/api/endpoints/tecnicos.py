from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.cuadrilla import TecnicoCreate, TecnicoUpdate, TecnicoResponse
from app.services.cuadrilla_service import CuadrillaService
from app.api.dependencies import get_cuadrilla_service

router = APIRouter()

@router.get("/", response_model=List[TecnicoResponse])
def get_tecnicos(service: CuadrillaService = Depends(get_cuadrilla_service)):
    """Obtiene la lista de técnicos activos."""
    return service.get_all_tecnicos()

@router.get("/{tec_id}", response_model=TecnicoResponse)
def get_tecnico(tec_id: int, service: CuadrillaService = Depends(get_cuadrilla_service)):
    """Obtiene un técnico por su ID."""
    tec = service.get_tecnico_by_id(tec_id)
    if not tec:
        raise HTTPException(status_code=404, detail="Técnico no encontrado")
    return tec

@router.post("/", response_model=TecnicoResponse, status_code=status.HTTP_201_CREATED)
def create_tecnico(tec_in: TecnicoCreate, service: CuadrillaService = Depends(get_cuadrilla_service)):
    """Crea un nuevo técnico."""
    return service.create_tecnico(tec_in)

@router.put("/{tec_id}", response_model=TecnicoResponse)
def update_tecnico(tec_id: int, tec_in: TecnicoUpdate, service: CuadrillaService = Depends(get_cuadrilla_service)):
    """Actualiza la información de un técnico."""
    tec = service.update_tecnico(tec_id, tec_in)
    if not tec:
        raise HTTPException(status_code=404, detail="Técnico no encontrado")
    return tec

@router.delete("/{tec_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_tecnico(tec_id: int, service: CuadrillaService = Depends(get_cuadrilla_service)):
    """Desactiva un técnico (Soft Delete)."""
    success = service.delete_tecnico(tec_id)
    if not success:
        raise HTTPException(status_code=404, detail="Técnico no encontrado")
    return None
