## Installation Commands

mkdir airflow
cd airflow

curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.11.0/docker-compose.yaml'

mkdir dags logs plugins config

echo "AIRFLOW_UID=$(id -u)" > .env

docker compose up airflow-init

docker compose up

username: airflow
password: airflow


## For connections

For databricks connection: Create PAT.
Add connection in admin as:

Connection ID: databricks_default
Connection Type: Databricks
Host:
https://<your-workspace-url>
Password:
<Personal Access Token>