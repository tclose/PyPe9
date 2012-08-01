#!/usr/bin/env python
import sys
import os.path
import subprocess
from ninemlp.utilities.nmodl import build as build_nmodl
import socket
from backports import argparse

parser = argparse.ArgumentParser(description='Batch run comparisons of mechanisms')
parser.add_argument('--action', nargs=1, help="Just plot the files instead of running then plotting")
args = parser.parse_args()

if args.action:
    action = args.action[0]
    if action not in ['record', 'plot']:
        raise Exception("Unrecognised value '%s' passed to --action option." % args.action)
else:
    action = None

if 'NRNHOME' in os.environ:
    os.environ['PATH'] += os.pathsep + os.environ['NRNHOME']
else:
    os.environ['PATH'] += os.pathsep + '/opt/nrn-7.1/x86_64/bin' # Sorry this is the path on my machine (to save me having to set the environment variable in eclipse)

methods = ('noise', 'step')

PROJECT_PATH = os.path.normpath(os.path.join(os.path.realpath(__file__), '..', '..', '..', '..'))

NEW_PATH = os.path.join(PROJECT_PATH, 'NINEMLP', 'ncml', 'build', 'nmodl')
OLD_PATH = os.path.join(PROJECT_PATH, 'NINEMLP', 'ncml', 'build', 'nmodl.old')

ON_TOMBO = (socket.gethostname()[0:5] == 'tombo')

if action != 'plot':
    build_nmodl(NEW_PATH, build_mode='force')
    build_nmodl(OLD_PATH, build_mode='lazy')

if ON_TOMBO or action == 'record':
    save_action = '--save_recording'
else:
    save_action = '--save_plot'


for f in os.listdir(os.path.join(PROJECT_PATH, 'NINEMLP', 'ncml', 'build', 'nmodl')):
    (mech_name, ext) = os.path.splitext(f)
    if ext == '.mod':
        for method in methods:
            script_path = os.path.join(PROJECT_PATH, 'src', 'test', 'mechanisms.py')
            output_path = os.path.join(PROJECT_PATH, 'NINEMLP', 'ncml', 'build', 'nmodl',
                                                                'differences', method , mech_name)

            if action == 'plot':
                subprocess.check_call([script_path,
                                       '--plot', output_path,
                                       '--save_plot', output_path,
                                       '--lazy'])
            else:
                args = [script_path,
                         '--new_path', NEW_PATH,
                         '--old_path', OLD_PATH,
                         '-o', mech_name + '_old', 'neuron',
                         '-n', mech_name, 'neuron',
                         save_action, output_path,
                         '--lazy']
                if method == 'step':
                    args.append('--step')
                if ON_TOMBO:
                    subprocess.call(args)
                else:
                    subprocess.check_call(args)


