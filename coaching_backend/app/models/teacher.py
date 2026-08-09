from beanie import Document
from datetime import datetime
from typing import Optional, List


class Teacher(Document):
    full_name: str
    subject: str
    qualification: str
    phone: str
    email: Optional[str] = ""
    gender: str
    joining_date: datetime
    salary: float
    assigned_subjects: List[str] = []
    assigned_batch_ids: List[str] = []
    profile_image: Optional[str] = None
    status: str = "active"  # active, inactive
    created_at: datetime = datetime.utcnow()

    class Settings:
        name = "teachers"