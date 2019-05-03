FROM python:3.7-alpine

# Replace the apk repositories for a better performance
RUN sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories

# Update the package list
RUN apk update

# Set timezone
RUN apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime \
    && apk del tzdata

# Add user airflow
RUN adduser -D -u 1000 airflow

ENV AIRFLOW_HOME /app
ENV AIRFLOW_GPL_UNIDECODE=yes

WORKDIR ${AIRFLOW_HOME}
COPY . ${AIRFLOW_HOME}
RUN chown -R airflow: ${AIRFLOW_HOME}

RUN set -ex \
    && apk add --no-cache --virtual=.build-deps \
        g++ \
        git \
        musl-dev \
        sqlite-dev \
        mariadb-dev \
        libxml2-dev \
        libxslt-dev \
        libffi-dev \
        linux-headers \
    && pip3 install --default-timeout 300 -r requirements.txt \
    && apk del .build-deps

RUN apk add mariadb-dev bash

ARG AIRFLOW_HOME=/app
ARG dag-path="$AIRFLOW_HOME/dags"
ARG log-path="$AIRFLOW_HOME/logs"

ENV ENV=local
ENV AIRFLOW_DAG_PATH $dag-path
ENV AIRFLOW_LOG_PATH $log-path
ENV AIRFLOW_DATABASE_URL mysql://airflow:airflow@db/airflow
ENV AIRFLOW_BROKER_URL redis://redis:6379/0
ENV AIRFLOW_RESULT_BACKEND db+mysql://airflow:airflow@db/airflow
ENV AIRFLOW_EXECUTOR CeleryExecutor
ENV AIRFLOW_API_AUTH your-top-secret

ENV AIRFLOW_REMOTE_LOGGING False
ENV AIRFLOW_TASK_LOG_READER file.task

USER airflow
EXPOSE 8080 5555 8793
ENTRYPOINT ["./bin/run.sh"]
CMD ["web"]
