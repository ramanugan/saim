from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime

# ================= Categoria Servicio =================
class CategoriaServicioBase(BaseModel):
    nombre: str
    descripcion: Optional[str] = None
    estatus: str = "ACTIVA"

class CategoriaServicioCreate(CategoriaServicioBase):
    creado_por: int
    actualizado_por: int

class CategoriaServicioUpdate(BaseModel):
    nombre: Optional[str] = None
    descripcion: Optional[str] = None
    estatus: Optional[str] = None
    actualizado_por: int

class CategoriaServicioResponse(CategoriaServicioBase):
    id_categoria_servicio: int
    activo: bool
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int

    model_config = ConfigDict(from_attributes=True)

# ================= Servicio =================
class ServicioBase(BaseModel):
    id_categoria_servicio: int
    nombre: str
    descripcion: Optional[str] = None
    estatus: str = "ACTIVO"

class ServicioCreate(ServicioBase):
    creado_por: int
    actualizado_por: int

class ServicioUpdate(BaseModel):
    id_categoria_servicio: Optional[int] = None
    nombre: Optional[str] = None
    descripcion: Optional[str] = None
    estatus: Optional[str] = None
    actualizado_por: int

class ServicioResponse(ServicioBase):
    id_servicio: int
    activo: bool
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int

    model_config = ConfigDict(from_attributes=True)
