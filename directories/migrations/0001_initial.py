# -*- coding: utf-8 -*-
# Generated by Django 1.9.7 on 2016-07-08 12:21
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='branch',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('phone', models.TextField()),
                ('address', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='category',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('description', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='comment',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('uid', models.TextField()),
                ('description', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='contacts',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('rnc', models.TextField()),
                ('name', models.TextField()),
                ('image', models.TextField()),
                ('description', models.TextField()),
                ('rating', models.FloatField()),
                ('categoryId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='directories.category')),
            ],
        ),
        migrations.CreateModel(
            name='menu',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('description', models.TextField()),
                ('price', models.FloatField()),
                ('branchId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='directories.branch')),
            ],
        ),
        migrations.CreateModel(
            name='orders',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('userId', models.TextField()),
                ('description', models.TextField()),
                ('status', models.TextField()),
                ('branchId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='directories.branch')),
            ],
        ),
        migrations.CreateModel(
            name='ratings',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('uid', models.TextField()),
                ('value', models.IntegerField()),
                ('contactId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='directories.contacts')),
            ],
        ),
        migrations.AddField(
            model_name='comment',
            name='contactId',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='directories.contacts'),
        ),
        migrations.AddField(
            model_name='branch',
            name='contactId',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='directories.contacts'),
        ),
    ]