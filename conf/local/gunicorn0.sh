#!/bin/bash
set -e
APP_NAME=MyOrder

LOGFILE=..gunicorn.log
LOGDIR=$(dirname $LOGFILE)

cd /projects_dir/project_name/src
source /enviroment_dir/project_dir/bin/activate

test -d $LOGDIR || mkdir -p $LOGDIR

exec gunicorn -b 127.0.0.1:9050 -e DJANGO_SETTINGS_MODULE=main.settings.contest main.wsgi:application -c gunicorn.py --log-file=$LOGFILE 2>>$LOGFILE
