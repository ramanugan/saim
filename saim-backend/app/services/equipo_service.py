from typing import List, Optional
from supabase import Client
from fastapi import HTTPException, status
from app.schemas.equipo import EquipoCreate, EquipoUpdate, EquipoResponse

class EquipoService:
    def __init__(self, supabase: Client):
        self.supabase = supabase
        self.table = "equipo"

    def _map_response(self, item: dict) -> EquipoResponse:
        # Extraer nombre_tienda y nombre_tipo_equipo del join de Supabase
        tienda = item.pop("tienda", None)
        tipo_equipo = item.pop("tipo_equipo", None)
        
        if tienda and isinstance(tienda, dict):
            item["nombre_tienda"] = tienda.get("nombre")
        if tipo_equipo and isinstance(tipo_equipo, dict):
            item["nombre_tipo_equipo"] = tipo_equipo.get("nombre")
            
        return EquipoResponse(**item)

    def get_all(self) -> List[EquipoResponse]:
        response = self.supabase.table(self.table)\
            .select("*, tienda(nombre), tipo_equipo(nombre)")\
            .eq("activo", True)\
            .execute()
        return [self._map_response(item) for item in response.data]

    def get_by_id(self, equipo_id: int) -> Optional[EquipoResponse]:
        response = self.supabase.table(self.table)\
            .select("*, tienda(nombre), tipo_equipo(nombre)")\
            .eq("id_equipo", equipo_id)\
            .eq("activo", True)\
            .execute()
        if not response.data:
            return None
        return self._map_response(response.data[0])

    def create(self, equipo_in: EquipoCreate) -> EquipoResponse:
        try:
            # We insert and then fetch to get the JOIN data
            insert_response = self.supabase.table(self.table).insert(
                equipo_in.model_dump(mode="json") # mode=json to handle dates correctly
            ).execute()
            
            new_id = insert_response.data[0]["id_equipo"]
            return self.get_by_id(new_id)
        except Exception as e:
            if isinstance(e, HTTPException):
                raise e
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def update(self, equipo_id: int, equipo_in: EquipoUpdate) -> Optional[EquipoResponse]:
        existing = self.get_by_id(equipo_id)
        if not existing:
            return None
        
        update_data = equipo_in.model_dump(exclude_unset=True, mode="json")
        if not update_data:
            return existing

        self.supabase.table(self.table).update(update_data).eq("id_equipo", equipo_id).execute()
        return self.get_by_id(equipo_id)

    def delete(self, equipo_id: int) -> bool:
        response = self.supabase.table(self.table).update({"activo": False}).eq("id_equipo", equipo_id).execute()
        return len(response.data) > 0
