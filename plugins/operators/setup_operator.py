import config

from airflow.operators.bash_operator import BaseOperator
from airflow.utils.decorators import apply_defaults


class SetupOperator(BaseOperator):
    """
    Load the environment variables before a Dag is running,
    and set the parameters for the entire workflow in a Dag as ``conf`` argument
    and return ``conf`` value as an XCom value.
    """
    template_fields = ('conf',)
    template_ext = ('.json',)
    ui_color = '#e8f7e4'

    @apply_defaults
    def __init__(self,
                 conf=None,
                 transfer=None,
        *args, **kwargs):
        super(SetupOperator, self).__init__(*args, **kwargs)

        # config.load_env()

        self.conf = conf
        self.transfer = transfer
        self.provide_context = True

    def execute(self, context):
        if isinstance(self.conf, dict) and self.transfer:
            self.conf = map(self.transfer, self.conf)
        return self.conf
