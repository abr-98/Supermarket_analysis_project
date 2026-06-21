from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.databricks.operators.databricks import DatabricksRunNowOperator
from datetime import datetime

from datetime import datetime


with DAG(
    dag_id="olist_pipeline",

    start_date=datetime(2025,1,1),

    schedule="@daily",

    catchup=False
) as dag:

    transformation = DatabricksRunNowOperator(
        task_id="Olist_Medallion_Modelling",
        databricks_conn_id="databricks_default",
        job_id=997005844011450
    )
    
    Migration_task = DatabricksRunNowOperator(
        task_id="Migration_task",
        databricks_conn_id="databricks_default",
        job_id=167285196996795
    )


    dbt_run = BashOperator(
        task_id="dbt_run",

        bash_command="""
        cd /opt/airflow/dbt/olist_project &&
        dbt run
        """
    )

    dbt_test = BashOperator(
        task_id="dbt_test",

        bash_command="""
        cd /opt/airflow/dbt/olist_project &&
        dbt test
        """
    )

    dbt_snapshot = BashOperator(
        task_id="dbt_snapshot",

        bash_command="""
        cd /opt/airflow/dbt/olist_project &&
        dbt snapshot
        """
    )

    transformation >> Migration_task >> dbt_run >> dbt_test >> dbt_snapshot