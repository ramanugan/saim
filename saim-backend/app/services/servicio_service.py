from typing import List, Optional
from supabase import Client
from fastapi import HTTPException, status
from app.schemas.servicio import (
    CategoriaServicioCreate, CategoriaServicioUpdate, CategoriaServicioResponse,
    ServicioCreate, ServicioUpdate, ServicioResponse
)

class ServicioService:
    def __init__(self, supabase: Client):
        self.supabase = supabase
        self.table_cat = "categoria_servicio"
        self.table_srv = "servicio"

    # ================= CATEGORIAS =================
    def get_all_categorias(self) -> List[CategoriaServicioResponse]:
        response = self.supabase.table(self.table_cat).select("*").eq("activo", True).execute()
        return [CategoriaServicioResponse(**item) for item in response.data]

    def get_categoria_by_id(self, cat_id: int) -> Optional[CategoriaServicioResponse]:
        response = self.supabase.table(self.table_cat).select("*").eq("id_categoria_servicio", cat_id).eq("activo", True).execute()
        if not response.data:
            return None
        return CategoriaServicioResponse(**response.data[0])

    def create_categoria(self, cat_in: CategoriaServicioCreate) -> CategoriaServicioResponse:
        try:
            response = self.supabase.table(self.table_cat).insert(cat_in.model_dump()).execute()
            return CategoriaServicioResponse(**response.data[0])
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def update_categoria(self, cat_id: int, cat_in: CategoriaServicioUpdate) -> Optional[CategoriaServicioResponse]:
        existing = self.get_categoria_by_id(cat_id)
        if not existing:
            return None
        
        update_data = cat_in.model_dump(exclude_unset=True)
        if not update_data:
            return existing

        response = self.supabase.table(self.table_cat).update(update_data).eq("id_categoria_servicio", cat_id).execute()
        if not response.data:
            return None
        return CategoriaServicioResponse(**response.data[0])

    def delete_categoria(self, cat_id: int) -> bool:
        response = self.supabase.table(self.table_cat).update({"activo": False}).eq("id_categoria_servicio", cat_id).execute()
        return len(response.data) > 0

    # ================= SERVICIOS =================
    def get_all_servicios(self) -> List[ServicioResponse]:
        response = self.supabase.table(self.table_srv).select("*").eq("activo", True).execute()
        return [ServicioResponse(**item) for item in response.data]

    def get_servicio_by_id(self, srv_id: int) -> Optional[ServicioResponse]:
        response = self.supabase.table(self.table_srv).select("*").eq("id_servicio", srv_id).eq("activo", True).execute()
        if not response.data:
            return None
        return ServicioResponse(**response.data[0])

    def get_servicios_by_categoria(self, cat_id: int) -> List[ServicioResponse]:
        response = self.supabase.table(self.table_srv).select("*").eq("id_categoria_servicio", cat_id).eq("activo", True).execute()
        return [ServicioResponse(**item) for item in response.data]

    def create_servicio(self, srv_in: ServicioCreate) -> ServicioResponse:
        try:
            response = self.supabase.table(self.table_srv).insert(srv_in.model_dump()).execute()
            return ServicioResponse(**response.data[0])
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def update_servicio(self, srv_id: int, srv_in: ServicioUpdate) -> Optional[ServicioResponse]:
        existing = self.get_servicio_by_id(srv_id)
        if not existing:
            return None
        
        update_data = srv_in.model_dump(exclude_unset=True)
        if not update_data:
            return existing

        response = self.supabase.table(self.table_srv).update(update_data).eq("id_servicio", srv_id).execute()
        if not response.data:
            return None
        return ServicioResponse(**response.data[0])

    def delete_servicio(self, srv_id: int) -> bool:
        response = self.supabase.table(self.table_srv).update({"activo": False}).eq("id_servicio", srv_id).execute()
        return len(response.data) > 0
