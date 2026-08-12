from typing import List, Optional
from supabase import Client
from fastapi import HTTPException, status
from app.schemas.contrato import ContratoCreate, ContratoUpdate, ContratoResponse

class ContratoService:
    def __init__(self, supabase: Client):
        self.supabase = supabase
        self.table = "contrato"

    def get_all(self) -> List[ContratoResponse]:
        response = self.supabase.table(self.table).select("*").eq("activo", True).execute()
        return [ContratoResponse(**item) for item in response.data]

    def get_by_id(self, contrato_id: int) -> Optional[ContratoResponse]:
        response = self.supabase.table(self.table).select("*").eq("id_contrato", contrato_id).eq("activo", True).execute()
        if not response.data:
            return None
        return ContratoResponse(**response.data[0])

    def get_by_cliente(self, cliente_id: int) -> List[ContratoResponse]:
        response = self.supabase.table(self.table).select("*").eq("id_cliente", cliente_id).eq("activo", True).execute()
        return [ContratoResponse(**item) for item in response.data]

    def create(self, contrato_in: ContratoCreate) -> ContratoResponse:
        try:
            # Check if numero_contrato already exists
            existing = self.supabase.table(self.table).select("id_contrato").eq("numero_contrato", contrato_in.numero_contrato).execute()
            if existing.data:
                raise HTTPException(status_code=400, detail="El número de contrato ya existe.")
                
            # Date serialization issue fix (supabase-py might need dict parsing)
            data_to_insert = contrato_in.model_dump(mode='json')
            response = self.supabase.table(self.table).insert(data_to_insert).execute()
            return ContratoResponse(**response.data[0])
        except Exception as e:
            if isinstance(e, HTTPException):
                raise e
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def update(self, contrato_id: int, contrato_in: ContratoUpdate) -> Optional[ContratoResponse]:
        existing = self.get_by_id(contrato_id)
        if not existing:
            return None
        
        update_data = contrato_in.model_dump(exclude_unset=True, mode='json')
        if not update_data:
            return existing

        response = self.supabase.table(self.table).update(update_data).eq("id_contrato", contrato_id).execute()
        if not response.data:
            return None
        return ContratoResponse(**response.data[0])

    def delete(self, contrato_id: int) -> bool:
        # Soft delete
        response = self.supabase.table(self.table).update({"activo": False}).eq("id_contrato", contrato_id).execute()
        return len(response.data) > 0
