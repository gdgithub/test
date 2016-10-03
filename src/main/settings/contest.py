# coding=utf-8
from base import *

SITE_ID = 1

DEBUG = False
ALLOWED_HOSTS = ['*']

STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

"""
#Intellisys
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'd68h5nkrporfnk',
        'USER': 'ulddsnxfpfcblu',
        'PASSWORD': 'VyuNwr5ZDe6Z5ZN8dS7g6BGlWj',
        'HOST': 'ec2-54-235-208-104.compute-1.amazonaws.com',
        'PORT': '5432',
    }
}
"""

#gdgithub
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'dc9ddj39dhrtnn',
        'USER': 'omidfobhiygbrh',
        'PASSWORD': 'DmK60EvpH-NkDoK0yI8PwJ2Or6',
        'HOST': 'ec2-54-225-246-33.compute-1.amazonaws.com',
        'PORT': '5432',
    }
}
