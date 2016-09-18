# coding=utf-8
from base import *

SITE_ID = 1

DEBUG = False
ALLOWED_HOSTS = ['*']

STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

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
