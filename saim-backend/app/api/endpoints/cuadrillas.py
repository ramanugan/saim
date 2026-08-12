from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.cuadrilla import CuadrillaCreate, CuadrillaUpdate, CuadrillaResponse
from app.services.cuadrilla_service import CuadrillaService
from app.api.dependencies import get_cuadrilla_service

router = APIRouter()

@router.get("/", response_model=List[CuadrillaResponse])
def get_cuadrillas(service: CuadrillaService = Depends(get_cuadrilla_service)):
    """Obtiene la lista de cuadrillas activas."""
    return service.get_all_cuadrillas()

@router.get("/{cua_id}", response_model=CuadrillaResponse)
def get_cuadrilla(cua_id: int, service: CuadrillaService = Depends(get_cuadrilla_service)):
    """Obtiene una cuadrilla por su ID."""
    cua = service.get_cuadrilla_by_id(cua_id)
    if not cua:
        raise HTTPException(status_code=404, detail="Cuadrilla no encontrada")
    return cua

@router.post("/", response_model=CuadrillaResponse, status_code=status.HTTP_201_CREATED)
def create_cuadrilla(cua_in: CuadrillaCreate, service: CuadrillaService = Depends(get_cuadrilla_service)):
    """Crea una nueva cuadrilla y asocia técnicos opcionalmente."""
    return service.create_cuadrilla(cua_in)

@router.put("/{cua_id}", response_model=CuadrillaResponse)
def update_cuadrilla(cua_id: int, cua_in: CuadrillaUpdate, service: CuadrillaService = Depends(get_cuadrilla_service)):
    """Actualiza la información de una cuadrilla y sus técnicos."""
    cua = service.update_cuadrilla(cua_id, cua_in)
    if not cua:
        raise HTTPException(status_code=404, detail="Cuadrilla no encontrada")
    return cua

@router.delete("/{cua_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_cuadrilla(cua_id: int, service: CuadrillaService = Depends(get_cuadrilla_service)):
    """Desactiva una cuadrilla (Soft Delete)."""
    success = service.delete_cuadrilla(cua_id)
    if not success:
        raise HTTPException(status_code=404, detail="Cuadrilla no encontrada")
    return None
