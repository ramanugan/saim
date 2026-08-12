from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.finanzas import CotizacionCreate, CotizacionUpdate, CotizacionResponse
from app.services.finanzas_service import FinanzasService
from app.api.dependencies import get_finanzas_service

router = APIRouter()

@router.get("/", response_model=List[CotizacionResponse])
def get_cotizaciones(service: FinanzasService = Depends(get_finanzas_service)):
    """Obtiene la lista de cotizaciones activas."""
    return service.get_all_cotizaciones()

@router.get("/{cot_id}", response_model=CotizacionResponse)
def get_cotizacion(cot_id: int, service: FinanzasService = Depends(get_finanzas_service)):
    """Obtiene una cotizacion por su ID."""
    cot = service.get_cotizacion_by_id(cot_id)
    if not cot:
        raise HTTPException(status_code=404, detail="Cotización no encontrada")
    return cot

@router.post("/", response_model=CotizacionResponse, status_code=status.HTTP_201_CREATED)
def create_cotizacion(cot_in: CotizacionCreate, service: FinanzasService = Depends(get_finanzas_service)):
    """Crea una nueva cotizacion."""
    return service.create_cotizacion(cot_in)

@router.put("/{cot_id}", response_model=CotizacionResponse)
def update_cotizacion(cot_id: int, cot_in: CotizacionUpdate, service: FinanzasService = Depends(get_finanzas_service)):
    """Actualiza la información de una cotizacion existente."""
    cot = service.update_cotizacion(cot_id, cot_in)
    if not cot:
        raise HTTPException(status_code=404, detail="Cotización no encontrada")
    return cot

@router.delete("/{cot_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_cotizacion(cot_id: int, service: FinanzasService = Depends(get_finanzas_service)):
    """Desactiva una cotizacion (Soft Delete)."""
    success = service.delete_cotizacion(cot_id)
    if not success:
        raise HTTPException(status_code=404, detail="Cotización no encontrada")
    return None
