from sqlalchemy import Table, Column, Integer, String, Float, Boolean, MetaData
from config.db import meta, engine

products = Table(
    'products', meta,
    Column('id', Integer, primary_key=True),
    Column('brand', String(255), nullable=False),
    Column('name', String(255), nullable=False),
    Column('safe', String(50), nullable=True),
    Column('category', String(100), nullable=False),
    Column('type', String(100), nullable=True),
    Column('rating', Float, nullable=True),
    Column('good_for', String(1000), nullable=True),
    Column('benefits', String(255), nullable=True),
    Column('concern', String(255), nullable=True),
    Column('included_features', String(255), nullable=True),
    Column('excluded_features', String(255), nullable=True),
    Column('unsafe_reason', String(255), nullable=True),
    Column('country', String(100), nullable=True),
    Column('ingredients', String(5000), nullable=True),
    Column('pregnancy_condition', String(255), nullable=True),
    Column('hyperpigmentation', Boolean, nullable=True),
    Column('pih', Boolean, nullable=True),
    Column('acne', Boolean, nullable=True),
    Column('stretch_marks', Boolean, nullable=True),
    Column('melasma', Boolean, nullable=True),
    Column('dry_skin', Boolean, nullable=True),
    Column('oily_skin', Boolean, nullable=True),
    Column('sensitive_skin', Boolean, nullable=True),
    Column('image_url', String(1500), nullable=True),
    Column('is_favorite', Boolean, nullable=False, default=False)
)

meta.create_all(engine)
