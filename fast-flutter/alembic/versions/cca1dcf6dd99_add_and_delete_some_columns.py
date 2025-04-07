"""add and delete some columns

Revision ID: cca1dcf6dd99
Revises: 
Create Date: 2025-03-16 13:06:52.726191

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision: str = 'cca1dcf6dd99'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('products', sa.Column('good_for', sa.String(length=255), nullable=True))
    op.add_column('products', sa.Column('benefits', sa.String(length=255), nullable=True))
    op.add_column('products', sa.Column('concern', sa.String(length=255), nullable=True))
    op.add_column('products', sa.Column('included_features', sa.String(length=255), nullable=True))
    op.add_column('products', sa.Column('excluded_features', sa.String(length=255), nullable=True))
    op.add_column('products', sa.Column('classification', sa.String(length=255), nullable=True))
    op.add_column('products', sa.Column('unsafe_reason', sa.String(length=255), nullable=True))
    op.add_column('products', sa.Column('hyperpigmentation', sa.Boolean(), nullable=True))
    op.add_column('products', sa.Column('pih', sa.Boolean(), nullable=True))
    op.add_column('products', sa.Column('acne', sa.Boolean(), nullable=True))
    op.add_column('products', sa.Column('striae_gravidarum', sa.Boolean(), nullable=True))
    op.add_column('products', sa.Column('melasma', sa.Boolean(), nullable=True))
    op.add_column('products', sa.Column('dry_skin', sa.Boolean(), nullable=True))
    op.add_column('products', sa.Column('oily_skin', sa.Boolean(), nullable=True))
    op.add_column('products', sa.Column('sensitive_skin', sa.Boolean(), nullable=True))
    op.alter_column('products', 'is_favorite',
               existing_type=mysql.TINYINT(display_width=1),
               nullable=False)
    op.drop_column('products', 'confidence')
    op.drop_column('products', 'feature')
    op.drop_column('products', 'description')
    # ### end Alembic commands ###


def downgrade() -> None:
    """Downgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('products', sa.Column('description', mysql.VARCHAR(length=1000), nullable=True))
    op.add_column('products', sa.Column('feature', mysql.VARCHAR(length=255), nullable=True))
    op.add_column('products', sa.Column('confidence', mysql.FLOAT(), nullable=False))
    op.alter_column('products', 'is_favorite',
               existing_type=mysql.TINYINT(display_width=1),
               nullable=True)
    op.drop_column('products', 'sensitive_skin')
    op.drop_column('products', 'oily_skin')
    op.drop_column('products', 'dry_skin')
    op.drop_column('products', 'melasma')
    op.drop_column('products', 'striae_gravidarum')
    op.drop_column('products', 'acne')
    op.drop_column('products', 'pih')
    op.drop_column('products', 'hyperpigmentation')
    op.drop_column('products', 'unsafe_reason')
    op.drop_column('products', 'classification')
    op.drop_column('products', 'excluded_features')
    op.drop_column('products', 'included_features')
    op.drop_column('products', 'concern')
    op.drop_column('products', 'benefits')
    op.drop_column('products', 'good_for')
    # ### end Alembic commands ###
