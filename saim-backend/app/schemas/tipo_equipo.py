from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime

class TipoEquipoBase(BaseModel):
    codigo: str
    nombre: str
    descripcion: Optional[str] = None

class TipoEquipoCreate(TipoEquipoBase):
    creado_por: int
    actualizado_por: int

class TipoEquipoUpdate(BaseModel):
    codigo: Optional[str] = None
    nombre: Optional[str] = None
    descripcion: Optional[str] = None
    actualizado_por: int

class TipoEquipoResponse(TipoEquipoBase):
    id_tipo_equipo: int
    activo: bool
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int

    model_config = ConfigDict(from_attributes=True)
