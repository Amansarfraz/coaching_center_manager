from pydantic import BaseModel
from typing import Optional


class BatchCreateSchema(BaseModel):
    batch_name: str
    course_name: str
    teacher_id: str
    teacher_name: str
    classroom: str
    timing: str
    student_capacity: int
    start_date: str
    end_date: Optional[str] = None


class BatchUpdateSchema(BaseModel):
    batch_name: Optional[str] = None
    course_name: Optional[str] = None
    teacher_id: Optional[str] = None
    teacher_name: Optional[str] = None
    classroom: Optional[str] = None
    timing: Optional[str] = None
    student_capacity: Optional[int] = None
    total_students: Optional[int] = None
    start_date: Optional[str] = None
    end_date: Optional[str] = None
    status: Optional[str] = None