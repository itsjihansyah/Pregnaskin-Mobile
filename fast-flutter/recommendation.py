import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from scipy.sparse import hstack
from models.product import products
from sqlalchemy import select

from sqlalchemy import select
from scipy.sparse import hstack
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from config.db import conn
from models.product import products

def vectorize():
    """Fetches product data from the database and creates feature vectors."""
    
    # Fetch data directly from the database
    query = select(
    products.c.id, products.c.category, products.c.brand, products.c.name, 
    products.c.type, products.c.image_url, products.c.ingredients, 
    products.c.rating, products.c.country, products.c.good_for, 
    products.c.benefits, products.c.concern, products.c.included_features, 
    products.c.excluded_features, products.c.safe, products.c.unsafe_reason, 
    products.c.pregnancy_condition, products.c.hyperpigmentation, 
    products.c.pih, products.c.acne, products.c.stretch_marks, 
    products.c.melasma, products.c.dry_skin, products.c.oily_skin, 
    products.c.sensitive_skin
    )
    result = conn.execute(query).fetchall()

    if not result:
        return [], np.array([])  # Return empty if no products

    result = conn.execute(query)  # Run query
    rows = result.fetchall()  # Fetch all results

    # Convert rows properly
    product_data = [dict(row._mapping) for row in rows]  # ✅ Safe conversion
    

    # Process text features
    for p in product_data:
        for col in ["ingredients", "category", "type", "benefits", "included_features"]:
            p[col] = (p[col] or "").lower().strip()
        p["combined_text"] = " ".join([
            p["ingredients"], p["category"], p["type"], 
            p["benefits"], p["included_features"]
        ])

    # Extract text and binary features
    text_data = [p["combined_text"] for p in product_data]
    binary_features = np.array([
        [p["hyperpigmentation"], p["pih"], p["acne"], p["stretch_marks"],
         p["melasma"], p["dry_skin"], p["oily_skin"], p["sensitive_skin"]]
        for p in product_data
    ])

    # TF-IDF Vectorization
    tfidf = TfidfVectorizer()
    feature_vector = tfidf.fit_transform(text_data)

    # Combine TF-IDF with binary features
    feature_vectors = hstack((feature_vector, binary_features)).toarray()

    # Normalize feature vectors
    feature_vectors = feature_vectors / np.linalg.norm(feature_vectors, axis=1, keepdims=True)

    return product_data, feature_vectors


def similar(query_id, product_data, vectors, page=1, per_page=20):
    """Finds similar safe products in the same category with pagination for FastAPI."""

    # Ensure product exists
    product_ids = [p["id"] for p in product_data]
    if query_id not in product_ids:
        raise ValueError("Product not found")

    # Get query product and index
    query_idx = product_ids.index(query_id)
    query_product = product_data[query_idx]
    query_vector = vectors[query_idx]
    query_category = query_product["category"]

    # Compute cosine similarities
    similarities = np.dot(vectors, query_vector)

    # Get sorted indices (excluding itself)
    similar_idxs = np.argsort(-similarities)[1:]

    # Get query ingredients
    query_ingredients = set(query_product["ingredients"].split(", ")) if query_product["ingredients"] else set()

    # Filter only safe products in the same category
    safe_products = [
        (product_data[i], similarities[i]) 
        for i in similar_idxs 
        if product_data[i]["safe"] == 'Safe' and product_data[i]["category"] == query_category
    ]

    # Pagination
    start_idx = (page - 1) * per_page
    end_idx = start_idx + per_page
    paginated_products = safe_products[start_idx:end_idx]

    # Convert to JSON (list of dicts)
    return [
        {
            "id": p["id"],
            "category": p["category"],
            "brand": p["brand"],
            "name": p["name"],
            "type": p["type"],
            "image_url": p["image_url"],
            "ingredients": p["ingredients"],
            "rating": p["rating"],
            "country": p["country"],
            "good_for": p["good_for"],
            "benefits": p["benefits"],
            "concern": p["concern"],
            "included_features": p["included_features"],
            "excluded_features": p["excluded_features"],
            "safe": p["safe"],
            "unsafe_reason": p["unsafe_reason"],
            "pregnancy_condition": p["pregnancy_condition"],
            "hyperpigmentation": p["hyperpigmentation"],
            "pih": p["pih"],
            "acne": p["acne"],
            "stretch_marks": p["stretch_marks"],
            "melasma": p["melasma"],
            "dry_skin": p["dry_skin"],
            "oily_skin": p["oily_skin"],
            "sensitive_skin": p["sensitive_skin"],
            "similarity_score": int(round(score * 100)),  # Round to percentage
            "match_ingredient_count": len(set(p["ingredients"].split(", ")) & query_ingredients)
        }
        for p, score in paginated_products
    ]
