from airflow.plugins_manager import AirflowPlugin

from blueprints.airflow_api import airflow_api_blueprint
from operators.setup_operator import SetupOperator


class CurstomPlugin(AirflowPlugin):
    name = "custom_plugin"
    operators = [
        SetupOperator
    ]
    # hooks = []
    # executors = []
    # macros = []
    # admin_views = []
    # flask_blueprints = []
    # menu_links = []


class AstronomerPlugin(AirflowPlugin):
    name = "airflow_api"

    flask_blueprints = [
        airflow_api_blueprint
    ]
