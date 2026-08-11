from fastapi import APIRouter, HTTPException
from datetime import datetime
from beanie import PydanticObjectId

from app.models.batch import Batch
from app.schemas.batch_schema import BatchCreateSchema, BatchUpdateSchema

router = APIRouter(prefix="/api/batches", tags=["Batches"])


@router.get("")
async def get_all_batches():
    batches = await Batch.find_all().to_list()
    return {"batches": batches}


@router.get("/{batch_id}")
async def get_batch(batch_id: PydanticObjectId):
    batch = await Batch.get(batch_id)
    if not batch:
        raise HTTPException(status_code=404, detail="Batch not found")
    return batch


@router.post("", status_code=201)
async def create_batch(data: BatchCreateSchema):
    batch = Batch(
        batch_name=data.batch_name,
        course_name=data.course_name,
        teacher_id=data.teacher_id,
        teacher_name=data.teacher_name,
        classroom=data.classroom,
        timing=data.timing,
        student_capacity=data.student_capacity,
        start_date=datetime.fromisoformat(data.start_date),
        end_date=datetime.fromisoformat(data.end_date) if data.end_date else None,
    )
    await batch.insert()
    return batch


@router.put("/{batch_id}")
async def update_batch(batch_id: PydanticObjectId, data: BatchUpdateSchema):
    batch = await Batch.get(batch_id)
    if not batch:
        raise HTTPException(status_code=404, detail="Batch not found")

    update_data = data.dict(exclude_unset=True)

    if "start_date" in update_data and update_data["start_date"]:
        update_data["start_date"] = datetime.fromisoformat(update_data["start_date"])
    if "end_date" in update_data and update_data["end_date"]:
        update_data["end_date"] = datetime.fromisoformat(update_data["end_date"])

    for key, value in update_data.items():
        setattr(batch, key, value)

    await batch.save()
    return batch


@router.delete("/{batch_id}")
async def delete_batch(batch_id: PydanticObjectId):
    batch = await Batch.get(batch_id)
    if not batch:
        raise HTTPException(status_code=404, detail="Batch not found")
    await batch.delete()
    return {"message": "Batch deleted successfully"}