from fastapi import APIRouter, HTTPException, Query
from config.db import engine  # ganti dari conn → engine
from models.product import products
from schemas.product import Product
from sqlalchemy import insert, update, delete, select, func, or_, desc, asc
from recommendation import vectorize, similar
from config.product_db import get_all_products, get_total_products
from sqlalchemy.sql import text
from sqlalchemy.exc import SQLAlchemyError, PendingRollbackError
from sqlalchemy import and_, or_, asc, desc, select
from sqlalchemy.exc import SQLAlchemyError, PendingRollbackError
from fastapi import HTTPException
from rapidfuzz import fuzz


product = APIRouter(prefix="/products", tags=["Products"])

@product.get("/")
def fetch_products(page: int = 1, per_page: int = 10, sort_by: str = "popular"):
    products = get_all_products(page, per_page, sort_by)
    total = get_total_products()
    return {"total": total, "products": products}


@product.post("/")
def create_product(product_data: Product):
    query = insert(products).values(
        brand=product_data.brand,
        name=product_data.name,
        safe=product_data.safe,
        category=product_data.category,
        type=product_data.type,
        rating=product_data.rating,
        good_for=product_data.good_for,
        benefits=product_data.benefits,
        concern=product_data.concern,
        included_features=product_data.included_features,
        excluded_features=product_data.excluded_features,
        unsafe_reason=product_data.unsafe_reason,
        country=product_data.country,
        ingredients=product_data.ingredients,
        pregnancy_condition=product_data.pregnancy_condition,
        hyperpigmentation=product_data.hyperpigmentation,
        pih=product_data.pih,
        acne=product_data.acne,
        stretch_marks=product_data.stretch_marks,
        melasma=product_data.melasma,
        dry_skin=product_data.dry_skin,
        oily_skin=product_data.oily_skin,
        sensitive_skin=product_data.sensitive_skin,
        image_url=product_data.image_url,
        is_favorite=product_data.is_favorite
    )
    result = conn.execute(query)
    conn.commit()
    return {"id": result.lastrowid, "message": "Product created successfully"}

@product.put("/{id}")
def update_product(id: int, product_data: Product):
    query = update(products).where(products.c.id == id).values(
        brand=product_data.brand,
        name=product_data.name,
        safe=product_data.safe,
        category=product_data.category,
        type=product_data.type,
        rating=product_data.rating,
        good_for=product_data.good_for,
        benefits=product_data.benefits,
        concern=product_data.concern,
        included_features=product_data.included_features,
        excluded_features=product_data.excluded_features,
        unsafe_reason=product_data.unsafe_reason,
        country=product_data.country,
        ingredients=product_data.ingredients,
        pregnancy_condition=product_data.pregnancy_condition,
        hyperpigmentation=product_data.hyperpigmentation,
        pih=product_data.pih,
        acne=product_data.acne,
        stretch_marks=product_data.stretch_marks,
        melasma=product_data.melasma,
        dry_skin=product_data.dry_skin,
        oily_skin=product_data.oily_skin,
        sensitive_skin=product_data.sensitive_skin,
        image_url=product_data.image_url,
        is_favorite=product_data.is_favorite
    )
    result = conn.execute(query)
    conn.commit()
    if result.rowcount:
        return {"message": "Product updated successfully"}
    else:
        raise HTTPException(status_code=404, detail="Product not found")

@product.delete("/{id}")
def delete_product(id: int):
    query = delete(products).where(products.c.id == id)
    result = conn.execute(query)
    conn.commit()
    if result.rowcount:
        return {"message": "Product deleted successfully"}
    else:
        raise HTTPException(status_code=404, detail="Product not found")

# endpoint to show the similar product a.k.a the recommendation system
@product.get("/similar-products/{product_id}")
def get_similar_products(product_id: int, page: int = 1, per_page: int = 20):
    """Fetch similar products for a given product_id."""
    
    product_data, feature_vectors = vectorize()
    
    similar_products = similar(product_id, product_data, feature_vectors, page, per_page)

    return {
        "page": page,
        "per_page": per_page,
        "total": len(similar_products),
        "products": similar_products
    }

# endpoint to search product based on the name, brand, type, category
@product.get("/search")
def search_products(
    q: str,
    page: int = 1,
    per_page: int = 10,
    sort_by: str = "rating",
    order: str = "desc"
):
    keywords = q.strip().split()
    offset = (page - 1) * per_page

    try:
        with engine.connect() as conn:
            search_conditions = and_(
                *[
                    or_(
                        products.c.brand.ilike(f"%{kw}%"),
                        products.c.name.ilike(f"%{kw}%"),
                        products.c.concern.ilike(f"%{kw}%"),
                        products.c.ingredients.ilike(f"%{kw}%"),
                        products.c.category.ilike(f"%{kw}%"),
                    )
                    for kw in keywords
                ]
            )

            # Get broader result first (e.g., top 100 matching rows)
            base_query = select(products).where(search_conditions).limit(500)  # Increased limit for larger datasets
            raw_results = conn.execute(base_query).fetchall()

            # Apply fuzzy scoring
            scored_results = []
            for row in raw_results:
                product = dict(row._mapping)
                combined_text = f"{product['brand']} {product['name']} {product['category']} {product['concern']}"
                score = fuzz.token_set_ratio(q.lower(), combined_text.lower())
                scored_results.append((score, product))

            # Sort by score + fallback to original sort_by if needed
            scored_results.sort(key=lambda x: (-x[0], -x[1].get(sort_by, 0) if order == "desc" else x[1].get(sort_by, 0)))

            # Get total count before pagination
            total_results = len(scored_results)
            
            # Proper pagination
            paginated = scored_results[offset:offset + per_page]

            return {
                "total": total_results,  # Return total before pagination
                "products": [item[1] for item in paginated]
            }

    except PendingRollbackError:
        raise HTTPException(status_code=500, detail="Database connection error. Rolled back.")
    except SQLAlchemyError as e:
        raise HTTPException(status_code=500, detail=str(e))