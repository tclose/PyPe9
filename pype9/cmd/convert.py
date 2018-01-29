"""
Tool to convert 9ML files between different supported formats (e.g. XML_,
JSON_, YAML_) and 9ML versions.
"""
from argparse import ArgumentParser
from pype9.utils.arguments import nineml_document
from pype9.utils.logging import logger, set_loglevel


def argparser():
    parser = ArgumentParser(prog='pype9 convert',
                            description=__doc__)
    parser.add_argument('in_file', type=nineml_document,
                        help="9ML file to be converted")
    parser.add_argument('out_file', help="Converted filename")
    parser.add_argument('--nineml_version', '-v', type=str, default=None,
                        help="The version of nineml to output")
    parser.add_argument('--loglevel', type=str, default='INFO',
                        help="Sets the verbosity level of the logger")
    return parser


def run(argv):
    args = argparser().parse_args(argv)
    set_loglevel(args.loglevel)
    import pype9.utils.logging.handlers.sysout  # @UnusedImport

    doc = args.in_file.clone()
    kwargs = {}
    if args.nineml_version is not None:
        kwargs['version'] = args.nineml_version
    doc.write(args.out_file, **kwargs)
    logger.info("Converted '{}' to '{}'".format(args.in_file, args.out_file))
