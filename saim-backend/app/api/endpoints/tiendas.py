from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.tienda import TiendaCreate, TiendaUpdate, TiendaResponse
from app.services.tienda_service import TiendaService
from app.api.dependencies import get_tienda_service

router = APIRouter()

@router.get("/", response_model=List[TiendaResponse])
def get_tiendas(service: TiendaService = Depends(get_tienda_service)):
    """Obtiene la lista de tiendas activas."""
    return service.get_all()

@router.get("/{tienda_id}", response_model=TiendaResponse)
def get_tienda(tienda_id: int, service: TiendaService = Depends(get_tienda_service)):
    """Obtiene una tienda por su ID."""
    tienda = service.get_by_id(tienda_id)
    if not tienda:
        raise HTTPException(status_code=404, detail="Tienda no encontrada")
    return tienda

@router.get("/cliente/{cliente_id}", response_model=List[TiendaResponse])
def get_tiendas_por_cliente(cliente_id: int, service: TiendaService = Depends(get_tienda_service)):
    """Obtiene todas las tiendas activas asociadas a un cliente específico."""
    return service.get_by_cliente(cliente_id)

@router.post("/", response_model=TiendaResponse, status_code=status.HTTP_201_CREATED)
def create_tienda(tienda_in: TiendaCreate, service: TiendaService = Depends(get_tienda_service)):
    """Crea una nueva tienda."""
    return service.create(tienda_in)

@router.put("/{tienda_id}", response_model=TiendaResponse)
def update_tienda(tienda_id: int, tienda_in: TiendaUpdate, service: TiendaService = Depends(get_tienda_service)):
    """Actualiza la información de una tienda existente."""
    tienda = service.update(tienda_id, tienda_in)
    if not tienda:
        raise HTTPException(status_code=404, detail="Tienda no encontrada")
    return tienda

@router.delete("/{tienda_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_tienda(tienda_id: int, service: TiendaService = Depends(get_tienda_service)):
    """Desactiva una tienda (Soft Delete)."""
    success = service.delete(tienda_id)
    if not success:
        raise HTTPException(status_code=404, detail="Tienda no encontrada")
    return None
