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
    
    safe_products, paginated_products = similar(product_id, product_data, feature_vectors, page, per_page)

    return {
        "page": page,
        "per_page": per_page,
        "total": len(safe_products),
        "products": paginated_products
    }

@product.post("/filter")
def filter_products_json(request: dict):
    min_rating = request.get("minRating", 0.0)
    max_rating = request.get("maxRating", 5.0)
    categories = request.get("categories", [])
    skin_types = request.get("skin_types", [])
    conditions = request.get("conditions", [])
    safety_options = request.get("safety_options", [])
    countries = request.get("countries", [])

    page = request.get("page", 1)
    per_page = request.get("per_page", 10)
    offset = (page - 1) * per_page

    sort_by = request.get("sort_by", "rating")
    order = request.get("order", "desc")

    # Optional search query
    search_query = request.get("search", "").strip()
    keywords = search_query.split() if search_query else []

    try:
        with engine.connect() as conn:
            filters = []

            if categories:
                filters.append(products.c.category.in_(categories))
            if conditions:
                filters.append(products.c.pregnancy_condition.in_(conditions))
            if safety_options:
                filters.append(products.c.safe.in_(safety_options))
            if countries:
                filters.append(products.c.country.in_(countries))
            if request.get("dry_skin") is not None:
                filters.append(products.c.dry_skin == request["dry_skin"])
            if request.get("oily_skin") is not None:
                filters.append(products.c.oily_skin == request["oily_skin"])
            if request.get("sensitive_skin") is not None:
                filters.append(products.c.sensitive_skin == request["sensitive_skin"])

            filters.append(products.c.rating.between(min_rating, max_rating))

            # Apply search conditions if search query exists
            if keywords:
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
                filters.append(search_conditions)

            # Build query
            query = select(products).where(and_(*filters))

            # Sorting
            if order == "desc":
                query = query.order_by(desc(getattr(products.c, sort_by, products.c.rating)))
            else:
                query = query.order_by(asc(getattr(products.c, sort_by, products.c.rating)))

            # Total count
            total = conn.execute(select(func.count()).select_from(query.subquery())).scalar()

            # Fetch paginated results
            results = conn.execute(query.offset(offset).limit(per_page)).fetchall()

            return {
                "total": total,
                "products": [dict(row._mapping) for row in results]
            }

    except SQLAlchemyError as e:
        raise HTTPException(status_code=500, detail=str(e))

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

            paginated = scored_results[offset:offset + per_page]

            return {
                "total": total_results,
                "products": [item[1] for item in paginated]
            }

    except PendingRollbackError:
        raise HTTPException(status_code=500, detail="Database connection error. Rolled back.")
    except SQLAlchemyError as e:
        raise HTTPException(status_code=500, detail=str(e))

# @product.post("/filter-similar/{product_id}")
# def filter_similar_products(product_id: int, request: dict):
#     try:
#         # Step 1: Get alternatives from similarity function
#         alternatives = get_similar_products(product_id)  # Your similarity function
        
#         # Step 2: Filter them
#         filtered = filter_alternatives(alternatives, request)
        
#         # Step 3: Sort them
#         sort_by = request.get("sort_by", "match_percentage")
#         order = request.get("order", "desc")
#         sorted_alternatives = sort_alternatives(filtered, sort_by, order)
        
#         # Step 4: Paginate
#         page = int(request.get("page", 1))
#         per_page = int(request.get("per_page", 10))
#         total = len(sorted_alternatives)
#         start = (page - 1) * per_page
#         end = start + per_page
#         paginated = sorted_alternatives[start:end]
        
#         return {
#             "total": total,
#             "products": paginated
#         }
    
#     except Exception as e:
#         print(f"Unexpected error: {str(e)}")
#         raise HTTPException(status_code=500, detail="Unexpected error")

# def filter_alternatives(alternatives, filters):
#     min_rating = filters.get("minRating", 0.0)
#     max_rating = filters.get("maxRating", 5.0)
#     skin_types = filters.get("skin_types", [])  # Expects list of "Dry", "Oily", "Sensitive"
#     conditions = filters.get("conditions", [])
#     countries = filters.get("countries", [])
    
#     filtered = []
#     for product in alternatives["products"]:
#         if not (min_rating <= product.get("rating", 0.0) <= max_rating):
#             continue
#         if conditions and product.get("pregnancy_condition") not in conditions:
#             continue
#         if countries and product.get("country") not in countries:
#             continue
        
#         # Skin type matching
#         if "dry" in skin_types and not product.get("dry_skin", False):
#             continue
#         if "oily" in skin_types and not product.get("oily_skin", False):
#             continue
#         if "sensitive" in skin_types and not product.get("sensitive_skin", False):
#             continue
        
#         filtered.append(product)
    
#     # Return statement outside the loop
#     return filtered


# def sort_alternatives(products, sort_by, order):
#     reverse = order == "desc"
#     try:
#         # If sort_by key is not present in some products, use 0 as default value
#         return sorted(products, key=lambda x: x.get(sort_by, 0), reverse=reverse)
#     except Exception as e:
#         print(f"Error while sorting: {str(e)}")
#         return products  # fallback to unsorted


# def filter_alternatives(alternatives, filters):
#     min_rating = filters.get("minRating", 0.0)
#     max_rating = filters.get("maxRating", 5.0)
#     skin_types = filters.get("skin_types", [])
#     conditions = filters.get("conditions", [])
#     countries = filters.get("countries", [])

#     filtered = []
#     for product in alternatives["products"]:  # Note: make sure you're accessing actual list
#         if not (min_rating <= product["rating"] <= max_rating):
#             continue
#         if conditions and product.get("pregnancy_condition") not in conditions:
#             continue
#         if countries and product.get("country") not in countries:
#             continue
#         if "Dry" in skin_types and not product.get("dry_skin", False):
#             continue
#         if "Oily" in skin_types and not product.get("oily_skin", False):
#             continue
#         if "Sensitive" in skin_types and not product.get("sensitive_skin", False):
#             continue
#         filtered.append(product)
    
#     return filtered

#     def sort_alternatives(products, sort_by, order):
#         reverse = order == "desc"
#         try:
#             # If sort_by key is not present in some products, use 0 as default value
#             return sorted(products, key=lambda x: x.get(sort_by, 0), reverse=reverse)
#         except Exception as e:
#             print(f"Error while sorting: {str(e)}")
#             return products  # fallback to unsorted

@product.post("/filter-similar/{product_id}")
def filter_similar_products(product_id: int, request: dict):
    try:
        # Step 1: Get alternatives from similarity function
        product_data, feature_vectors = vectorize()
        safe_products, all_products = similar(product_id, product_data, feature_vectors, 1, 500)  # Get all products (up to 500)
        
        # Step 2: Filter them
        filtered = filter_alternatives({"products": all_products}, request)
        
        # Step 3: Sort them
        sort_by = request.get("sort_by", "match_percentage")
        order = request.get("order", "desc")
        sorted_alternatives = sort_alternatives(filtered, sort_by, order)
        
        # Step 4: Paginate
        page = int(request.get("page", 1))
        per_page = int(request.get("per_page", 10))
        total = len(sorted_alternatives)
        start = (page - 1) * per_page
        end = start + per_page
        paginated = sorted_alternatives[start:end] if start < total else []
        
        return {
            "total": total,
            "products": paginated
        }
    
    except Exception as e:
        print(f"Unexpected error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Unexpected error: {str(e)}")

def filter_alternatives(alternatives, filters):
    min_rating = filters.get("minRating", 0.0)
    max_rating = filters.get("maxRating", 5.0)
    skin_types = filters.get("skin_types", [])
    conditions = filters.get("conditions", [])
    countries = filters.get("countries", [])

    filtered = []
    for product in alternatives["products"]:
        # Rating filter
        if not (min_rating <= product.get("rating", 0.0) <= max_rating):
            continue
            
        # Conditions filter
        if conditions and product.get("pregnancy_condition") not in conditions:
            continue
            
        # Countries filter
        if countries and product.get("country") not in countries:
            continue
            
        # Skin type filters
        if "Dry" in skin_types and not product.get("dry_skin", False):
            continue
        if "Oily" in skin_types and not product.get("oily_skin", False):
            continue
        if "Sensitive" in skin_types and not product.get("sensitive_skin", False):
            continue
            
        filtered.append(product)
    
    return filtered

def sort_alternatives(products, sort_by, order):
    reverse = order == "desc"
    try:
        # If sort_by key is not present in some products, use 0 as default value
        return sorted(products, key=lambda x: x.get(sort_by, 0), reverse=reverse)
    except Exception as e:
        print(f"Error while sorting: {str(e)}")
        return products  # fallback to unsorted

# endpoint to search product based on the name, brand, type, category
