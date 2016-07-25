from __future__ import unicode_literals

from django.db import models

# Create your models here.


class roles(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.TextField()


class users(models.Model):
    email = models.TextField(primary_key=True)
    password = models.TextField()
    rol = models.ForeignKey(roles, on_delete=models.CASCADE)
    status = models.TextField()


class userInfo(models.Model):
    id = models.AutoField(primary_key=True)
    uid = models.ForeignKey(users, on_delete=models.CASCADE)
    first_name = models.TextField(null=True)
    last_name = models.TextField(null=True)
    address = models.TextField(null=True)
    groupId = models.TextField(null=True)


class groups(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.TextField()
    ffId = models.TextField()
