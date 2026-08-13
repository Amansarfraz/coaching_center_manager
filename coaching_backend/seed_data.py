import asyncio
import random
from datetime import datetime, timedelta

from motor.motor_asyncio import AsyncIOMotorClient
from beanie import init_beanie

from app.core.config import settings
from app.models.user import User
from app.models.student import Student
from app.models.teacher import Teacher
from app.models.batch import Batch
from app.models.attendance import Attendance
from app.models.fee import Fee


FIRST_NAMES = [
    "Ahmed", "Ali", "Hassan", "Hussain", "Bilal", "Usman", "Faisal", "Kashif",
    "Zain", "Umar", "Ayesha", "Fatima", "Zainab", "Maryam", "Sana", "Hira",
    "Amina", "Rabia", "Noor", "Iqra", "Hamza", "Saad", "Talha", "Danish",
    "Waqas", "Adeel", "Sara", "Mahnoor", "Laiba", "Aleena", "Rida", "Anum",
    "Salman", "Junaid", "Imran", "Tariq", "Nadia", "Farah", "Sadia", "Sobia",
]

LAST_NAMES = [
    "Khan", "Ahmed", "Malik", "Sheikh", "Raza", "Iqbal", "Butt", "Chaudhry",
    "Qureshi", "Farooq", "Siddiqui", "Hashmi", "Baig", "Awan", "Rana", "Cheema",
]

SUBJECTS = ["Mathematics", "Physics", "Chemistry", "Biology", "English", "Computer Science",
            "Statistics", "Urdu", "Islamiat", "Economics", "Accounting", "Pakistan Studies"]

QUALIFICATIONS = ["MSc Mathematics", "MSc Physics", "MSc Chemistry", "MSc Biology",
                   "MA English", "BS Computer Science", "MSc Statistics", "MPhil Economics"]

COURSES = ["Pre-Engineering", "Pre-Medical", "Computer Science", "Commerce", "Arts", "General Science"]


def random_name():
    return f"{random.choice(FIRST_NAMES)} {random.choice(LAST_NAMES)}"


def random_phone():
    return f"03{random.randint(0, 4)}{random.randint(1000000, 9999999)}"


def random_date(start_year, end_year):
    start = datetime(start_year, 1, 1)
    end = datetime(end_year, 12, 31)
    delta = end - start
    random_days = random.randint(0, delta.days)
    return start + timedelta(days=random_days)


async def seed():
    client = AsyncIOMotorClient(settings.MONGO_URI)
    database = client[settings.DB_NAME]

    await init_beanie(
        database=database,
        document_models=[User, Student, Teacher, Batch, Attendance, Fee],
    )

    print("🗑️  Clearing old dummy data (students, teachers, batches)...")
    await Student.find_all().delete()
    await Teacher.find_all().delete()
    await Batch.find_all().delete()

    # ---------------- TEACHERS (20) ----------------
    print("👩‍🏫 Creating 20 teachers...")
    teachers = []
    for i in range(20):
        subject = random.choice(SUBJECTS)
        teacher = Teacher(
            full_name=random_name(),
            subject=subject,
            qualification=random.choice(QUALIFICATIONS),
            phone=random_phone(),
            email=f"teacher{i+1}@example.com",
            gender=random.choice(["male", "female"]),
            joining_date=random_date(2020, 2024),
            salary=random.choice([50000, 60000, 70000, 80000, 90000, 100000]),
            assigned_subjects=[subject, random.choice(SUBJECTS)],
            assigned_batch_ids=[],
            status="active",
            created_at=datetime.utcnow(),
        )
        await teacher.insert()
        teachers.append(teacher)
    print(f"✅ {len(teachers)} teachers created")

    # ---------------- BATCHES (6) — 2023 to 2027, Morning/Evening ----------------
    print("📚 Creating 6 batches (2023-2027, Morning/Evening)...")
    batch_configs = [
        {"year": 2023, "shift": "Morning", "timing": "MWF 08:00 - 10:00"},
        {"year": 2023, "shift": "Evening", "timing": "TTS 16:00 - 18:00"},
        {"year": 2024, "shift": "Morning", "timing": "MWF 09:00 - 11:00"},
        {"year": 2024, "shift": "Evening", "timing": "TTS 17:00 - 19:00"},
        {"year": 2025, "shift": "Morning", "timing": "MWF 10:00 - 12:00"},
        {"year": 2027, "shift": "Evening", "timing": "TTS 18:00 - 20:00"},
    ]

    batches = []
    for idx, cfg in enumerate(batch_configs):
        teacher = teachers[idx % len(teachers)]
        course = random.choice(COURSES)
        batch = Batch(
            batch_name=f"Batch {cfg['year']} - {cfg['shift']}",
            course_name=course,
            teacher_id=str(teacher.id),
            teacher_name=teacher.full_name,
            classroom=f"Room {random.randint(101, 305)}",
            timing=cfg["timing"],
            student_capacity=40,
            total_students=0,
            start_date=datetime(cfg["year"], 1, 15),
            end_date=datetime(cfg["year"], 12, 20),
            status="active",
            created_at=datetime.utcnow(),
        )
        await batch.insert()
        batches.append(batch)
    print(f"✅ {len(batches)} batches created")

    # ---------------- STUDENTS (150, ~25 per batch) ----------------
    print("🎓 Creating 150 students (spread across batches)...")
    students_per_batch = 150 // len(batches)  # 25 per batch
    total_created = 0

    for batch in batches:
        for i in range(students_per_batch):
            student = Student(
                full_name=random_name(),
                father_name=random_name(),
                phone=random_phone(),
                email=f"student{total_created+1}@example.com",
                home_address=f"House {random.randint(1,999)}, Street {random.randint(1,50)}, Lahore",
                gender=random.choice(["male", "female"]),
                dob=random_date(2005, 2010),
                admission_date=batch.start_date,
                batch_id=str(batch.id),
                batch_name=batch.batch_name,
                monthly_fee=random.choice([3000, 4000, 5000, 6000]),
                status=random.choice(["active", "active", "active", "pending"]),
                created_at=datetime.utcnow(),
            )
            await student.insert()
            total_created += 1

        # Batch ka total_students update karo
        batch.total_students = students_per_batch
        await batch.save()

    print(f"✅ {total_created} students created")

    print("\n🎉 Seeding complete!")
    print(f"   Teachers: {len(teachers)}")
    print(f"   Batches:  {len(batches)}")
    print(f"   Students: {total_created}")

    client.close()


if __name__ == "__main__":
    asyncio.run(seed())