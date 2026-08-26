from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.equipo import EquipoCreate, EquipoUpdate, EquipoResponse
from app.services.equipo_service import EquipoService
from app.api.dependencies import get_equipo_service

router = APIRouter()

@router.get("/", response_model=List[EquipoResponse])
def get_equipos(service: EquipoService = Depends(get_equipo_service)):
    """Obtiene la lista de equipos activos con referencias resueltas."""
    return service.get_all()

@router.get("/{equipo_id}", response_model=EquipoResponse)
def get_equipo(equipo_id: int, service: EquipoService = Depends(get_equipo_service)):
    """Obtiene un equipo por su ID."""
    equipo = service.get_by_id(equipo_id)
    if not equipo:
        raise HTTPException(status_code=404, detail="Equipo no encontrado")
    return equipo

@router.post("/", response_model=EquipoResponse, status_code=status.HTTP_201_CREATED)
def create_equipo(equipo_in: EquipoCreate, service: EquipoService = Depends(get_equipo_service)):
    """Crea un nuevo equipo."""
    return service.create(equipo_in)

@router.put("/{equipo_id}", response_model=EquipoResponse)
def update_equipo(equipo_id: int, equipo_in: EquipoUpdate, service: EquipoService = Depends(get_equipo_service)):
    """Actualiza la información de un equipo existente."""
    equipo = service.update(equipo_id, equipo_in)
    if not equipo:
        raise HTTPException(status_code=404, detail="Equipo no encontrado")
    return equipo

@router.delete("/{equipo_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_equipo(equipo_id: int, service: EquipoService = Depends(get_equipo_service)):
    """Desactiva un equipo (Soft Delete)."""
    success = service.delete(equipo_id)
    if not success:
        raise HTTPException(status_code=404, detail="Equipo no encontrado")
    return None
