from typing import List, Optional
from supabase import Client
from fastapi import HTTPException, status
from app.schemas.cliente import ClienteCreate, ClienteUpdate, ClienteResponse

class ClienteService:
    def __init__(self, supabase: Client):
        self.supabase = supabase
        self.table = "cliente"

    def get_all(self) -> List[ClienteResponse]:
        response = self.supabase.table(self.table).select("*").eq("activo", True).execute()
        return [ClienteResponse(**item) for item in response.data]

    def get_by_id(self, cliente_id: int) -> Optional[ClienteResponse]:
        response = self.supabase.table(self.table).select("*").eq("id_cliente", cliente_id).eq("activo", True).execute()
        if not response.data:
            return None
        return ClienteResponse(**response.data[0])

    def create(self, cliente_in: ClienteCreate) -> ClienteResponse:
        try:
            # Check if codigo already exists
            existing = self.supabase.table(self.table).select("id_cliente").eq("codigo", cliente_in.codigo).execute()
            if existing.data:
                raise HTTPException(status_code=400, detail="El código de cliente ya existe.")
            
            response = self.supabase.table(self.table).insert(cliente_in.model_dump()).execute()
            return ClienteResponse(**response.data[0])
        except Exception as e:
            if isinstance(e, HTTPException):
                raise e
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def update(self, cliente_id: int, cliente_in: ClienteUpdate) -> Optional[ClienteResponse]:
        existing = self.get_by_id(cliente_id)
        if not existing:
            return None
        
        update_data = cliente_in.model_dump(exclude_unset=True)
        if not update_data:
            return existing

        response = self.supabase.table(self.table).update(update_data).eq("id_cliente", cliente_id).execute()
        if not response.data:
            return None
        return ClienteResponse(**response.data[0])

    def delete(self, cliente_id: int) -> bool:
        # Soft delete
        response = self.supabase.table(self.table).update({"activo": False}).eq("id_cliente", cliente_id).execute()
        return len(response.data) > 0
