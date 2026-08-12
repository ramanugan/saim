from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import date, datetime
from decimal import Decimal

class ContratoBase(BaseModel):
    id_cliente: int
    numero_contrato: str
    nombre: str
    fecha_firma: Optional[date] = None
    fecha_inicio: date
    fecha_fin: date
    moneda: str
    monto_global: Optional[Decimal] = None
    periodicidad_facturacion: str
    estatus: str = "ACTIVO"

class ContratoCreate(ContratoBase):
    creado_por: int
    actualizado_por: int

class ContratoUpdate(BaseModel):
    numero_contrato: Optional[str] = None
    nombre: Optional[str] = None
    fecha_firma: Optional[date] = None
    fecha_inicio: Optional[date] = None
    fecha_fin: Optional[date] = None
    moneda: Optional[str] = None
    monto_global: Optional[Decimal] = None
    periodicidad_facturacion: Optional[str] = None
    estatus: Optional[str] = None
    actualizado_por: int

class ContratoResponse(ContratoBase):
    id_contrato: int
    activo: bool
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int

    model_config = ConfigDict(from_attributes=True)
