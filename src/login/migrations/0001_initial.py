# -*- coding: utf-8 -*-
# Generated by Django 1.9.7 on 2016-10-16 03:22
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='activation',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('code', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='groups',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.TextField()),
                ('ffId', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='roles',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='userInfo',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('first_name', models.TextField(null=True)),
                ('last_name', models.TextField(null=True)),
                ('photo', models.TextField(null=True)),
                ('groupId', models.TextField(null=True)),
            ],
        ),
        migrations.CreateModel(
            name='users',
            fields=[
                ('email', models.TextField(primary_key=True, serialize=False)),
                ('password', models.TextField()),
                ('status', models.TextField()),
                ('rol', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='login.roles')),
            ],
        ),
        migrations.AddField(
            model_name='userinfo',
            name='uid',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='login.users'),
        ),
        migrations.AddField(
            model_name='activation',
            name='uid',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='login.users'),
        ),
    ]
