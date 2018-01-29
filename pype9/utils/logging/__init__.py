import logging
from pype9.exceptions import Pype9UsageError

logger = logging.getLogger('pype9')
loglevel = logging.INFO


def set_loglevel(level):
    global loglevel
    level = level.upper()
    try:
        loglevel = getattr(logging, level)
    except AttributeError:
        raise Pype9UsageError(
            "'{}' is not a valid log level (DEBUG, INFO, WARNING,"
            "ERROR)".format(level))
