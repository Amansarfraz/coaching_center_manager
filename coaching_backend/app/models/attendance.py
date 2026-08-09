from beanie import Document
from datetime import datetime


class Attendance(Document):
    student_id: str
    student_name: str
    batch_id: str
    batch_name: str
    date: datetime
    status: str  # present, absent, leave
    marked_by: str
    created_at: datetime = datetime.utcnow()

    class Settings:
        name = "attendance"