from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime, date

class EquipoBase(BaseModel):
    id_tienda: int
    id_tipo_equipo: int
    codigo_activo_cliente: Optional[str] = None
    marca: Optional[str] = None
    modelo: Optional[str] = None
    numero_serie: Optional[str] = None
    ubicacion_interna: Optional[str] = None
    fecha_instalacion: Optional[date] = None
    estado_operativo: str
    criticidad: str

class EquipoCreate(EquipoBase):
    creado_por: int
    actualizado_por: int

class EquipoUpdate(BaseModel):
    id_tienda: Optional[int] = None
    id_tipo_equipo: Optional[int] = None
    codigo_activo_cliente: Optional[str] = None
    marca: Optional[str] = None
    modelo: Optional[str] = None
    numero_serie: Optional[str] = None
    ubicacion_interna: Optional[str] = None
    fecha_instalacion: Optional[date] = None
    estado_operativo: Optional[str] = None
    criticidad: Optional[str] = None
    actualizado_por: int

class EquipoResponse(EquipoBase):
    id_equipo: int
    activo: bool
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int
    
    # Campos adicionales del JOIN
    nombre_tienda: Optional[str] = None
    nombre_tipo_equipo: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)
