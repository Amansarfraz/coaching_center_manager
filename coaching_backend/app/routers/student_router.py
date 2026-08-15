from fastapi import APIRouter, HTTPException
from datetime import datetime
from beanie import PydanticObjectId

from app.models.student import Student
from app.schemas.student_schema import StudentCreateSchema, StudentUpdateSchema
from app.core.notification_helper import create_and_send_notification

router = APIRouter(prefix="/api/students", tags=["Students"])


@router.get("")
async def get_all_students():
    students = await Student.find_all().to_list()
    return {"students": students}


@router.get("/search")
async def search_students(q: str = ""):
    students = await Student.find_all().to_list()
    if q:
        q_lower = q.lower()
        students = [
            s for s in students
            if q_lower in s.full_name.lower() or q_lower in s.batch_name.lower() or q in s.phone
        ]
    return {"students": students}


@router.get("/{student_id}")
async def get_student(student_id: PydanticObjectId):
    student = await Student.get(student_id)
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")
    return student


@router.post("", status_code=201)
async def create_student(data: StudentCreateSchema):
    student = Student(
        full_name=data.full_name,
        father_name=data.father_name,
        phone=data.phone,
        email=data.email,
        home_address=data.home_address,
        gender=data.gender,
        dob=datetime.fromisoformat(data.dob),
        admission_date=datetime.fromisoformat(data.admission_date),
        batch_id=data.batch_id,
        batch_name=data.batch_name,
        monthly_fee=data.monthly_fee,
        profile_image=data.profile_image,
    )
    await student.insert()

    await create_and_send_notification(
        title="New Student Added",
        message=f"{data.full_name} joined {data.batch_name}",
        target_role="admin",
        related_type="student",
    )

    return student


@router.put("/{student_id}")
async def update_student(student_id: PydanticObjectId, data: StudentUpdateSchema):
    student = await Student.get(student_id)
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    update_data = data.dict(exclude_unset=True)

    if "dob" in update_data and update_data["dob"]:
        update_data["dob"] = datetime.fromisoformat(update_data["dob"])
    if "admission_date" in update_data and update_data["admission_date"]:
        update_data["admission_date"] = datetime.fromisoformat(update_data["admission_date"])

    for key, value in update_data.items():
        setattr(student, key, value)

    await student.save()
    return student


@router.delete("/{student_id}")
async def delete_student(student_id: PydanticObjectId):
    student = await Student.get(student_id)
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")
    await student.delete()
    return {"message": "Student deleted successfully"}