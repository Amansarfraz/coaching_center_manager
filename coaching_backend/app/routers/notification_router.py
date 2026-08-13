from fastapi import APIRouter, HTTPException
from beanie import PydanticObjectId

from app.models.notification import Notification

router = APIRouter(prefix="/api/notifications", tags=["Notifications"])


@router.get("")
async def get_notifications(role: str):
    records = await Notification.find(
        Notification.target_role == role
    ).sort("-created_at").to_list()

    all_records = await Notification.find(Notification.target_role == "all").sort("-created_at").to_list()
    combined = records + all_records
    combined.sort(key=lambda n: n.created_at, reverse=True)

    return {"notifications": combined}


@router.put("/{notification_id}/read")
async def mark_as_read(notification_id: PydanticObjectId):
    notif = await Notification.get(notification_id)
    if not notif:
        raise HTTPException(status_code=404, detail="Notification not found")
    notif.is_read = True
    await notif.save()
    return notif


@router.put("/mark-all-read")
async def mark_all_read(role: str):
    records = await Notification.find(Notification.target_role == role).to_list()
    for r in records:
        r.is_read = True
        await r.save()
    return {"message": "All marked as read"}