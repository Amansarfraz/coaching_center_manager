from fastapi import APIRouter
from datetime import datetime

from app.models.attendance import Attendance
from app.models.batch import Batch
from app.schemas.attendance_schema import AttendanceMarkSchema

router = APIRouter(prefix="/api/attendance", tags=["Attendance"])


@router.post("/mark")
async def mark_attendance(data: AttendanceMarkSchema):
    batch = await Batch.get(data.batch_id)
    batch_name = batch.batch_name if batch else ""
    date_obj = datetime.fromisoformat(data.date)

    # Purane records isi batch aur date ke liye delete karo (re-mark ki suurat mein)
    existing = await Attendance.find(
        Attendance.batch_id == data.batch_id,
        Attendance.date == date_obj,
    ).to_list()
    for record in existing:
        await record.delete()

    for entry in data.attendance:
        attendance = Attendance(
            student_id=entry.get("student_id", ""),
            student_name=entry.get("student_name", ""),
            batch_id=data.batch_id,
            batch_name=batch_name,
            date=date_obj,
            status=entry.get("status", "present"),
            marked_by="admin",
        )
        await attendance.insert()

    return {"message": "Attendance marked successfully"}


@router.get("")
async def get_attendance_by_date(batch_id: str, date: str):
    date_obj = datetime.fromisoformat(date)
    records = await Attendance.find(
        Attendance.batch_id == batch_id,
        Attendance.date == date_obj,
    ).to_list()
    return {"attendance": records}


@router.get("/student/{student_id}")
async def get_student_attendance_history(student_id: str):
    records = await Attendance.find(Attendance.student_id == student_id).to_list()
    return {"attendance": records}