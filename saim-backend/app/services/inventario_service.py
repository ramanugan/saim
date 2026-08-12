from typing import List, Optional
from supabase import Client
from fastapi import HTTPException, status
from app.schemas.inventario import (
    ProveedorRefaccionCreate, ProveedorRefaccionUpdate, ProveedorRefaccionResponse,
    RefaccionCreate, RefaccionUpdate, RefaccionResponse,
    MovimientoInventarioCreate, MovimientoInventarioResponse, InventarioRefaccionResponse
)

class InventarioService:
    def __init__(self, supabase: Client):
        self.supabase = supabase
        self.table_prov = "proveedor_refaccion"
        self.table_ref = "refaccion"
        self.table_inv = "inventario_refaccion"
        self.table_mov = "movimiento_inventario"

    # ================= PROVEEDORES =================
    def get_all_proveedores(self) -> List[ProveedorRefaccionResponse]:
        response = self.supabase.table(self.table_prov).select("*").eq("activo", True).execute()
        return [ProveedorRefaccionResponse(**item) for item in response.data]

    def get_proveedor_by_id(self, prov_id: int) -> Optional[ProveedorRefaccionResponse]:
        response = self.supabase.table(self.table_prov).select("*").eq("id_proveedor_refaccion", prov_id).eq("activo", True).execute()
        if not response.data:
            return None
        return ProveedorRefaccionResponse(**response.data[0])

    def create_proveedor(self, prov_in: ProveedorRefaccionCreate) -> ProveedorRefaccionResponse:
        try:
            response = self.supabase.table(self.table_prov).insert(prov_in.model_dump()).execute()
            return ProveedorRefaccionResponse(**response.data[0])
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def update_proveedor(self, prov_id: int, prov_in: ProveedorRefaccionUpdate) -> Optional[ProveedorRefaccionResponse]:
        existing = self.get_proveedor_by_id(prov_id)
        if not existing:
            return None
        
        update_data = prov_in.model_dump(exclude_unset=True)
        if not update_data:
            return existing

        response = self.supabase.table(self.table_prov).update(update_data).eq("id_proveedor_refaccion", prov_id).execute()
        if not response.data:
            return None
        return ProveedorRefaccionResponse(**response.data[0])

    def delete_proveedor(self, prov_id: int) -> bool:
        response = self.supabase.table(self.table_prov).update({"activo": False}).eq("id_proveedor_refaccion", prov_id).execute()
        return len(response.data) > 0

    # ================= REFACCIONES =================
    def get_all_refacciones(self) -> List[RefaccionResponse]:
        response = self.supabase.table(self.table_ref).select("*").eq("activo", True).execute()
        return [RefaccionResponse(**item) for item in response.data]

    def get_refaccion_by_id(self, ref_id: int) -> Optional[RefaccionResponse]:
        response = self.supabase.table(self.table_ref).select("*").eq("id_refaccion", ref_id).eq("activo", True).execute()
        if not response.data:
            return None
        return RefaccionResponse(**response.data[0])

    def create_refaccion(self, ref_in: RefaccionCreate) -> RefaccionResponse:
        try:
            response = self.supabase.table(self.table_ref).insert(ref_in.model_dump()).execute()
            nueva_refaccion = response.data[0]
            
            # Inicializar inventario en 0
            self.supabase.table(self.table_inv).insert({
                "id_refaccion": nueva_refaccion["id_refaccion"],
                "stock_actual": 0,
                "stock_minimo": 0
            }).execute()
            
            return RefaccionResponse(**nueva_refaccion)
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

    def update_refaccion(self, ref_id: int, ref_in: RefaccionUpdate) -> Optional[RefaccionResponse]:
        existing = self.get_refaccion_by_id(ref_id)
        if not existing:
            return None
        
        update_data = ref_in.model_dump(exclude_unset=True)
        if not update_data:
            return existing

        response = self.supabase.table(self.table_ref).update(update_data).eq("id_refaccion", ref_id).execute()
        if not response.data:
            return None
        return RefaccionResponse(**response.data[0])

    def delete_refaccion(self, ref_id: int) -> bool:
        response = self.supabase.table(self.table_ref).update({"activo": False}).eq("id_refaccion", ref_id).execute()
        return len(response.data) > 0
        
    # ================= INVENTARIO =================
    def get_inventario(self) -> List[InventarioRefaccionResponse]:
        response = self.supabase.table(self.table_inv).select("*").execute()
        return [InventarioRefaccionResponse(**item) for item in response.data]

    def register_movimiento(self, mov_in: MovimientoInventarioCreate) -> MovimientoInventarioResponse:
        try:
            # 1. Obtener stock actual
            inv_res = self.supabase.table(self.table_inv).select("*").eq("id_refaccion", mov_in.id_refaccion).execute()
            if not inv_res.data:
                raise HTTPException(status_code=404, detail="Inventario no encontrado para esta refacción.")
            
            stock_actual = inv_res.data[0]["stock_actual"]
            
            # 2. Validar y calcular nuevo stock
            nuevo_stock = stock_actual
            if mov_in.tipo_movimiento.upper() == 'ENTRADA':
                nuevo_stock += mov_in.cantidad
            elif mov_in.tipo_movimiento.upper() == 'SALIDA':
                if stock_actual < mov_in.cantidad:
                    raise HTTPException(status_code=400, detail="Stock insuficiente para realizar la salida.")
                nuevo_stock -= mov_in.cantidad
            else:
                raise HTTPException(status_code=400, detail="Tipo de movimiento inválido.")
                
            # 3. Insertar movimiento
            mov_response = self.supabase.table(self.table_mov).insert(mov_in.model_dump()).execute()
            
            # 4. Actualizar inventario
            self.supabase.table(self.table_inv).update({"stock_actual": nuevo_stock}).eq("id_refaccion", mov_in.id_refaccion).execute()
            
            return MovimientoInventarioResponse(**mov_response.data[0])
        except Exception as e:
            if isinstance(e, HTTPException):
                raise e
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
