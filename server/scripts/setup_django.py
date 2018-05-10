"""
setup_django.py - robustly handle setting up the Django environment for standalone Python scripts.
Author: Mike Kibbel, mkibbel@capstrat.com - November 6, 2007

Simply copy this file into the same folder as your standalone script.
To set up the Django environment, the first line of your script should read:

import setup_django

Then, you'll be able to use Django as you'd expect, e.g. from myproject.myapp.models import MyModel
"""
import os
import sys
import re

os.environ["DJANGO_SETTINGS_MODULE"] = 'ridecall.settings'

# stop after reaching '/' on nix or 'C:\' on Windows
top_level_rx = re.compile(r'^(/|[a-zA-Z]:\\)$')

def is_top_level(path):
    return top_level_rx.match(path) is not None

def prepare_environment():
    # we'll need this script's directory for searching purposess
    curdir, curfile = os.path.split(os.path.abspath(__file__))

    # move up one directory at a time from this script's path, searching for settings.py
    settings_module = None
    while not settings_module:
        settings_module = os.path.exists(os.path.join(curdir, 'ridecall/settings.py'))

        # have we reached the top-level directory?
        if is_top_level(curdir):
            raise Exception("settings.py was not found in the script's directory or any of its parent directories.")

        sys.path.insert(0, curdir)
        # move up a directory
        curdir = os.path.normpath(os.path.join(curdir, '..'))
        sys.path.insert(0, curdir)

prepare_environment()
