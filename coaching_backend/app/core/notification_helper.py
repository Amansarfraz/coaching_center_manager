from datetime import datetime
from app.models.notification import Notification
from app.core.websocket_manager import manager


async def create_and_send_notification(title: str, message: str, target_role: str, related_type: str = ""):
    notif = Notification(
        title=title,
        message=message,
        target_role=target_role,
        related_type=related_type,
        is_read=False,
        created_at=datetime.utcnow(),
    )
    await notif.insert()

    await manager.send_to_role(
        target_role,
        {
            "id": str(notif.id),
            "title": title,
            "message": message,
            "target_role": target_role,
            "related_type": related_type,
            "is_read": False,
        },
    )
    return notif