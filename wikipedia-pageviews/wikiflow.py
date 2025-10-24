from airflow import DAG
from datetime import datetime, timedelta
from airflow.providers.standard.operators.bash import BashOperator
from airflow.providers.standard.operators.python import PythonOperator
from wikimedia.scripts.wikitran import select_companies
from wikimedia.scripts.sqlite_dump import load_to_sqlite
from wikimedia.scripts.query_db import query_top_company

default_args = {
    'owner':'chik0di',
    'retries':2,
    'retry_delay':timedelta(minutes=1)
}

with DAG(
    dag_id="WikiPageViewCount",
    default_args=default_args,
    start_date=datetime(2025, 10, 19),
    schedule=None,
    catchup=False
):
    download_pageviews = BashOperator(
        task_id="download_pageviews",
        bash_command="scripts/curl_unzip.sh"
    )

    filter_companies = PythonOperator(
        task_id='filter_companies',
        python_callable=select_companies
    )

    send_to_sqlite = PythonOperator(
        task_id="send_to_sqlite",
        python_callable=load_to_sqlite
    )

    get_top_company = PythonOperator(
        task_id="get_top_company",
        python_callable=query_top_company
    )

    download_pageviews >> filter_companies >> send_to_sqlite >> get_top_company
    