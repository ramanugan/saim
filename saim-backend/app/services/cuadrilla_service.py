from typing import List, Optional
from supabase import Client
from fastapi import HTTPException, status
from app.schemas.cuadrilla import (
    TecnicoCreate, TecnicoUpdate, TecnicoResponse,
    CuadrillaCreate, CuadrillaUpdate, CuadrillaResponse
)

class CuadrillaService:
    def __init__(self, supabase: Client):
        self.supabase = supabase
        self.table_tec = "tecnico"
        self.table_cua = "cuadrilla"
        self.table_rel = "cuadrilla_tecnico"

    # ================= TECNICOS =================
    def get_all_tecnicos(self) -> List[TecnicoResponse]:
        response = self.supabase.table(self.table_tec).select("*").eq("activo", True).execute()
        return [TecnicoResponse(**item) for item in response.data]

    def get_tecnico_by_id(self, tec_id: int) -> Optional[TecnicoResponse]:
        response = self.supabase.table(self.table_tec).select("*").eq("id_tecnico", tec_id).eq("activo", True).execute()
        if not response.data:
            return None
        return TecnicoResponse(**response.data[0])

    def create_tecnico(self, tec_in: TecnicoCreate) -> TecnicoResponse:
        try:
            response = self.supabase.table(self.table_tec).insert(tec_in.model_dump()).execute()
            return TecnicoResponse(**response.data[0])
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def update_tecnico(self, tec_id: int, tec_in: TecnicoUpdate) -> Optional[TecnicoResponse]:
        existing = self.get_tecnico_by_id(tec_id)
        if not existing:
            return None
        
        update_data = tec_in.model_dump(exclude_unset=True)
        if not update_data:
            return existing

        response = self.supabase.table(self.table_tec).update(update_data).eq("id_tecnico", tec_id).execute()
        if not response.data:
            return None
        return TecnicoResponse(**response.data[0])

    def delete_tecnico(self, tec_id: int) -> bool:
        response = self.supabase.table(self.table_tec).update({"activo": False}).eq("id_tecnico", tec_id).execute()
        return len(response.data) > 0

    # ================= CUADRILLAS =================
    def get_all_cuadrillas(self) -> List[CuadrillaResponse]:
        response = self.supabase.table(self.table_cua).select("*").eq("activo", True).execute()
        return [CuadrillaResponse(**item) for item in response.data]

    def get_cuadrilla_by_id(self, cua_id: int) -> Optional[CuadrillaResponse]:
        response = self.supabase.table(self.table_cua).select("*").eq("id_cuadrilla", cua_id).eq("activo", True).execute()
        if not response.data:
            return None
        return CuadrillaResponse(**response.data[0])

    def create_cuadrilla(self, cua_in: CuadrillaCreate) -> CuadrillaResponse:
        try:
            data_to_insert = cua_in.model_dump(exclude={"ids_tecnicos"}, mode='json')
            
            response = self.supabase.table(self.table_cua).insert(data_to_insert).execute()
            nueva_cuadrilla = response.data[0]
            id_cuadrilla = nueva_cuadrilla["id_cuadrilla"]
            
            if cua_in.ids_tecnicos:
                relaciones = [
                    {"id_cuadrilla": id_cuadrilla, "id_tecnico": id_tecnico}
                    for id_tecnico in cua_in.ids_tecnicos
                ]
                self.supabase.table(self.table_rel).insert(relaciones).execute()
                
            return CuadrillaResponse(**nueva_cuadrilla)
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def update_cuadrilla(self, cua_id: int, cua_in: CuadrillaUpdate) -> Optional[CuadrillaResponse]:
        existing = self.get_cuadrilla_by_id(cua_id)
        if not existing:
            return None
        
        try:
            update_data = cua_in.model_dump(exclude={"ids_tecnicos"}, exclude_unset=True, mode='json')
            if update_data:
                response = self.supabase.table(self.table_cua).update(update_data).eq("id_cuadrilla", cua_id).execute()
                if not response.data:
                    return None
            
            if cua_in.ids_tecnicos is not None:
                self.supabase.table(self.table_rel).delete().eq("id_cuadrilla", cua_id).execute()
                
                if cua_in.ids_tecnicos:
                    relaciones = [
                        {"id_cuadrilla": cua_id, "id_tecnico": id_tecnico}
                        for id_tecnico in cua_in.ids_tecnicos
                    ]
                    self.supabase.table(self.table_rel).insert(relaciones).execute()
                    
            return self.get_cuadrilla_by_id(cua_id)
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def delete_cuadrilla(self, cua_id: int) -> bool:
        response = self.supabase.table(self.table_cua).update({"activo": False}).eq("id_cuadrilla", cua_id).execute()
        return len(response.data) > 0
