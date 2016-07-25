from models import *

category.objects.create(
    description='Comida rapida'
)
category.objects.create(
    description='Otro'
)

c = category.objects.get(description='Otro')

contacts.objects.create(
    rnc='1234',
    name='McDonals',
    image='/ruta',
    description='Buena comida',
    categoryId=c,
    rating=4
)
contacts.objects.create(
    rnc='1345',
    name='Colmado',
    image='/ruta1',
    description='Barata',
    categoryId=2,
    rating=2
)

branch.objects.create(
    contactId=1,
    phone='8092635569',
    address='C/Santiago'
)

ratings.objects.create(
    contactId=1,
    uid=1010,
    value='4'
)
ratings.objects.create(
    contactId=1,
    uid=2030,
    value='5'
)
ratings.objects.create(
    contactId=2,
    uid=1010,
    value='2'
)

comment.objects.create(
    contactId=1,
    uid=1010,
    description='Bien chino'
)

