FROM postgres:latest

RUN apt upgrade \
    && apt update \
    && apt install -y build-essential postgresql-server-dev-all python3 python3-pip \
    && pip3 install antlr4-python3-runtime psycopg2 mysql-replication cos-python-sdk-v5
