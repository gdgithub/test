#!/usr/bin/env python
import os
import sys
import json

if __name__ == "__main__":
        #env = json.loads(open('conf.json', 'r').readlines()[0])['env']
        #os.environ.setdefault("DJANGO_SETTINGS_MODULE", "main.settings.{0}".format(env))
    os.environ.setdefault("DJANGO_SETTINGS_MODULE",
                          "MyOrder.src.main.settings.contest")

    from django.core.management import execute_from_command_line
    execute_from_command_line(sys.argv)
