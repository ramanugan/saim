from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.cliente import ClienteCreate, ClienteUpdate, ClienteResponse
from app.services.cliente_service import ClienteService
from app.api.dependencies import get_cliente_service

router = APIRouter()

@router.get("/", response_model=List[ClienteResponse])
def get_clientes(service: ClienteService = Depends(get_cliente_service)):
    """Obtiene la lista de clientes activos."""
    return service.get_all()

@router.get("/{cliente_id}", response_model=ClienteResponse)
def get_cliente(cliente_id: int, service: ClienteService = Depends(get_cliente_service)):
    """Obtiene un cliente por su ID."""
    cliente = service.get_by_id(cliente_id)
    if not cliente:
        raise HTTPException(status_code=404, detail="Cliente no encontrado")
    return cliente

@router.post("/", response_model=ClienteResponse, status_code=status.HTTP_201_CREATED)
def create_cliente(cliente_in: ClienteCreate, service: ClienteService = Depends(get_cliente_service)):
    """Crea un nuevo cliente."""
    return service.create(cliente_in)

@router.put("/{cliente_id}", response_model=ClienteResponse)
def update_cliente(cliente_id: int, cliente_in: ClienteUpdate, service: ClienteService = Depends(get_cliente_service)):
    """Actualiza la información de un cliente existente."""
    cliente = service.update(cliente_id, cliente_in)
    if not cliente:
        raise HTTPException(status_code=404, detail="Cliente no encontrado")
    return cliente

@router.delete("/{cliente_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_cliente(cliente_id: int, service: ClienteService = Depends(get_cliente_service)):
    """Desactiva un cliente (Soft Delete)."""
    success = service.delete(cliente_id)
    if not success:
        raise HTTPException(status_code=404, detail="Cliente no encontrado")
    return None
