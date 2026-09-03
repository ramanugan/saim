from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime

class ZonaBase(BaseModel):
    codigo: str
    nombre: str
    descripcion: Optional[str] = None
    activo: bool = True

class ZonaCreate(ZonaBase):
    creado_por: int
    actualizado_por: int

class ZonaUpdate(BaseModel):
    codigo: Optional[str] = None
    nombre: Optional[str] = None
    descripcion: Optional[str] = None
    activo: Optional[bool] = None
    actualizado_por: int

class ZonaResponse(ZonaBase):
    id_zona: int
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int

    model_config = ConfigDict(from_attributes=True)
