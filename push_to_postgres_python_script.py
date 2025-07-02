import pandas as pd
from sqlalchemy import create_engine
import os

# PostgreSQL connection details
host = "localhost"
port = 5432  # Default PostgreSQL port
database = "air_quality_pollution_database"
username = "postgres"
password = "1234"

# Path to the directory containing the CSV files
csv_dir = r"E:\Analysis on Air Quality Index, Air pollution & Air Pollution Death Rate"  # path where CSV files are stored

# List of your CSV files
csv_files = [
    "aqi_who.csv",
    "death_by_risk_factor_year_2021.csv",
    "death_rate_from_air_pollution_2011_2021.csv",
    "gdp_per_capita.csv",
    "population-density.csv",
    "urbanization.csv"
]

# Created a connection to the PostgreSQL database using pg8000
engine = create_engine(f"postgresql+pg8000://{username}:{password}@{host}:{port}/{database}")

# Iterate through each CSV file and push it to PostgreSQL
for csv_file in csv_files:
    file_path = os.path.join(csv_dir, csv_file)
    
    # Load the CSV file into a DataFrame
    df = pd.read_csv(file_path)
    
    # Replace spaces with underscores for table names and remove non-alphanumeric characters
    table_name = os.path.splitext(csv_file)[0].replace(" ", "_").replace("-", "_")
    
    # Write the DataFrame to PostgreSQL
    df.to_sql(table_name, engine, if_exists="replace", index=False)
    print(f"Table '{table_name}' has been pushed to PostgreSQL.")

print("All tables have been successfully pushed to the PostgreSQL server.")
