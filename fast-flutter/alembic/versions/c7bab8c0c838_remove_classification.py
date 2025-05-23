"""remove classification

Revision ID: c7bab8c0c838
Revises: cca1dcf6dd99
Create Date: 2025-03-16 21:55:56.452326

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision: str = 'c7bab8c0c838'
down_revision: Union[str, None] = 'cca1dcf6dd99'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column('products', 'safe',
               existing_type=mysql.VARCHAR(length=50),
               nullable=True)
    op.drop_column('products', 'classification')
    # ### end Alembic commands ###


def downgrade() -> None:
    """Downgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('products', sa.Column('classification', mysql.VARCHAR(length=255), nullable=True))
    op.alter_column('products', 'safe',
               existing_type=mysql.VARCHAR(length=50),
               nullable=False)
    # ### end Alembic commands ###
