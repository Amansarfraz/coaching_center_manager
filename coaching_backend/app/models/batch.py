from beanie import Document
from datetime import datetime
from typing import Optional


class Batch(Document):
    batch_name: str
    course_name: str
    teacher_id: str
    teacher_name: str
    classroom: str
    timing: str
    student_capacity: int
    total_students: int = 0
    start_date: datetime
    end_date: Optional[datetime] = None
    status: str = "active"  # active, completed, upcoming
    created_at: datetime = datetime.utcnow()

    class Settings:
        name = "batches"