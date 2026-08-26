from fastapi import APIRouter
from app.api.endpoints import clientes, contratos, tiendas, igualas, servicios, categorias_servicios
from app.api.endpoints import cuadrillas, tecnicos, refacciones, inventario, presupuestos, cotizaciones, tipo_equipo, equipo

api_router = APIRouter()

api_router.include_router(clientes.router, prefix="/clientes", tags=["Clientes"])
api_router.include_router(contratos.router, prefix="/contratos", tags=["Contratos"])
api_router.include_router(tiendas.router, prefix="/tiendas", tags=["Tiendas"])
api_router.include_router(igualas.router, prefix="/igualas", tags=["Igualas"])
api_router.include_router(servicios.router, prefix="/servicios", tags=["Servicios"])
api_router.include_router(categorias_servicios.router, prefix="/categorias-servicios", tags=["Categorias de Servicios"])
api_router.include_router(tecnicos.router, prefix="/tecnicos", tags=["Técnicos"])
api_router.include_router(cuadrillas.router, prefix="/cuadrillas", tags=["Cuadrillas"])
api_router.include_router(refacciones.router, prefix="/refacciones", tags=["Refacciones"])
api_router.include_router(inventario.router, prefix="/inventario", tags=["Inventario"])
api_router.include_router(presupuestos.router, prefix="/presupuestos", tags=["Presupuestos"])
api_router.include_router(cotizaciones.router, prefix="/cotizaciones", tags=["Cotizaciones"])
api_router.include_router(tipo_equipo.router, prefix="/tipos-equipo", tags=["Tipos de Equipo"])
api_router.include_router(equipo.router, prefix="/equipos", tags=["Equipos"])
