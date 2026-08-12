from typing import List, Optional
from supabase import Client
from fastapi import HTTPException, status
from app.schemas.iguala import IgualaCreate, IgualaUpdate, IgualaResponse

class IgualaService:
    def __init__(self, supabase: Client):
        self.supabase = supabase
        self.table = "iguala"
        self.table_rel = "iguala_tienda"

    def get_all(self) -> List[IgualaResponse]:
        response = self.supabase.table(self.table).select("*").eq("activo", True).execute()
        return [IgualaResponse(**item) for item in response.data]

    def get_by_id(self, iguala_id: int) -> Optional[IgualaResponse]:
        response = self.supabase.table(self.table).select("*").eq("id_iguala", iguala_id).eq("activo", True).execute()
        if not response.data:
            return None
        return IgualaResponse(**response.data[0])

    def create(self, iguala_in: IgualaCreate) -> IgualaResponse:
        try:
            # 1. Separar ids_tiendas del payload
            data_to_insert = iguala_in.model_dump(exclude={"ids_tiendas"}, mode='json')
            
            # 2. Insertar iguala
            response = self.supabase.table(self.table).insert(data_to_insert).execute()
            nueva_iguala = response.data[0]
            id_iguala = nueva_iguala["id_iguala"]
            
            # 3. Insertar relaciones en iguala_tienda si existen
            if iguala_in.ids_tiendas:
                relaciones = [
                    {"id_iguala": id_iguala, "id_tienda": id_tienda}
                    for id_tienda in iguala_in.ids_tiendas
                ]
                self.supabase.table(self.table_rel).insert(relaciones).execute()
                
            return IgualaResponse(**nueva_iguala)
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def update(self, iguala_id: int, iguala_in: IgualaUpdate) -> Optional[IgualaResponse]:
        existing = self.get_by_id(iguala_id)
        if not existing:
            return None
        
        try:
            update_data = iguala_in.model_dump(exclude={"ids_tiendas"}, exclude_unset=True, mode='json')
            if update_data:
                response = self.supabase.table(self.table).update(update_data).eq("id_iguala", iguala_id).execute()
                if not response.data:
                    return None
            
            # Si se envían ids_tiendas, borramos y recreamos las relaciones
            if iguala_in.ids_tiendas is not None:
                self.supabase.table(self.table_rel).delete().eq("id_iguala", iguala_id).execute()
                
                if iguala_in.ids_tiendas:
                    relaciones = [
                        {"id_iguala": iguala_id, "id_tienda": id_tienda}
                        for id_tienda in iguala_in.ids_tiendas
                    ]
                    self.supabase.table(self.table_rel).insert(relaciones).execute()
                    
            return self.get_by_id(iguala_id)
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def delete(self, iguala_id: int) -> bool:
        # Soft delete
        response = self.supabase.table(self.table).update({"activo": False}).eq("id_iguala", iguala_id).execute()
        return len(response.data) > 0
