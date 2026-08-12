from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from datetime import datetime

# ================= Tecnico =================
class TecnicoBase(BaseModel):
    nombre: str
    apellidos: str
    especialidad: Optional[str] = None
    telefono: Optional[str] = None
    correo: Optional[str] = None
    estatus: str = "ACTIVO"

class TecnicoCreate(TecnicoBase):
    creado_por: int
    actualizado_por: int

class TecnicoUpdate(BaseModel):
    nombre: Optional[str] = None
    apellidos: Optional[str] = None
    especialidad: Optional[str] = None
    telefono: Optional[str] = None
    correo: Optional[str] = None
    estatus: Optional[str] = None
    actualizado_por: int

class TecnicoResponse(TecnicoBase):
    id_tecnico: int
    activo: bool
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int

    model_config = ConfigDict(from_attributes=True)

# ================= Cuadrilla =================
class CuadrillaBase(BaseModel):
    nombre: str
    zona_cobertura: Optional[str] = None
    estatus: str = "ACTIVA"

class CuadrillaCreate(CuadrillaBase):
    creado_por: int
    actualizado_por: int
    ids_tecnicos: Optional[List[int]] = [] # Arreglo para asociar técnicos

class CuadrillaUpdate(BaseModel):
    nombre: Optional[str] = None
    zona_cobertura: Optional[str] = None
    estatus: Optional[str] = None
    actualizado_por: int
    ids_tecnicos: Optional[List[int]] = None # Opcional: Si se manda, se sobrescriben

class CuadrillaResponse(CuadrillaBase):
    id_cuadrilla: int
    activo: bool
    creado_en: datetime
    creado_por: int
    actualizado_en: datetime
    actualizado_por: int

    model_config = ConfigDict(from_attributes=True)
