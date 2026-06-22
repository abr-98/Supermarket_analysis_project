from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.databricks.operators.databricks import DatabricksRunNowOperator
from datetime import datetime, timedelta

default_args = {
    "retries": 3,
    "retry_delay": timedelta(minutes=5)
}
with DAG(
    dag_id="olist_pipeline",

    start_date=datetime(2025,1,1),

    schedule="@daily",

    catchup=False,
    default_args=default_args
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
    
    ML_analysis_task = DatabricksRunNowOperator(
        task_id="ML_analysis_task",
        databricks_conn_id="databricks_default",
        job_id=105129514371397
    )


    dbt_run = BashOperator(
        task_id="dbt_run",

        bash_command="""
        cd /opt/airflow/dbt/olist_project &&
        dbt run --full-refresh
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

    transformation >> Migration_task >> dbt_run >> dbt_test >> dbt_snapshot >> ML_analysis_task