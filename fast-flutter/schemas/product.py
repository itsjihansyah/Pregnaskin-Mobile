from pydantic import BaseModel
from typing import Optional

class Product(BaseModel):
    brand: str
    name: str
    safe: Optional[str] = None
    category: str
    type: Optional[str] = None
    rating: Optional[float] = None
    good_for: Optional[str] = None
    benefits: Optional[str] = None
    concern: Optional[str] = None
    included_features: Optional[str] = None
    excluded_features: Optional[str] = None
    unsafe_reason: Optional[str] = None
    country: Optional[str] = None
    ingredients: Optional[str] = None
    pregnancy_condition: Optional[str] = None
    hyperpigmentation: Optional[bool] = None
    pih: Optional[bool] = None
    acne: Optional[bool] = None
    stretch_marks: Optional[bool] = None 
    melasma: Optional[bool] = None
    dry_skin: Optional[bool] = None
    oily_skin: Optional[bool] = None
    sensitive_skin: Optional[bool] = None
    image_url: Optional[str] = None
    is_favorite: Optional[bool] = False

    class Config:
        from_attributes = True
