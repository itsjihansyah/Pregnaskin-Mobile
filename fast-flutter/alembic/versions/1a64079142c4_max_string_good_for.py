"""max string good for

Revision ID: 1a64079142c4
Revises: 84800e65ee50
Create Date: 2025-03-17 00:18:57.486144

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision: str = '1a64079142c4'
down_revision: Union[str, None] = '84800e65ee50'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column('products', 'good_for',
               existing_type=mysql.VARCHAR(length=500),
               type_=sa.String(length=1000),
               existing_nullable=True)
    # ### end Alembic commands ###


def downgrade() -> None:
    """Downgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column('products', 'good_for',
               existing_type=sa.String(length=1000),
               type_=mysql.VARCHAR(length=500),
               existing_nullable=True)
    # ### end Alembic commands ###
