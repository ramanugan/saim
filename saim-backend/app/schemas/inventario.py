from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from datetime import datetime

# ================= ProveedorRefaccion =================
class ProveedorRefaccionBase(BaseModel):
    nombre: str
    contacto: Optional[str] = None
    telefono: Optional[str] = None
    estatus: str = "ACTIVO"

class ProveedorRefaccionCreate(ProveedorRefaccionBase):
    creado_por: int
    actualizado_por: int

class ProveedorRefaccionUpdate(BaseModel):
    nombre: Optional[str] = None
    contacto: Optional[str] = None
    telefono: Optional[str] = None
    estatus: Optional[str] = None
    actualizado_por: int

class ProveedorRefaccionResponse(ProveedorRefaccionBase):
    id_proveedor_refaccion: int
    activo: bool
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int

    model_config = ConfigDict(from_attributes=True)

# ================= Refaccion =================
class RefaccionBase(BaseModel):
    nombre: str
    descripcion: Optional[str] = None
    estatus: str = "ACTIVA"

class RefaccionCreate(RefaccionBase):
    creado_por: int
    actualizado_por: int

class RefaccionUpdate(BaseModel):
    nombre: Optional[str] = None
    descripcion: Optional[str] = None
    estatus: Optional[str] = None
    actualizado_por: int

class RefaccionResponse(RefaccionBase):
    id_refaccion: int
    activo: bool
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int

    model_config = ConfigDict(from_attributes=True)

# ================= MovimientoInventario =================
class MovimientoInventarioCreate(BaseModel):
    id_refaccion: int
    tipo_movimiento: str # 'ENTRADA' o 'SALIDA'
    cantidad: int
    id_proveedor_refaccion: Optional[int] = None
    creado_por: int
    notas: Optional[str] = None

class MovimientoInventarioResponse(MovimientoInventarioCreate):
    id_movimiento: int
    fecha_movimiento: datetime

    model_config = ConfigDict(from_attributes=True)

# ================= InventarioRefaccion =================
class InventarioRefaccionResponse(BaseModel):
    id_inventario: int
    id_refaccion: int
    stock_actual: int
    stock_minimo: int
    fecha_ultima_actualizacion: datetime
    
    model_config = ConfigDict(from_attributes=True)
