from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from datetime import datetime
from decimal import Decimal

class IgualaBase(BaseModel):
    id_cliente: int
    id_contrato: int
    nombre: str
    descripcion: Optional[str] = None
    monto_mensual: Optional[Decimal] = None
    estatus: str = "ACTIVA"

class IgualaCreate(IgualaBase):
    creado_por: int
    actualizado_por: int
    ids_tiendas: Optional[List[int]] = []  # Lista de tiendas a asociar al momento de crear

class IgualaUpdate(BaseModel):
    id_cliente: Optional[int] = None
    id_contrato: Optional[int] = None
    nombre: Optional[str] = None
    descripcion: Optional[str] = None
    monto_mensual: Optional[Decimal] = None
    estatus: Optional[str] = None
    actualizado_por: int
    ids_tiendas: Optional[List[int]] = None # Opcional: si se manda, se actualizarán las tiendas asociadas

class IgualaResponse(IgualaBase):
    id_iguala: int
    activo: bool
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int

    model_config = ConfigDict(from_attributes=True)
