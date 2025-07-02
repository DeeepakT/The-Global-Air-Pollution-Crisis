import psycopg2
from psycopg2 import sql

# PostgreSQL connection details
host = "localhost"
port = 5432  # Default PostgreSQL port
database = "air_quality_pollution_database"
username = "postgres"
password = "1234"

try:
    # Connect to the default 'postgres' database
    conn = psycopg2.connect(dbname="postgres", user=username, password=password, host=host, port=port)
    conn.autocommit = True  # Required for creating a new database

    # Create cursor
    cursor = conn.cursor()

    # Execute CREATE DATABASE command
    cursor.execute(sql.SQL("CREATE DATABASE {}").format(sql.Identifier(database)))

    print(f"Database '{database}' created successfully!")

    # Close connections
    cursor.close()
    conn.close()

except psycopg2.Error as e:
    print(f"Error: {e}")
