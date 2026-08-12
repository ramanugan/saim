from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.inventario import RefaccionCreate, RefaccionUpdate, RefaccionResponse
from app.services.inventario_service import InventarioService
from app.api.dependencies import get_inventario_service

router = APIRouter()

@router.get("/", response_model=List[RefaccionResponse])
def get_refacciones(service: InventarioService = Depends(get_inventario_service)):
    """Obtiene la lista de refacciones activas."""
    return service.get_all_refacciones()

@router.get("/{ref_id}", response_model=RefaccionResponse)
def get_refaccion(ref_id: int, service: InventarioService = Depends(get_inventario_service)):
    """Obtiene una refaccion por su ID."""
    ref = service.get_refaccion_by_id(ref_id)
    if not ref:
        raise HTTPException(status_code=404, detail="Refacción no encontrada")
    return ref

@router.post("/", response_model=RefaccionResponse, status_code=status.HTTP_201_CREATED)
def create_refaccion(ref_in: RefaccionCreate, service: InventarioService = Depends(get_inventario_service)):
    """Crea una nueva refaccion y su registro de inventario."""
    return service.create_refaccion(ref_in)

@router.put("/{ref_id}", response_model=RefaccionResponse)
def update_refaccion(ref_id: int, ref_in: RefaccionUpdate, service: InventarioService = Depends(get_inventario_service)):
    """Actualiza la información de una refaccion existente."""
    ref = service.update_refaccion(ref_id, ref_in)
    if not ref:
        raise HTTPException(status_code=404, detail="Refacción no encontrada")
    return ref

@router.delete("/{ref_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_refaccion(ref_id: int, service: InventarioService = Depends(get_inventario_service)):
    """Desactiva una refaccion (Soft Delete)."""
    success = service.delete_refaccion(ref_id)
    if not success:
        raise HTTPException(status_code=404, detail="Refacción no encontrada")
    return None
