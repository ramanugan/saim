from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime

class ClienteBase(BaseModel):
    codigo: str
    razon_social: str
    nombre_comercial: str
    rfc: Optional[str] = None
    correo_contacto: Optional[str] = None
    telefono_contacto: Optional[str] = None
    estatus: str = "ACTIVO"

class ClienteCreate(ClienteBase):
    creado_por: int
    actualizado_por: int

class ClienteUpdate(BaseModel):
    codigo: Optional[str] = None
    razon_social: Optional[str] = None
    nombre_comercial: Optional[str] = None
    rfc: Optional[str] = None
    correo_contacto: Optional[str] = None
    telefono_contacto: Optional[str] = None
    estatus: Optional[str] = None
    actualizado_por: int

class ClienteResponse(ClienteBase):
    id_cliente: int
    activo: bool
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int

    model_config = ConfigDict(from_attributes=True)
