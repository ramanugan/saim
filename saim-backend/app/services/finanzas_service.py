from typing import List, Optional
from supabase import Client
from fastapi import HTTPException, status
from app.schemas.finanzas import (
    PresupuestoCreate, PresupuestoUpdate, PresupuestoResponse,
    CotizacionCreate, CotizacionUpdate, CotizacionResponse
)

class FinanzasService:
    def __init__(self, supabase: Client):
        self.supabase = supabase
        self.table_pre = "presupuesto"
        self.table_cot = "cotizacion"

    # ================= PRESUPUESTOS =================
    def get_all_presupuestos(self) -> List[PresupuestoResponse]:
        response = self.supabase.table(self.table_pre).select("*").eq("activo", True).execute()
        return [PresupuestoResponse(**item) for item in response.data]

    def get_presupuesto_by_id(self, pre_id: int) -> Optional[PresupuestoResponse]:
        response = self.supabase.table(self.table_pre).select("*").eq("id_presupuesto", pre_id).eq("activo", True).execute()
        if not response.data:
            return None
        return PresupuestoResponse(**response.data[0])

    def create_presupuesto(self, pre_in: PresupuestoCreate) -> PresupuestoResponse:
        try:
            data = pre_in.model_dump(mode='json')
            response = self.supabase.table(self.table_pre).insert(data).execute()
            return PresupuestoResponse(**response.data[0])
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def update_presupuesto(self, pre_id: int, pre_in: PresupuestoUpdate) -> Optional[PresupuestoResponse]:
        existing = self.get_presupuesto_by_id(pre_id)
        if not existing:
            return None
        
        update_data = pre_in.model_dump(exclude_unset=True, mode='json')
        if not update_data:
            return existing

        response = self.supabase.table(self.table_pre).update(update_data).eq("id_presupuesto", pre_id).execute()
        if not response.data:
            return None
        return PresupuestoResponse(**response.data[0])

    def delete_presupuesto(self, pre_id: int) -> bool:
        response = self.supabase.table(self.table_pre).update({"activo": False}).eq("id_presupuesto", pre_id).execute()
        return len(response.data) > 0

    # ================= COTIZACIONES =================
    def get_all_cotizaciones(self) -> List[CotizacionResponse]:
        response = self.supabase.table(self.table_cot).select("*").eq("activo", True).execute()
        return [CotizacionResponse(**item) for item in response.data]

    def get_cotizacion_by_id(self, cot_id: int) -> Optional[CotizacionResponse]:
        response = self.supabase.table(self.table_cot).select("*").eq("id_cotizacion", cot_id).eq("activo", True).execute()
        if not response.data:
            return None
        return CotizacionResponse(**response.data[0])

    def create_cotizacion(self, cot_in: CotizacionCreate) -> CotizacionResponse:
        try:
            data = cot_in.model_dump(mode='json')
            response = self.supabase.table(self.table_cot).insert(data).execute()
            return CotizacionResponse(**response.data[0])
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def update_cotizacion(self, cot_id: int, cot_in: CotizacionUpdate) -> Optional[CotizacionResponse]:
        existing = self.get_cotizacion_by_id(cot_id)
        if not existing:
            return None
        
        update_data = cot_in.model_dump(exclude_unset=True, mode='json')
        if not update_data:
            return existing

        response = self.supabase.table(self.table_cot).update(update_data).eq("id_cotizacion", cot_id).execute()
        if not response.data:
            return None
        return CotizacionResponse(**response.data[0])

    def delete_cotizacion(self, cot_id: int) -> bool:
        response = self.supabase.table(self.table_cot).update({"activo": False}).eq("id_cotizacion", cot_id).execute()
        return len(response.data) > 0
