from fastapi import APIRouter, HTTPException
from datetime import datetime
from beanie import PydanticObjectId

from app.models.fee import Fee
from app.schemas.fee_schema import FeeCreateSchema, FeeUpdateSchema
from app.models.notification import Notification
from app.core.notification_helper import create_and_send_notification

router = APIRouter(prefix="/api/fees", tags=["Fees"])


def calc_status(total: float, paid: float) -> str:
    if paid <= 0:
        return "unpaid"
    if paid >= total:
        return "paid"
    return "partial"


@router.get("")
async def get_all_fees(month: str = None):
    if month:
        records = await Fee.find(Fee.fee_month == month).to_list()
    else:
        records = await Fee.find_all().to_list()
    return {"fees": records}


@router.get("/student/{student_id}")
async def get_student_fees(student_id: str):
    records = await Fee.find(Fee.student_id == student_id).to_list()
    return {"fees": records}


@router.post("", status_code=201)
async def create_fee(data: FeeCreateSchema):
    remaining = data.total_fee - data.paid_amount
    status = calc_status(data.total_fee, data.paid_amount)

    fee = Fee(
        student_id=data.student_id,
        student_name=data.student_name,
        batch_id=data.batch_id,
        batch_name=data.batch_name,
        fee_month=data.fee_month,
        total_fee=data.total_fee,
        paid_amount=data.paid_amount,
        remaining_balance=remaining,
        payment_method=data.payment_method,
        payment_date=datetime.fromisoformat(data.payment_date),
        status=status,
    )
    # Admin ko
    await create_and_send_notification(
        title="Fee Payment Recorded",
        message=f"Rs.{data.paid_amount:.0f} received from {data.student_name} for {data.fee_month}",
        target_role="admin",
        related_type="fee",
    )

    # Student ko bhi
    await create_and_send_notification(
        title="Fee Payment Confirmed",
        message=f"Your payment of Rs.{data.paid_amount:.0f} for {data.fee_month} has been received",
        target_role="student",
        related_type="fee",
    )
   
    notif = Notification(
        title="Fee Payment Recorded",
        message=f"Rs.{data.paid_amount:.0f} received from {data.student_name} for {data.fee_month}",
        target_role="admin",
        related_type="fee",
        created_at=datetime.utcnow(),
    )
    await notif.insert()

    return fee


@router.put("/{fee_id}")
async def update_fee(fee_id: PydanticObjectId, data: FeeUpdateSchema):
    fee = await Fee.get(fee_id)
    if not fee:
        raise HTTPException(status_code=404, detail="Fee record not found")

    update_data = data.dict(exclude_unset=True)
    if "payment_date" in update_data and update_data["payment_date"]:
        update_data["payment_date"] = datetime.fromisoformat(update_data["payment_date"])

    for key, value in update_data.items():
        setattr(fee, key, value)

    if "paid_amount" in update_data:
        fee.remaining_balance = fee.total_fee - fee.paid_amount
        fee.status = calc_status(fee.total_fee, fee.paid_amount)

    await fee.save()
    return fee


@router.delete("/{fee_id}")
async def delete_fee(fee_id: PydanticObjectId):
    fee = await Fee.get(fee_id)
    if not fee:
        raise HTTPException(status_code=404, detail="Fee record not found")
    await fee.delete()
    return {"message": "Fee record deleted"}


@router.get("/summary")
async def get_fee_summary(month: str = None):
    records = await Fee.find(Fee.fee_month == month).to_list() if month else await Fee.find_all().to_list()
    total_target = sum(r.total_fee for r in records)
    total_paid = sum(r.paid_amount for r in records)
    percentage = round((total_paid / total_target) * 100, 1) if total_target > 0 else 0
    return {"target": total_target, "paid": total_paid, "percentage": percentage}