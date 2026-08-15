from fastapi import APIRouter, HTTPException
from datetime import datetime
from beanie import PydanticObjectId

from app.models.teacher import Teacher
from app.schemas.teacher_schema import TeacherCreateSchema, TeacherUpdateSchema
from app.models.notification import Notification
from app.core.notification_helper import create_and_send_notification

router = APIRouter(prefix="/api/teachers", tags=["Teachers"])


@router.get("")
async def get_all_teachers():
    teachers = await Teacher.find_all().to_list()
    return {"teachers": teachers}


@router.get("/search")
async def search_teachers(q: str = ""):
    teachers = await Teacher.find_all().to_list()
    if q:
        q_lower = q.lower()
        teachers = [
            t for t in teachers
            if q_lower in t.full_name.lower() or q_lower in t.subject.lower() or q in t.phone
        ]
    return {"teachers": teachers}


@router.get("/{teacher_id}")
async def get_teacher(teacher_id: PydanticObjectId):
    teacher = await Teacher.get(teacher_id)
    if not teacher:
        raise HTTPException(status_code=404, detail="Teacher not found")
    return teacher


@router.post("", status_code=201)
async def create_teacher(data: TeacherCreateSchema):
    teacher = Teacher(
        full_name=data.full_name,
        subject=data.subject,
        qualification=data.qualification,
        phone=data.phone,
        email=data.email,
        gender=data.gender,
        joining_date=datetime.fromisoformat(data.joining_date),
        salary=data.salary,
        assigned_subjects=data.assigned_subjects,
        assigned_batch_ids=data.assigned_batch_ids,
        profile_image=data.profile_image,
    )
    await teacher.insert()
    await create_and_send_notification(
        title="New Teacher Added",
        message=f"{data.full_name} joined as {data.subject} teacher",
        target_role="admin",
        related_type="teacher",
    )
    notif = Notification(
        title="New Teacher Added",
        message=f"{data.full_name} joined as {data.subject} teacher",
        target_role="admin",
        related_type="teacher",
        created_at=datetime.utcnow(),
    )
    await notif.insert()
    return teacher


@router.put("/{teacher_id}")
async def update_teacher(teacher_id: PydanticObjectId, data: TeacherUpdateSchema):
    teacher = await Teacher.get(teacher_id)
    if not teacher:
        raise HTTPException(status_code=404, detail="Teacher not found")

    update_data = data.dict(exclude_unset=True)

    if "joining_date" in update_data and update_data["joining_date"]:
        update_data["joining_date"] = datetime.fromisoformat(update_data["joining_date"])

    for key, value in update_data.items():
        setattr(teacher, key, value)

    await teacher.save()
    return teacher


@router.delete("/{teacher_id}")
async def delete_teacher(teacher_id: PydanticObjectId):
    teacher = await Teacher.get(teacher_id)
    if not teacher:
        raise HTTPException(status_code=404, detail="Teacher not found")
    await teacher.delete()
    return {"message": "Teacher deleted successfully"}