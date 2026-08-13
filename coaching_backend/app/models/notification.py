from beanie import Document
from datetime import datetime


class Notification(Document):
    title: str
    message: str
    target_role: str  # "admin", "teacher", "student", "all"
    related_type: str = ""  # "student", "teacher", "batch", "fee", "attendance"
    is_read: bool = False
    created_at: datetime = datetime.utcnow()

    class Settings:
        name = "notifications"