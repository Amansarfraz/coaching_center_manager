from pydantic import BaseModel
from typing import List, Dict


class AttendanceMarkSchema(BaseModel):
    batch_id: str
    date: str
    attendance: List[Dict[str, str]]