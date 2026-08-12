from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.contrato import ContratoCreate, ContratoUpdate, ContratoResponse
from app.services.contrato_service import ContratoService
from app.api.dependencies import get_contrato_service

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
