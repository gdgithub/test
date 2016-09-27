from __future__ import unicode_literals

from django.db import models

# Create your models here.


class category(models.Model):
    id = models.AutoField(primary_key=True)
    description = models.TextField()


class contacts(models.Model):
    id = models.AutoField(primary_key=True)
    rnc = models.TextField()
    cid = models.ForeignKey(category, on_delete=models.CASCADE)
    name = models.TextField(null=True)
    phone = models.TextField(null=True)
    address = models.TextField(null=True)
    rate = models.FloatField()
    description = models.TextField(null=True)
    status = models.TextField(null=True)


class menu_category(models.Model):
    id = models.AutoField(primary_key=True)
    description = models.TextField()


class menu(models.Model):
    id = models.AutoField(primary_key=True)
    contact_id = models.ForeignKey(contacts, on_delete=models.CASCADE)
    name = models.TextField()


class dishes(models.Model):
    id = models.AutoField(primary_key=True)
    menuId = models.ForeignKey(menu, on_delete=models.CASCADE)
    name = models.TextField()
    description = models.TextField(null=True)
    price = models.FloatField()
    menu_category_id = models.ForeignKey(
        menu_category, on_delete=models.CASCADE)


class rating(models.Model):
    id = models.AutoField(primary_key=True)
    contact_id = models.ForeignKey(contacts, on_delete=models.CASCADE)
    user_id = models.TextField()
    value = models.IntegerField()


# Ordenes

class orders_master(models.Model):
    id = models.AutoField(primary_key=True)
    user_id = models.TextField()
    contact_id = models.ForeignKey(contacts, on_delete=models.CASCADE)
    status = models.TextField()
    date = models.DateField(auto_now=True)


class orders_details(models.Model):
    id = models.AutoField(primary_key=True)
    order_master_id = models.ForeignKey(
        orders_master, on_delete=models.CASCADE)
    amount = models.IntegerField()
    description = models.TextField()
    price = models.FloatField()
    total = models.FloatField()


# Grupos

class groups_master(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.TextField()
    ffid = models.TextField()


class groups_details(models.Model):
    id = models.AutoField(primary_key=True)
    group_master_id = models.ForeignKey(
        groups_master, on_delete=models.CASCADE)
    user_id = models.TextField()


# Notificaciones

class notifications(models.Model):
    id = models.AutoField(primary_key=True)
    type = models.TextField()
    master_id = models.TextField()
    user_id = models.TextField()
    status = models.TextField()
