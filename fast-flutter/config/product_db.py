# db/product_db.py
from sqlalchemy import select, func
from config.db import conn
from models.product import products

def get_all_products(page=1, per_page=10, sort_by="popular"):
    query = select(products)

    if sort_by == "popular":
        query = query.order_by(products.c.rating.desc())
    elif sort_by == "latest":
        query = query.order_by(products.c.id.desc())

    offset = (page - 1) * per_page
    query = query.offset(offset).limit(per_page)

    result = conn.execute(query).fetchall()
    return [dict(row._mapping) for row in result]

def get_total_products():
    total_query = select(func.count()).select_from(products)
    return conn.execute(total_query).scalar()
