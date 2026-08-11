from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from app.core.database import connect_to_mongo, close_mongo_connection
from app.routers import auth_router, student_router, teacher_router, batch_router, attendance_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    await connect_to_mongo()
    yield
    await close_mongo_connection()


app = FastAPI(
    title="Coaching Center Manager API",
    description="Backend API for Coaching Center Manager App",
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router.router)
app.include_router(student_router.router)
app.include_router(teacher_router.router)
app.include_router(batch_router.router)
app.include_router(attendance_router.router)


@app.get("/")
async def root():
    return {"message": "Coaching Center Manager API is running 🚀"}


@app.get("/api/health")
async def health_check():
    return {"status": "ok"}