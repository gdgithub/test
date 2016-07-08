from django.shortcuts import render
from django.http import HttpResponse
from directories.models import *
from django.template import loader, RequestContext

# Create your views here.


def uadmin(request):
    data = contacts.objects.select_related()
    rows = [x for x in data]

    dic = {
        "columns": [
            "Nombre",
            "Telefono",
            "Direccion"],
        "data": rows
    }

    return render(request, 'uadmin/admin.html', dic)

"""
def create(request):

    if request.method == "POST":
        name = request.POST['name']
        address = request.POST['address']

        contacts.objects.create(
            name=name,
            phone="00",
            address=address,
            category_id=0
        )

    return HttpResponse('Informacion almacenada exitosamente.')
"""
