from typing import List, Optional
from app.schemas.zona import ZonaCreate, ZonaUpdate
from app.core.database import supabase_client
from datetime import datetime

class ZonaService:
    def __init__(self, client=None):
        self.client = client or supabase_client

    def get_all(self) -> List[dict]:
        response = self.client.table('zona').select('*').order('id_zona').execute()
        return response.data

    def get_by_id(self, id_zona: int) -> Optional[dict]:
        response = self.client.table('zona').select('*').eq('id_zona', id_zona).execute()
        return response.data[0] if response.data else None

    def create(self, zona: ZonaCreate) -> dict:
        data = zona.model_dump()
        response = self.client.table('zona').insert(data).execute()
        return response.data[0]

    def update(self, id_zona: int, zona: ZonaUpdate) -> Optional[dict]:
        data = zona.model_dump(exclude_unset=True)
        data['actualizado_en'] = datetime.now().isoformat()
        response = self.client.table('zona').update(data).eq('id_zona', id_zona).execute()
        return response.data[0] if response.data else None

    def delete(self, id_zona: int, actualizado_por: int) -> bool:
        data = {
            'activo': False,
            'actualizado_por': actualizado_por,
            'actualizado_en': datetime.now().isoformat()
        }
        response = self.client.table('zona').update(data).eq('id_zona', id_zona).execute()
        return len(response.data) > 0
