from __future__ import unicode_literals

from django.db import models

# Create your models here.


class notifications(models.Model):
    id = models.AutoField(primary_key=True)
    type = models.TextField()
    uid = models.TextField()
    oid = models.TextField()
    description = models.TextField()
    status = models.TextField()
