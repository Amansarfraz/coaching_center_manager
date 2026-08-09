from beanie import Document
from datetime import datetime
from typing import Optional


class Student(Document):
    full_name: str
    father_name: str
    phone: str
    email: Optional[str] = ""
    home_address: Optional[str] = ""
    gender: str
    dob: datetime
    admission_date: datetime
    batch_id: str
    batch_name: str
    monthly_fee: float
    profile_image: Optional[str] = None
    status: str = "active"  # active, inactive, pending
    created_at: datetime = datetime.utcnow()

    class Settings:
        name = "students"