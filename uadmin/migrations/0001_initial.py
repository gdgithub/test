# -*- coding: utf-8 -*-
# Generated by Django 1.9.7 on 2016-06-30 03:37
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='contacts',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.TextField()),
                ('phone', models.TextField()),
                ('address', models.TextField()),
                ('category_id', models.TextField()),
            ],
        ),
    ]