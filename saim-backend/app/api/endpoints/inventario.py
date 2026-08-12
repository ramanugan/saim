from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.inventario import MovimientoInventarioCreate, MovimientoInventarioResponse, InventarioRefaccionResponse
from app.services.inventario_service import InventarioService
from app.api.dependencies import get_inventario_service

router = APIRouter()

@router.get("/", response_model=List[InventarioRefaccionResponse])
def get_inventario(service: InventarioService = Depends(get_inventario_service)):
    """Obtiene el stock actual de todas las refacciones."""
    return service.get_inventario()

@router.post("/movimiento", response_model=MovimientoInventarioResponse, status_code=status.HTTP_201_CREATED)
def register_movimiento(mov_in: MovimientoInventarioCreate, service: InventarioService = Depends(get_inventario_service)):
    """Registra un movimiento (ENTRADA/SALIDA) y actualiza el stock."""
    return service.register_movimiento(mov_in)
