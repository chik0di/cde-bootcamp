from airflow import DAG
from airflow.providers.snowflake.transfers.copy_into_snowflake import CopyFromExternalStageToSnowflakeOperator
from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import Mount
from datetime import datetime, timedelta

# default_args = {
#     'owner':'chik0di',
#     'retries':2,
#     'retry_delay':timedelta(minutes=1)
# }

with DAG(
    dag_id="superstore_snowflake",
    # default_args=default_args,
    start_date=datetime(2025, 10, 25),
    schedule="@daily",
    catchup=False
):
    
    copy_data = CopyFromExternalStageToSnowflakeOperator(
        task_id="copy_csv",
        snowflake_conn_id="snowflake_conn",
        table="superstore",
        stage="amazon_s3_stage",
        file_format="""(
            TYPE = 'CSV'
            FIELD_OPTIONALLY_ENCLOSED_BY = '"'
            ENCODING = 'ISO8859-1'
            SKIP_HEADER = 1
            )""",
        files=["Superstore.csv"]
    )

    mounts = [
        Mount(
            target="/root/.dbt",  
            source="C:/Users/PC/Documents/airflow/dags/superstore/.dbt",
            type="bind",
            read_only=True
        )
    ]

    run_dbt_on_docker = DockerOperator(
        task_id="run_dbt_on_docker",
        docker_conn_id="docker_conn",
        image="chik0di/dbt",
        command="run",
        docker_url="tcp://host.docker.internal:2375",
        api_version="auto",
        network_mode="bridge",
        auto_remove="success",
        mounts=mounts
    )

    copy_data >> run_dbt_on_docker