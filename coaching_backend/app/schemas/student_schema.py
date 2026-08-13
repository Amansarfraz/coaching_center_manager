from pydantic import BaseModel
from typing import Optional


class StudentCreateSchema(BaseModel):
    full_name: str
    father_name: str
    phone: str
    email: Optional[str] = ""
    home_address: Optional[str] = ""
    gender: str
    dob: str
    admission_date: str
    batch_id: str
    batch_name: str
    monthly_fee: float
    profile_image: Optional[str] = None


class StudentUpdateSchema(BaseModel):
    full_name: Optional[str] = None
    father_name: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    home_address: Optional[str] = None
    gender: Optional[str] = None
    dob: Optional[str] = None
    admission_date: Optional[str] = None
    batch_id: Optional[str] = None
    batch_name: Optional[str] = None
    monthly_fee: Optional[float] = None
    status: Optional[str] = None
    profile_image: Optional[str] = None