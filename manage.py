#!/usr/bin/env python
import os
import sys
import json

if __name__ == "__main__":
	env = json.loads(open('src/conf.json', 'r').readlines()[0])['env']
	os.environ.setdefault("DJANGO_SETTINGS_MODULE",
	                      "src.main.settings.{0}".format(env))

	from django.core.management import execute_from_command_line
	execute_from_command_line(sys.argv)
