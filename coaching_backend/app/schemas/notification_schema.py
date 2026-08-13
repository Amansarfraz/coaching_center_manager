from pydantic import BaseModel


class NotificationCreateSchema(BaseModel):
    title: str
    message: str
    target_role: str
    related_type: str = ""