# Airflow-Boilerplate

- [Airflow](https://github.com/apache/incubator-airflow) based DAG(directed acyclic graph) workflows management system.

## Prerequisites

Please install [direnv](https://direnv.net/), [pyenv](https://github.com/pyenv/pyenv), and [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) for the local development.

### .direnvrc

Please copy the `.direnvrc` file to your `$HOME` directory. It allows some bash functions declared in `.direnvrc` file to be available in `.envrc`.

```
cp .direnvrc $HOME
```

After having the installation the above packages, you can see the folllowing results:

```
$ git clone git@github.com:ziwon/airflow-boilerplate.git
$ cd airflow-boilerplate
direnv: loading .envrc
direnv: using python 3.5.5
direnv: export +AIRFLOW_API_AUTH +AIRFLOW_DATABASE_URL +AIRFLOW_EXECUTOR +AIRFLOW_HOME +AIRFLOW_RESULT_BACKEND +VIRTUAL_ENV ~PATH
```

## Development

Both of Web UI and Scheduler should be launched separately in the local environment.

Launch the Web UI server:

```
$ cd airflow-boilerplate
direnv: loading .envrc
direnv: using python 3.5.5
direnv: export +AIRFLOW_API_AUTH +AIRFLOW_DATABASE_URL +AIRFLOW_EXECUTOR +AIRFLOW_HOME +AIRFLOW_RESULT_BACKEND +VIRTUAL_ENV ~PATH

$ ./bin/run web
```

Lunch the Scheduler in other console:

```
$ cd airflow-boilerplate
direnv: loading .envrc
direnv: using python 3.5.5
direnv: export +AIRFLOW_API_AUTH +AIRFLOW_DATABASE_URL +AIRFLOW_EXECUTOR +AIRFLOW_HOME +AIRFLOW_RESULT_BACKEND +VIRTUAL_ENV ~PATH

$ ./bin/run scheduler
```

## Running
Please wait patiently, due to taking ages to build panas in alpine (While your computer is building this image, you might be able to cook your Thanksgiving turkey). Or you can change it to the prebuilt image to get done in short.

```
make build
make start
```

## Links
- [Awesome Airflow](https://github.com/jghoman/awesome-apache-airflow)
- [Airflow Best Practices Guide](https://docs.astronomer.io/v2/apache_airflow/best-practices-guide.html)
- [ETL best practices with Airflow documentation site](https://gtoonstra.github.io/etl-with-airflow/)
- [Airflow: Tips, Tricks, and Pitfalls](https://medium.com/handy-tech/airflow-tips-tricks-and-pitfalls-9ba53fba14eb)
- [Developing elegant workflows in Python code with Apache Airflow](https://ep2017.europython.eu/conference/talks/developing-elegant-workflows-in-python-code-with-apache-airflow)
