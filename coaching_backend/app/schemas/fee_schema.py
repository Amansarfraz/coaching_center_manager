from pydantic import BaseModel
from typing import Optional


class FeeCreateSchema(BaseModel):
    student_id: str
    student_name: str
    batch_id: str
    batch_name: str
    fee_month: str
    total_fee: float
    paid_amount: float
    payment_method: str
    payment_date: str
    remarks: Optional[str] = ""


class FeeUpdateSchema(BaseModel):
    paid_amount: Optional[float] = None
    payment_method: Optional[str] = None
    payment_date: Optional[str] = None
    status: Optional[str] = None
    remarks: Optional[str] = None