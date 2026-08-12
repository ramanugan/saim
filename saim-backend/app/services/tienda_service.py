from typing import List, Optional
from supabase import Client
from fastapi import HTTPException, status
from app.schemas.tienda import TiendaCreate, TiendaUpdate, TiendaResponse

class TiendaService:
    def __init__(self, supabase: Client):
        self.supabase = supabase
        self.table = "tienda"

    def get_all(self) -> List[TiendaResponse]:
        response = self.supabase.table(self.table).select("*").eq("activo", True).execute()
        return [TiendaResponse(**item) for item in response.data]

    def get_by_id(self, tienda_id: int) -> Optional[TiendaResponse]:
        response = self.supabase.table(self.table).select("*").eq("id_tienda", tienda_id).eq("activo", True).execute()
        if not response.data:
            return None
        return TiendaResponse(**response.data[0])

    def get_by_cliente(self, cliente_id: int) -> List[TiendaResponse]:
        response = self.supabase.table(self.table).select("*").eq("id_cliente", cliente_id).eq("activo", True).execute()
        return [TiendaResponse(**item) for item in response.data]

    def create(self, tienda_in: TiendaCreate) -> TiendaResponse:
        try:
            # Check if determinante / codigo_tienda exists for same client?
            existing = self.supabase.table(self.table).select("id_tienda")\
                .eq("id_cliente", tienda_in.id_cliente)\
                .eq("codigo_tienda", tienda_in.codigo_tienda)\
                .execute()
            
            if existing.data:
                raise HTTPException(status_code=400, detail="El código de tienda ya existe para este cliente.")
                
            response = self.supabase.table(self.table).insert(tienda_in.model_dump()).execute()
            return TiendaResponse(**response.data[0])
        except Exception as e:
            if isinstance(e, HTTPException):
                raise e
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def update(self, tienda_id: int, tienda_in: TiendaUpdate) -> Optional[TiendaResponse]:
        existing = self.get_by_id(tienda_id)
        if not existing:
            return None
        
        update_data = tienda_in.model_dump(exclude_unset=True)
        if not update_data:
            return existing

        response = self.supabase.table(self.table).update(update_data).eq("id_tienda", tienda_id).execute()
        if not response.data:
            return None
        return TiendaResponse(**response.data[0])

    def delete(self, tienda_id: int) -> bool:
        # Soft delete
        response = self.supabase.table(self.table).update({"activo": False}).eq("id_tienda", tienda_id).execute()
        return len(response.data) > 0
