from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from datetime import datetime, date
from decimal import Decimal

# ================= Presupuesto =================
class PresupuestoBase(BaseModel):
    id_cotizacion: Optional[int] = None
    fecha_presupuesto: date
    monto_mano_obra: Optional[Decimal] = None
    monto_materiales: Optional[Decimal] = None
    estatus: str = "PENDIENTE"

class PresupuestoCreate(PresupuestoBase):
    creado_por: int
    actualizado_por: int

class PresupuestoUpdate(BaseModel):
    id_cotizacion: Optional[int] = None
    fecha_presupuesto: Optional[date] = None
    monto_mano_obra: Optional[Decimal] = None
    monto_materiales: Optional[Decimal] = None
    estatus: Optional[str] = None
    actualizado_por: int

class PresupuestoResponse(PresupuestoBase):
    id_presupuesto: int
    activo: bool
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int

    model_config = ConfigDict(from_attributes=True)

# ================= Cotizacion =================
class CotizacionBase(BaseModel):
    id_cliente: int
    id_iguala: Optional[int] = None
    fecha_cotizacion: date
    subtotal: Optional[Decimal] = None
    iva: Optional[Decimal] = None
    total: Optional[Decimal] = None
    estatus: str = "PENDIENTE"

class CotizacionCreate(CotizacionBase):
    creado_por: int
    actualizado_por: int

class CotizacionUpdate(BaseModel):
    id_cliente: Optional[int] = None
    id_iguala: Optional[int] = None
    fecha_cotizacion: Optional[date] = None
    subtotal: Optional[Decimal] = None
    iva: Optional[Decimal] = None
    total: Optional[Decimal] = None
    estatus: Optional[str] = None
    actualizado_por: int

class CotizacionResponse(CotizacionBase):
    id_cotizacion: int
    activo: bool
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int

    model_config = ConfigDict(from_attributes=True)
