from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from app.schemas.servicio import CategoriaServicioCreate, CategoriaServicioUpdate, CategoriaServicioResponse
from app.services.servicio_service import ServicioService
from app.api.dependencies import get_servicio_service

router = APIRouter()

@router.get("/", response_model=List[CategoriaServicioResponse])
def get_categorias(service: ServicioService = Depends(get_servicio_service)):
    """Obtiene la lista de categorias activas."""
    return service.get_all_categorias()

@router.get("/{cat_id}", response_model=CategoriaServicioResponse)
def get_categoria(cat_id: int, service: ServicioService = Depends(get_servicio_service)):
    """Obtiene una categoria por su ID."""
    cat = service.get_categoria_by_id(cat_id)
    if not cat:
        raise HTTPException(status_code=404, detail="Categoría no encontrada")
    return cat

@router.post("/", response_model=CategoriaServicioResponse, status_code=status.HTTP_201_CREATED)
def create_categoria(cat_in: CategoriaServicioCreate, service: ServicioService = Depends(get_servicio_service)):
    """Crea una nueva categoria."""
    return service.create_categoria(cat_in)

@router.put("/{cat_id}", response_model=CategoriaServicioResponse)
def update_categoria(cat_id: int, cat_in: CategoriaServicioUpdate, service: ServicioService = Depends(get_servicio_service)):
    """Actualiza la información de una categoria existente."""
    cat = service.update_categoria(cat_id, cat_in)
    if not cat:
        raise HTTPException(status_code=404, detail="Categoría no encontrada")
    return cat

@router.delete("/{cat_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_categoria(cat_id: int, service: ServicioService = Depends(get_servicio_service)):
    """Desactiva una categoria (Soft Delete)."""
    success = service.delete_categoria(cat_id)
    if not success:
        raise HTTPException(status_code=404, detail="Categoría no encontrada")
    return None
