FROM apache/airflow:2.11.0

USER root

RUN apt-get update && \
    apt-get install -y git

USER airflow

COPY requirements.txt .
RUN pip install -r requirements.txt