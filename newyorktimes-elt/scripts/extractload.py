import os
import time
import requests
import json
import pandas as pd
from psycopg2.extras import Json
from sqlalchemy import create_engine

def execute():
    # Get environment variables
    db_user = os.getenv("DB_USER")
    db_pass = os.getenv("DB_PASS")
    db_name = os.getenv("DB_NAME")
    db_host = os.getenv("DB_HOST")
    db_port = os.getenv("DB_PORT")
    API_KEY = os.getenv("API_KEY")

    # Validate API key
    if not API_KEY:
        raise ValueError("API_KEY environment variable is not set")

    connection_string = f"postgresql+psycopg2://{db_user}:{db_pass}@{db_host}:{db_port}/{db_name}"
    print(f"Connecting to database at {db_host}:{db_port}/{db_name}")
    
    engine = create_engine(connection_string)

    print("Fetching data from NYT API...")
    requestUrl = f"https://api.nytimes.com/svc/mostpopular/v2/viewed/30.json?api-key={API_KEY}"
    requestHeaders = {"Accept": "application/json"}

    response = requests.get(requestUrl, headers=requestHeaders)    
    data = response.json()
    articles = data['results']
    print(f"Fetched {len(articles)} articles")
    
    # Convert to DataFrame
    df = pd.DataFrame(articles)
    df.drop('media', axis=1, inplace=True)
    df['loaded_at'] = pd.Timestamp.now()
    
    print(f"DataFrame shape: {df.shape}")
    print(f"DataFrame columns: {df.columns.tolist()}")
    print(f"DataFrame dtypes:\n{df.dtypes}")

    # try:
    df.to_sql(
        'staging_nyt',
        con=engine,
        if_exists='append',
        index=False
    )
    # except Exception as e:
    #     if "does not exist" 

    print(f"Successfully loaded articles into 'staging_nyt'")

if __name__ == "__main__":
    try:
        execute()
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
        raise