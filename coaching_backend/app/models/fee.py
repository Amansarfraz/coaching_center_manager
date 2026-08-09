from beanie import Document
from datetime import datetime


class Fee(Document):
    student_id: str
    student_name: str
    batch_id: str
    batch_name: str
    fee_month: str
    total_fee: float
    paid_amount: float
    remaining_balance: float
    payment_method: str  # cash, jazzcash, easypaisa, bank
    payment_date: datetime
    status: str  # paid, unpaid, partial
    created_at: datetime = datetime.utcnow()

    class Settings:
        name = "fees"