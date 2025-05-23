"""max string good for

Revision ID: 0687cc5958ef
Revises: 893ec36ce2d3
Create Date: 2025-03-17 00:21:22.788141

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision: str = '0687cc5958ef'
down_revision: Union[str, None] = '893ec36ce2d3'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column('products', 'ingredients',
               existing_type=mysql.VARCHAR(length=3000),
               type_=sa.String(length=5000),
               existing_nullable=True)
    # ### end Alembic commands ###


def downgrade() -> None:
    """Downgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column('products', 'ingredients',
               existing_type=sa.String(length=5000),
               type_=mysql.VARCHAR(length=3000),
               existing_nullable=True)
    # ### end Alembic commands ###
