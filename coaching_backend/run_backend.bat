@echo off
cd /d D:\coaching_center_manager\coaching_backend
call venv\Scripts\activate
python -m uvicorn app.main:app --reload