import os
from dotenv import load_dotenv
import mysql.connector
from mysql.connector import errorcode

# load environement variables from .env
load_dotenv()

# connection configuration
cfg = dict(
    host=os.getenv("DB_HOST"),
    port=int(os.getenv("DB_PORT", 3306)),
    database=os.getenv("DB_DATABASE"),
    user=os.getenv("DB_USERNAME"),
    password=os.getenv("DB_PASSWORD"),
    )

def get_connection():
    """
    Create and return a MySQL database connection using environment variables.
    """
    return mysql.connector.connect(**cfg)