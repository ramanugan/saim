from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.finanzas import PresupuestoCreate, PresupuestoUpdate, PresupuestoResponse
from app.services.finanzas_service import FinanzasService
from app.api.dependencies import get_finanzas_service

router = APIRouter()

@router.get("/", response_model=List[PresupuestoResponse])
def get_presupuestos(service: FinanzasService = Depends(get_finanzas_service)):
    """Obtiene la lista de presupuestos activos."""
    return service.get_all_presupuestos()

@router.get("/{pre_id}", response_model=PresupuestoResponse)
def get_presupuesto(pre_id: int, service: FinanzasService = Depends(get_finanzas_service)):
    """Obtiene un presupuesto por su ID."""
    pre = service.get_presupuesto_by_id(pre_id)
    if not pre:
        raise HTTPException(status_code=404, detail="Presupuesto no encontrado")
    return pre

@router.post("/", response_model=PresupuestoResponse, status_code=status.HTTP_201_CREATED)
def create_presupuesto(pre_in: PresupuestoCreate, service: FinanzasService = Depends(get_finanzas_service)):
    """Crea un nuevo presupuesto."""
    return service.create_presupuesto(pre_in)

@router.put("/{pre_id}", response_model=PresupuestoResponse)
def update_presupuesto(pre_id: int, pre_in: PresupuestoUpdate, service: FinanzasService = Depends(get_finanzas_service)):
    """Actualiza la información de un presupuesto existente."""
    pre = service.update_presupuesto(pre_id, pre_in)
    if not pre:
        raise HTTPException(status_code=404, detail="Presupuesto no encontrado")
    return pre

@router.delete("/{pre_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_presupuesto(pre_id: int, service: FinanzasService = Depends(get_finanzas_service)):
    """Desactiva un presupuesto (Soft Delete)."""
    success = service.delete_presupuesto(pre_id)
    if not success:
        raise HTTPException(status_code=404, detail="Presupuesto no encontrado")
    return None
