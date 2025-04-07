from fastapi import FastAPI
from routes.product import product
from models.product import products
from fastapi.middleware.cors import CORSMiddleware
from recommendation import vectorize, similar

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins="*",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(product)

# run vectorize at startup
vectorize()
