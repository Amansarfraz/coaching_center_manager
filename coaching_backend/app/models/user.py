from beanie import Document
from pydantic import EmailStr
from datetime import datetime
from typing import Optional


class User(Document):
    full_name: str
    email: EmailStr
    phone: str
    password_hash: str
    role: str  # 'admin', 'teacher', 'student'
    profile_image: Optional[str] = None
    created_at: datetime = datetime.utcnow()

    class Settings:
        name = "users"

    class Config:
        json_schema_extra = {
            "example": {
                "full_name": "Amjad Sarfraz",
                "email": "admin@example.com",
                "phone": "03001234567",
                "role": "admin",
            }
        }