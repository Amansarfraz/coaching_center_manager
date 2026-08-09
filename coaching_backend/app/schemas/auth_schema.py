from pydantic import BaseModel, EmailStr
from typing import Optional


class SignupSchema(BaseModel):
    full_name: str
    email: EmailStr
    phone: str
    password: str
    role: str  # 'admin', 'teacher', 'student'


class LoginSchema(BaseModel):
    email: EmailStr
    password: str


class UserResponse(BaseModel):
    id: str
    full_name: str
    email: str
    phone: str
    role: str
    profile_image: Optional[str] = None


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse