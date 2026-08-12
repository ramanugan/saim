from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime

class TiendaBase(BaseModel):
    id_cliente: int
    codigo_tienda: str
    nombre: str
    determinante: str
    calle: Optional[str] = None
    numero_exterior: Optional[str] = None
    numero_interior: Optional[str] = None
    colonia: Optional[str] = None
    codigo_postal: Optional[str] = None
    id_municipio: Optional[int] = None
    id_estado: Optional[int] = None
    estatus: str = "ACTIVA"

class TiendaCreate(TiendaBase):
    creado_por: int
    actualizado_por: int

class TiendaUpdate(BaseModel):
    codigo_tienda: Optional[str] = None
    nombre: Optional[str] = None
    determinante: Optional[str] = None
    calle: Optional[str] = None
    numero_exterior: Optional[str] = None
    numero_interior: Optional[str] = None
    colonia: Optional[str] = None
    codigo_postal: Optional[str] = None
    id_municipio: Optional[int] = None
    id_estado: Optional[int] = None
    estatus: Optional[str] = None
    actualizado_por: int

class TiendaResponse(TiendaBase):
    id_tienda: int
    activo: bool
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int

    model_config = ConfigDict(from_attributes=True)
