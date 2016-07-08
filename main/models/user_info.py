from django.db import models

class userInfo(models.Model):
    id = models.AutoField(primary_key=True)
    first_name = models.TextField(max_length=20)
    last_name = models.TextField(max_length=20)
    email = models.EmailField()
    address = models.TextField(max_length=300)
