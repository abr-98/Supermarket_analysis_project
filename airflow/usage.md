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