from airflow import DAG
from airflow.operators.bash import BashOperator

from datetime import datetime


with DAG(
    dag_id="dbt_test",
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
) as dag:

    dbt_debug = BashOperator(
        task_id="dbt_debug",
        bash_command="""
        cd /opt/airflow/dbt/olist_project &&
        dbt debug
        """
    )