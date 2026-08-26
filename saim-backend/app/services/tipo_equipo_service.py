from typing import List, Optional
from supabase import Client
from fastapi import HTTPException, status
from app.schemas.tipo_equipo import TipoEquipoCreate, TipoEquipoUpdate, TipoEquipoResponse

class TipoEquipoService:
    def __init__(self, supabase: Client):
        self.supabase = supabase
        self.table = "tipo_equipo"

    def get_all(self) -> List[TipoEquipoResponse]:
        response = self.supabase.table(self.table).select("*").eq("activo", True).order("nombre").execute()
        return [TipoEquipoResponse(**item) for item in response.data]

    def get_by_id(self, tipo_equipo_id: int) -> Optional[TipoEquipoResponse]:
        response = self.supabase.table(self.table).select("*").eq("id_tipo_equipo", tipo_equipo_id).eq("activo", True).execute()
        if not response.data:
            return None
        return TipoEquipoResponse(**response.data[0])

    def create(self, tipo_in: TipoEquipoCreate) -> TipoEquipoResponse:
        try:
            existing = self.supabase.table(self.table).select("id_tipo_equipo")\
                .eq("codigo", tipo_in.codigo)\
                .execute()
            
            if existing.data:
                raise HTTPException(status_code=400, detail="El código del tipo de equipo ya existe.")
                
            response = self.supabase.table(self.table).insert(tipo_in.model_dump()).execute()
            return TipoEquipoResponse(**response.data[0])
        except Exception as e:
            if isinstance(e, HTTPException):
                raise e
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def update(self, tipo_equipo_id: int, tipo_in: TipoEquipoUpdate) -> Optional[TipoEquipoResponse]:
        existing = self.get_by_id(tipo_equipo_id)
        if not existing:
            return None
        
        update_data = tipo_in.model_dump(exclude_unset=True)
        if not update_data:
            return existing
            
        if "codigo" in update_data and update_data["codigo"] != existing.codigo:
             existing_code = self.supabase.table(self.table).select("id_tipo_equipo")\
                .eq("codigo", update_data["codigo"])\
                .execute()
             if existing_code.data:
                raise HTTPException(status_code=400, detail="El código del tipo de equipo ya existe.")

        response = self.supabase.table(self.table).update(update_data).eq("id_tipo_equipo", tipo_equipo_id).execute()
        if not response.data:
            return None
        return TipoEquipoResponse(**response.data[0])

    def delete(self, tipo_equipo_id: int) -> bool:
        response = self.supabase.table(self.table).update({"activo": False}).eq("id_tipo_equipo", tipo_equipo_id).execute()
        return len(response.data) > 0
