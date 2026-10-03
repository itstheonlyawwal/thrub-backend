from sqlalchemy import Column, Integer, String, Float, DateTime
from database import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    username = Column(String, unique=True, index=True)
    hashed_password = Column(String)

class Position(Base):
    __tablename__ = "positions"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
    symbol = Column(String)
    side = Column(String)
    entry_price = Column(Float)
    close_price = Column(Float, nullable=True)
    amount_usd = Column(Float)
    opened_at = Column(DateTime)
    closed_at = Column(DateTime, nullable=True)