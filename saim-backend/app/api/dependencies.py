from fastapi import Depends
from supabase import Client
from app.core.database import supabase_client
from app.services.cliente_service import ClienteService
from app.services.contrato_service import ContratoService
from app.services.tienda_service import TiendaService
from app.services.servicio_service import ServicioService
from app.services.iguala_service import IgualaService
from app.services.cuadrilla_service import CuadrillaService
from app.services.inventario_service import InventarioService
from app.services.finanzas_service import FinanzasService

def get_supabase() -> Client:
    return supabase_client

def get_cliente_service(supabase: Client = Depends(get_supabase)) -> ClienteService:
    return ClienteService(supabase)

def get_contrato_service(supabase: Client = Depends(get_supabase)) -> ContratoService:
    return ContratoService(supabase)

def get_tienda_service(supabase: Client = Depends(get_supabase)) -> TiendaService:
    return TiendaService(supabase)

def get_servicio_service(supabase: Client = Depends(get_supabase)) -> ServicioService:
    return ServicioService(supabase)

def get_iguala_service(supabase: Client = Depends(get_supabase)) -> IgualaService:
    return IgualaService(supabase)

def get_cuadrilla_service(supabase: Client = Depends(get_supabase)) -> CuadrillaService:
    return CuadrillaService(supabase)

def get_inventario_service(supabase: Client = Depends(get_supabase)) -> InventarioService:
    return InventarioService(supabase)

def get_finanzas_service(supabase: Client = Depends(get_supabase)) -> FinanzasService:
    return FinanzasService(supabase)
