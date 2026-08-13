from fastapi import APIRouter
from datetime import datetime, timedelta, time

from app.models.student import Student
from app.models.teacher import Teacher
from app.models.batch import Batch
from app.models.attendance import Attendance
from app.models.fee import Fee

router = APIRouter(prefix="/api/dashboard", tags=["Dashboard"])


@router.get("/summary")
async def get_dashboard_summary():
    # ---------------- TODAY'S ATTENDANCE ----------------
    today = datetime.utcnow().date()
    start_of_day = datetime.combine(today, time.min)
    end_of_day = datetime.combine(today, time.max)

    today_records = await Attendance.find(
        Attendance.date >= start_of_day,
        Attendance.date <= end_of_day,
    ).to_list()

    total_today = len(today_records)
    present_today = len([r for r in today_records if r.status == "present"])
    absent_today = len([r for r in today_records if r.status == "absent"])
    attendance_percentage = round((present_today / total_today) * 100, 1) if total_today > 0 else 0

    # ---------------- FEE COLLECTION (current month) ----------------
    now = datetime.utcnow()
    month_name = now.strftime("%B %Y")

    all_fees = await Fee.find_all().to_list()
    month_fees = [f for f in all_fees if f.fee_month == month_name]

    total_target = sum(f.total_fee for f in month_fees)
    total_paid = sum(f.paid_amount for f in month_fees)
    paid_percentage = round((total_paid / total_target) * 100, 1) if total_target > 0 else 0

    # ---------------- RECENT ACTIVITY ----------------
    recent_students = await Student.find_all().sort("-created_at").limit(3).to_list()
    recent_teachers = await Teacher.find_all().sort("-created_at").limit(3).to_list()
    recent_batches = await Batch.find_all().sort("-created_at").limit(3).to_list()

    activity_list = []

    for s in recent_students:
        activity_list.append({
            "type": "student",
            "title": "New Student",
            "subtitle": f"{s.full_name} joined {s.batch_name}",
            "timestamp": s.created_at.isoformat(),
        })

    for t in recent_teachers:
        activity_list.append({
            "type": "teacher",
            "title": "New Teacher",
            "subtitle": f"{t.full_name} added ({t.subject})",
            "timestamp": t.created_at.isoformat(),
        })

    for b in recent_batches:
        activity_list.append({
            "type": "batch",
            "title": "New Batch",
            "subtitle": f"{b.batch_name} created",
            "timestamp": b.created_at.isoformat(),
        })

    activity_list.sort(key=lambda x: x["timestamp"], reverse=True)
    recent_activity = activity_list[:5]

    return {
        "attendance": {
            "total": total_today,
            "present": present_today,
            "absent": absent_today,
            "percentage": attendance_percentage,
        },
        "fee_collection": {
            "target": total_target,
            "paid": total_paid,
            "percentage": paid_percentage,
        },
        "recent_activity": recent_activity,
    }