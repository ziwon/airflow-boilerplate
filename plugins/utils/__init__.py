from airflow import DAG, settings
from airflow.models import DagRun
from airflow.utils.state import State
from jinja2.exceptions import UndefinedError


# Allows to access template strings which might not defined as template fields in Airflow's Operator.
# This is mainly for accessing the values from xcom.
def interpolate_xcom(value: str=None, dag: DAG=None, task_id: str=None) -> str:
    if not 'xcom' in value:
        return value

    session = settings.Session()
    DR = DagRun
    dr = session.query(DR).filter(
        DR.dag_id == dag.dag_id,
        DR.execution_date == dag.latest_execution_date,
        DR.state == State.RUNNING
    ).first()

    if not dr:
        return None

    ti = dr.get_task_instance(task_id)
    if not ti:
        return None

    if not ti.state and ti.state == State.FAILED:
        return None

    try:
        jinja_env = dag.get_template_env()
        template = jinja_env.from_string(value)
        rendered = template.render({'ti': ti})
        return rendered if len(rendered) != 0 else None
    except UndefinedError:
        return value
