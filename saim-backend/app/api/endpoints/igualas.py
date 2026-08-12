from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.iguala import IgualaCreate, IgualaUpdate, IgualaResponse
from app.services.iguala_service import IgualaService
from app.api.dependencies import get_iguala_service

router = APIRouter()

@router.get("/", response_model=List[IgualaResponse])
def get_igualas(service: IgualaService = Depends(get_iguala_service)):
    """Obtiene la lista de igualas activas."""
    return service.get_all()

@router.get("/{iguala_id}", response_model=IgualaResponse)
def get_iguala(iguala_id: int, service: IgualaService = Depends(get_iguala_service)):
    """Obtiene una iguala por su ID."""
    iguala = service.get_by_id(iguala_id)
    if not iguala:
        raise HTTPException(status_code=404, detail="Iguala no encontrada")
    return iguala

@router.post("/", response_model=IgualaResponse, status_code=status.HTTP_201_CREATED)
def create_iguala(iguala_in: IgualaCreate, service: IgualaService = Depends(get_iguala_service)):
    """Crea una nueva iguala y opcionalmente la vincula a múltiples tiendas."""
    return service.create(iguala_in)

@router.put("/{iguala_id}", response_model=IgualaResponse)
def update_iguala(iguala_id: int, iguala_in: IgualaUpdate, service: IgualaService = Depends(get_iguala_service)):
    """Actualiza la información de una iguala existente y sus tiendas."""
    iguala = service.update(iguala_id, iguala_in)
    if not iguala:
        raise HTTPException(status_code=404, detail="Iguala no encontrada")
    return iguala

@router.delete("/{iguala_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_iguala(iguala_id: int, service: IgualaService = Depends(get_iguala_service)):
    """Desactiva una iguala (Soft Delete)."""
    success = service.delete(iguala_id)
    if not success:
        raise HTTPException(status_code=404, detail="Iguala no encontrada")
    return None
