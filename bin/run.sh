#!/usr/bin/env bash

set -eo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="$( dirname "$DIR" )"

# airflow environment variables
export AIRFLOW_HOME=${AIRFLOW_HOME:-$BASE_DIR}
export AIRFLOW_DATABASE_URL=${AIRFLOW_DATABASE_URL:-sqlite:///$AIRFLOW_HOME/airflow.db}

export AIRFLOW_FERNET_KEY=${AIRFLOW_FERNET_KEY:-0000000000000000000000000000000000000000000=}
export AIRFLOW_API_AUTH=${AIRFLOW_API_AUTH:-toosecret}


export AIRFLOW_WEB_HOST=${AIRFLOW_WEB_HOST:-"0.0.0.0"}
export AIRFLOW_WEB_PORT=${AIRFLOW_WEB_PORT:-8080}
export AIRFLOW_WEB_URL=${AIRFLOW_WEB_URL:-http://0.0.0.0:8080}
export AIRFLOW_WEB_SECRET=${AIRFLOW_WEB_SECRET:-MDAwMDAwMDAwMDAwMDAwMA==}

export AIRFLOW_SMTP_HOST=${AIRFLOW_SMTP_HOST:-localhost}
export AIRFLOW_SMTP_USER=${AIRFLOW_SMTP_USER:-airflow}
export AIRFLOW_SMTP_PASSWORD=${AIRFLOW_SMTP_PASSWORD:-airflow}
export AIRFLOW_SMTP_MAIL_FROM=${AIRFLOW_SMTP_MAIL_FROM:-airflow@example.com}

export AIRFLOW_EXECUTOR=${AIRFLOW_EXECUTOR:-LocalExecutor}
export AIRFLOW_NUM_OF_WORKERS=${AIRFLOW_NUM_OF_WORKERS:-2}

export AIRFLOW_BROKER_URL=${AIRFLOW_BROKER_URL:-sqla+mysql://airflow:airflow@127.0.0.1:3306/airflow}
export AIRFLOW_RESULT_BACKEND=${AIRFLOW_RESULT_BACKEND:-db+mysql://airflow:airflow@127.0.0.1:3306/airflow}

export AIRFLOW_LOGGING_CONFIG_CLASS=${AIRFLOW_LOGGING_CONFIG_CLASS:-''}
export AIRFLOW_REMOTE_LOGGING=${AIRFLOW_REMOTE_LOGGING:-False}
export AIRFLOW_TASK_LOG_READER=${AIRFLOW_TASK_LOG_READER:-task}

# default variables
: "${HOST:=$AIRFLOW_WEB_HOST}"
: "${PORT:=$AIRFLOW_WEB_PORT}"
: "${WORKER:=$AIRFLOW_NUM_OF_WORKERS}"
: "${SLEEP:=1}"
: "${TRIES:=10}"

usage() {
  echo "usage: bin/run web|worker|scheduler|flower"
  exit 1
}

wait_for() {
  local tries=0
  while true; do
    echo "Waiting for $1 to listen on $2.."
    [[ $tries -lt $TRIES ]] || return
    nc -z $1 $2 >/dev/null 2>&1
    [[ $? -eq 0 ]] && return
    sleep $SLEEP
    tries=$((tries + 1))
  done
}

[ $# -lt 1 ] && usage

# Only wait for backend services in local development
[ ! -z "$ENV" ] && [ "$ENV" == "local" ] && {
  wait_for db 3306 && echo "[db] is ready" || echo "Giving up to check [db]"
  wait_for redis 6379 && echo "[redis] is ready" || echo "Giving up to check [redis]"
}

case $1 in
  web)
    airflow initdb
    if [ "$AIRFLOW_EXECUTOR" = "LocalExecutor" ]; then
      # With the "Local" executor it should all run in one container.
      airflow scheduler &
    fi
    exec airflow webserver
    ;;
  scheduler|worker)
    sleep 10
    exec airflow "$@"
    ;;
  flower)
    exec airflow "$@"
    ;;
  initdb|upgradedb|resetdb)
    exec airflow "$@"
    ;;
esac
