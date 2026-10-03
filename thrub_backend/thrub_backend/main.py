from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from datetime import datetime
from typing import Optional

from database import Base, engine, SessionLocal
from models import User, Position
from auth import hash_password, verify_password, create_access_token

Base.metadata.create_all(bind=engine)
app = FastAPI()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ---------- Request shapes ----------

class SignupRequest(BaseModel):
    email: str
    username: str
    password: str

class LoginRequest(BaseModel):
    email: str
    password: str

class PositionRequest(BaseModel):
    user_id: int
    symbol: str
    side: str
    entry_price: float
    amount_usd: float

class ClosePositionRequest(BaseModel):
    close_price: float

# ---------- Auth routes ----------

@app.post("/signup")
def signup(data: SignupRequest, db: Session = Depends(get_db)):
    existing = db.query(User).filter(User.email == data.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")

    user = User(
        email=data.email,
        username=data.username,
        hashed_password=hash_password(data.password),
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    token = create_access_token({"sub": str(user.id)})
    return {"token": token, "username": user.username, "user_id": user.id}

@app.post("/login")
def login(data: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == data.email).first()
    if not user or not verify_password(data.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid email or password")

    token = create_access_token({"sub": str(user.id)})
    return {"token": token, "username": user.username, "user_id": user.id}

# ---------- Position (trade) routes ----------

@app.post("/positions")
def open_position(data: PositionRequest, db: Session = Depends(get_db)):
    position = Position(
        user_id=data.user_id,
        symbol=data.symbol,
        side=data.side,
        entry_price=data.entry_price,
        amount_usd=data.amount_usd,
        opened_at=datetime.utcnow(),
    )
    db.add(position)
    db.commit()
    db.refresh(position)
    return position

@app.get("/positions/{user_id}")
def get_positions(user_id: int, db: Session = Depends(get_db)):
    return db.query(Position).filter(Position.user_id == user_id).all()

@app.post("/positions/{position_id}/close")
def close_position(position_id: int, data: ClosePositionRequest, db: Session = Depends(get_db)):
    position = db.query(Position).filter(Position.id == position_id).first()
    if not position:
        raise HTTPException(status_code=404, detail="Position not found")

    position.close_price = data.close_price
    position.closed_at = datetime.utcnow()
    db.commit()
    db.refresh(position)
    return position