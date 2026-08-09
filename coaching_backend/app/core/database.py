from motor.motor_asyncio import AsyncIOMotorClient
from beanie import init_beanie
from app.core.config import settings

from app.models.user import User
from app.models.student import Student
from app.models.teacher import Teacher
from app.models.batch import Batch
from app.models.attendance import Attendance
from app.models.fee import Fee

client: AsyncIOMotorClient = None


async def connect_to_mongo():
    global client
    client = AsyncIOMotorClient(settings.MONGO_URI)
    database = client[settings.DB_NAME]

    await init_beanie(
        database=database,
        document_models=[
            User,
            Student,
            Teacher,
            Batch,
            Attendance,
            Fee,
        ],
    )
    print("✅ Connected to MongoDB:", settings.DB_NAME)


async def close_mongo_connection():
    global client
    if client:
        client.close()
        print("❌ MongoDB connection closed")