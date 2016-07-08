from __future__ import unicode_literals

from django.db import models

# Create your models here.


class category(models.Model):
    id = models.AutoField(primary_key=True)
    description = models.TextField()


class contacts(models.Model):
    id = models.AutoField(primary_key=True)
    rnc = models.TextField()
    name = models.TextField()
    image = models.TextField()
    description = models.TextField()
    categoryId = models.ForeignKey(category, on_delete=models.CASCADE)
    rating = models.FloatField()


class branch(models.Model):
    id = models.AutoField(primary_key=True)
    contactId = models.ForeignKey(contacts, on_delete=models.CASCADE)
    phone = models.TextField()
    address = models.TextField()


class ratings(models.Model):
    id = models.AutoField(primary_key=True)
    contactId = models.ForeignKey(contacts, on_delete=models.CASCADE)
    uid = models.TextField()
    value = models.IntegerField()


class comment(models.Model):
    id = models.AutoField(primary_key=True)
    contactId = models.ForeignKey(contacts, on_delete=models.CASCADE)
    uid = models.TextField()
    description = models.TextField()


class menu(models.Model):
    id = models.AutoField(primary_key=True)
    branchId = models.ForeignKey(branch, on_delete=models.CASCADE)
    description = models.TextField()
    price = models.FloatField()


class orders(models.Model):
    id = models.AutoField(primary_key=True)
    userId = models.TextField()
    branchId = models.ForeignKey(branch, on_delete=models.CASCADE)
    description = models.TextField()
    status = models.TextField()
