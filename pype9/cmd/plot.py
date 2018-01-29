"""
Simple tool for plotting the output of PyPe9 simulations using Matplotlib_.
Since Pype9 output is stored in Neo_ format, it can be used to plot generic
Neo_ files but it also includes handling of Pype9-specific annotations, such as
regime transitions.
"""
from argparse import ArgumentParser
from pype9.utils.arguments import existing_file
from pype9.utils.logging import logger, set_loglevel  # @UnusedImport


def argparser():
    parser = ArgumentParser(prog='pype9 plot',
                            description=__doc__)
    parser.add_argument('filename', type=existing_file,
                        help="Neo file outputted from a PyPe9 simulation")
    parser.add_argument('--save', type=str, default=None,
                        help="Location to save the figure to")
    parser.add_argument('--dims', type=int, nargs=2, default=(10, 8),
                        metavar=('WIDTH', 'HEIGHT'),
                        help="Dimensions of the plot")
    parser.add_argument('--hide', action='store_true', default=False,
                        help="Whether to show the plot or not")
    parser.add_argument('--resolution', type=float, default=300.0,
                        help="Resolution of the figure when it is saved")
    parser.add_argument('--loglevel', type=str, default='INFO',
                        help="Sets the verbosity level of the logger")
    return parser


def run(argv):
    import neo
    from pype9.exceptions import Pype9UsageError
    args = argparser().parse_args(argv)
    if args.hide:
        import matplotlib  # @IgnorePep8
        matplotlib.use('Agg')  # Set to use Agg so DISPLAY is not required
    from pype9.plot import plot  # @IgnorePep8
    set_loglevel(args.loglevel)
    import pype9.utils.logging.handlers.sysout  # @UnusedImport

    segments = neo.PickleIO(args.filename).read()
    if len(segments) > 1:
        raise Pype9UsageError(
            "Expected only a single recording segment in file '{}', found {}."
            .format(args.filename, len(segments)))

    seg = segments[0]
    plot(seg, dims=args.dims, show=not args.hide, resolution=args.resolution,
         save=args.save)
