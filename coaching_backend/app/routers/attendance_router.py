from fastapi import APIRouter
from . import auth_router
from . import teacher_router
from . import batch_router
from . import attendance_router

router = APIRouter(
    prefix="/attendance",
    tags=["Attendance"]
)