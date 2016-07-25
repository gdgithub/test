# -*- coding: utf-8 -*-
"""
Fichero de configuracion de Fab para desplegar aplicacion web
"""

from __future__ import with_statement
from fabric.api import env, require, run, sudo, cd, prefix
from fabric.contrib.files import exists

#--------------------------------------
#environments
#--------------------------------------


def contest():
    "Servidor remoto para pruebas de desarrollo"
    env.name = 'contest'
    env.user = 'server_user_name'
    env.project_name = 'project_name'
    env.hosts = ['127.0.0.1']
    env.branch = 'master'
    env.repo = 'repo_url'
    env.project_root = '/projects_dir/%(project_name)s/' % env
    env.django_manager = '/projects_dir/%(project_name)s/src' % env
    env.logs = '/logs_dir/%(project_name)s/' % env
    env.venv = '/enviroment_dir/%(project_name)s' % env

def local():
    env.name = 'local'
    env.user = 'root'
    env.project_name = 'MyOrder'
    env.hosts = ['127.0.0.1']
    env.branch = 'master'
    #env.repo = 'url'
    env.project_root = '../%(project_name)s/' % env
    env.django_manager = '%(project_root)s/src' % env
    env.logs = '/logs_dir/%(project_name)s/' % env
    env.venv = '../'

#--------------------------------------
#commands
#--------------------------------------

def v_deploy():
    """
    Para desplegar la aplicación en un ambiente virtualenv.

    Recomendado para servidores con múltiples aplicaciones Django.
    """
    require('name')
    require('venv')
    download_site()
    setup_pip_requeriments()
    virtualenv_syncdb()
    virtualenv_collectstatic()
    gunicorn_conf()
    supervisor_conf()
    supervisor_restart()
    nginx_conf()
    nginx_restart()


def vfull_deploy():
    """
    Para desplegar la aplicación y todas sus dependencias en un ambiente
    virtualenv.

    Recomendado para desplegar por primera vez en servidores con múltiples
    aplicaciones Django.
    """
    setup_requeriments()
    setup_directories()
    create_virtualenv()
    v_deploy()


def vfast_deploy():
    """
    Para desplegar la aplicación de forma rápida en un ambiente virtualenv.

    No instala dependencias.
    No sincroniza los modelos con la base de datos.

    Debido a lo anterior este metodo de despliegue solo debe usarse
    para pequenas actualizaciones en codigo python. (excepto a los modelos)
    """
    require('name')
    require('venv')
    download_site()
    virtualenv_collectstatic()
    supervisor_restart()


def setup_requeriments():
    """
    Setup required packages via OS package manager
    """
    run("apt-get update")
    run("apt-get install git -y")
    run("apt-get install python-imaging -y")
    run("apt-get install libjpeg-dev zlib1g-dev libfreetype6 libfreetype6-dev python-dev -y")
    run("apt-get install python2.7")
    run("apt-get install python-setuptools python-pip -y")
    run("apt-get install python-virtualenv -y")
    run("apt-get install python-psycopg2 -y")
    run("apt-get install nginx -y")
    run("apt-get install supervisor -y")
    run("apt-get install libevent-dev -y")


def git_clone():
    """
    Clone git repo
    """
    run("git clone %(repo)s %(project_root)s" % env)
    with cd(env.project_root):
        run("git checkout %(branch)s" % env)


def git_pull():
    """
    Pulls the site from the specified repository's branch
    """
    with cd(env.project_root):
        run("git reset --hard")
        run("git pull origin %(branch)s" % env)


def download_site():
    """
    Pulls files from repo or clone if required
    Also set permissions for web server access
    """

    if exists("%(project_root)s/.git/" % env):
        git_pull()
    else:
        git_clone()
    run("chmod 777 -R %(project_root)s" % env)


def setup_directories():
    """
    Setups the required directories and permissions
    """
    #set base folders
    run("mkdir -p %(project_root)s" % env)
    run("mkdir -p %(venv)s" % env)
    run("mkdir -p %(logs)s" % env)

    #set permissions for web server
    run("chown -R %(user)s:www-data %(project_root)s" % env)


def create_virtualenv():
    """
    Create required folders and setups virtual environment, if necessary
    """
    require("venv")
    if not exists("%(venv)s/bin/python" % env):
        run("virtualenv %(venv)s" % env)


def setup_pip_requeriments():
    """
    Install PIP req in virtual environment
    """
    with cd(env.project_root):
        with prefix("source %(venv)s/bin/activate" % env):
            run('pip install -r req/%(name)s.txt' % env)


def virtualenv_syncdb():
    """
    Syncronize db with Django's models
    """
    with cd(env.django_manager):
        with prefix("source %(venv)s/bin/activate" % env):
            run("python manage.py syncdb --settings=main.settings.%(name)s" %env)
            run("python manage.py loaddata demo_data --settings=main.settings.%(name)s" %env)


def gunicorn_conf():
    """
    Copy gunicorn configuration for this site
    """
    with cd(env.project_root):
        run("cp -f conf/%(name)s/gunicorn.conf src/gunicorn.py" % env)
        run("cp -f conf/%(name)s/gunicorn.sh src/gunicorn.sh" % env)
        run("chmod +x src/gunicorn.sh")


def nginx_conf():
    """
    Copy and activate nginx configuration for this site
    """
    with cd(env.project_root):
        run("cp --remove-destination conf/%(name)s/nginx.conf  /etc/nginx/sites-available/%(project_name)s.conf" % env)
        if not exists("/etc/nginx/sites-enabled/%(project_name)s.conf" % env):
            run("ln -s /etc/nginx/sites-available/%(project_name)s.conf /etc/nginx/sites-enabled/" % env)


def supervisor_conf():
    """
    Copy supervisor configuration for this site
    """
    with cd(env.project_root):
        run("cp -f conf/%(name)s/supervisor.conf /etc/supervisor/conf.d/%(project_name)s.conf" % env)
        run("chmod 777 -R /etc/supervisor/conf.d/" % env)
        run("mkdir -p %(logs)s" % env)
        run("touch %(logs)ssupervisor-out.log" % env)
        run("touch %(logs)ssupervisor-err.log" % env)
        run("supervisorctl update" % env)


def supervisor_restart():
    """
    Restart Supervisor process
    """
    run("supervisorctl restart %(project_name)s" % env)


def clean():
    """Clear out extraneous files, like pyc/pyo"""
    with cd(env.project_root):
        run("""find -type f -name "*.py[co~]" -delete""")


def nginx_restart():
    """
    Reload nginx configuration
    """
    run("service nginx restart")


def virtualenv_collectstatic():
    """
    Collect Django's statics files
    """
    with cd(env.django_manager):
        with prefix("source %(venv)s/bin/activate" % env):
            run('python manage.py collectstatic --noinput --settings=main.settings.%(name)s' % env)
