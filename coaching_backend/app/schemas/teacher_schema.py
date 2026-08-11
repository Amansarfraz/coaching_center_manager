from pydantic import BaseModel
from typing import Optional, List


class TeacherCreateSchema(BaseModel):
    full_name: str
    subject: str
    qualification: Optional[str] = ""
    phone: str
    email: Optional[str] = ""
    gender: str
    joining_date: str
    salary: float
    assigned_subjects: List[str] = []
    assigned_batch_ids: List[str] = []
    profile_image: Optional[str] = None


class TeacherUpdateSchema(BaseModel):
    full_name: Optional[str] = None
    subject: Optional[str] = None
    qualification: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    gender: Optional[str] = None
    joining_date: Optional[str] = None
    salary: Optional[float] = None
    assigned_subjects: Optional[List[str]] = None
    assigned_batch_ids: Optional[List[str]] = None
    profile_image: Optional[str] = None
    status: Optional[str] = None