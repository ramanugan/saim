from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.servicio import ServicioCreate, ServicioUpdate, ServicioResponse
from app.services.servicio_service import ServicioService
from app.api.dependencies import get_servicio_service

router = APIRouter()

@router.get("/", response_model=List[ServicioResponse])
def get_servicios(service: ServicioService = Depends(get_servicio_service)):
    """Obtiene la lista de servicios activos."""
    return service.get_all_servicios()

@router.get("/{srv_id}", response_model=ServicioResponse)
def get_servicio(srv_id: int, service: ServicioService = Depends(get_servicio_service)):
    """Obtiene un servicio por su ID."""
    srv = service.get_servicio_by_id(srv_id)
    if not srv:
        raise HTTPException(status_code=404, detail="Servicio no encontrado")
    return srv

@router.get("/categoria/{cat_id}", response_model=List[ServicioResponse])
def get_servicios_por_categoria(cat_id: int, service: ServicioService = Depends(get_servicio_service)):
    """Obtiene todos los servicios activos asociados a una categoría."""
    return service.get_servicios_by_categoria(cat_id)

@router.post("/", response_model=ServicioResponse, status_code=status.HTTP_201_CREATED)
def create_servicio(srv_in: ServicioCreate, service: ServicioService = Depends(get_servicio_service)):
    """Crea un nuevo servicio."""
    return service.create_servicio(srv_in)

@router.put("/{srv_id}", response_model=ServicioResponse)
def update_servicio(srv_id: int, srv_in: ServicioUpdate, service: ServicioService = Depends(get_servicio_service)):
    """Actualiza la información de un servicio existente."""
    srv = service.update_servicio(srv_id, srv_in)
    if not srv:
        raise HTTPException(status_code=404, detail="Servicio no encontrado")
    return srv

@router.delete("/{srv_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_servicio(srv_id: int, service: ServicioService = Depends(get_servicio_service)):
    """Desactiva un servicio (Soft Delete)."""
    success = service.delete_servicio(srv_id)
    if not success:
        raise HTTPException(status_code=404, detail="Servicio no encontrado")
    return None
