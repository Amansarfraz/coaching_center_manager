from fastapi import APIRouter, HTTPException, status
from app.models.user import User
from app.schemas.auth_schema import SignupSchema, LoginSchema, TokenResponse, UserResponse
from app.core.security import hash_password, verify_password, create_access_token
from app.core.notification_helper import create_and_send_notification

router = APIRouter(prefix="/api/auth", tags=["Auth"])


@router.post("/signup", status_code=status.HTTP_201_CREATED)
async def signup(data: SignupSchema):
    # Check if email already exists
    existing_user = await User.find_one(User.email == data.email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    user = User(
        full_name=data.full_name,
        email=data.email,
        phone=data.phone,
        password_hash=hash_password(data.password),
        role=data.role,
    )
    await user.insert()
    await create_and_send_notification(
        title="New Batch Assigned",
        message=f"You have been assigned to {data.batch_name} ({data.course_name})",
        target_role="teacher",
        related_type="batch",
    )

    return {"message": "Account created successfully"}


@router.post("/login", response_model=TokenResponse)
async def login(data: LoginSchema):
    user = await User.find_one(User.email == data.email)
    if not user:
        raise HTTPException(status_code=401, detail="Invalid email or password")

    if not verify_password(data.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid email or password")

    access_token = create_access_token(data={"sub": str(user.id)})

    user_response = UserResponse(
        id=str(user.id),
        full_name=user.full_name,
        email=user.email,
        phone=user.phone,
        role=user.role,
        profile_image=user.profile_image,
    )

    return TokenResponse(access_token=access_token, user=user_response)