from django.shortcuts import render
from django.http import HttpResponse
from directories.models import *
from django.core import serializers
import json
# Create your views here.


def management(request):
    return render(request, 'management.html', {})


def orders_subpage(request):
    return render(request, 'components/orders.html', {})


def group_subpage(request):
    return render(request, 'components/group.html', {})


def suggest_subpage(request):
    data = contacts.objects.select_related()
    rows = [x for x in data]

    dic = {
        "columns": [
            "Nombre",
            "Telefono",
            "Direccion"],
        "data": rows
    }

    return render(request, 'components/suggest.html', dic)
    # return render(request, 'components/suggest.html', {})


def myinfo_subpage(request):
    return render(request, 'components/myinfo.html', {})


def getUserOrders(request):
    if request.method == "POST":
        uid = request.POST['userId']

        data = serializers.serialize(
            "json", orders.objects.filter(userId=uid).order_by("id"))

    return HttpResponse(data)


def reorder(request):
    if request.method == "POST":
        orderId = request.POST['orderId']
        userId = request.POST['userId']

        data = orders.objects.filter(id=orderId)

        orders.objects.create(
            userId=userId,
            branchId=data[0].branchId,
            description=data[0].description,
            status='active'
        )

    return HttpResponse(json.dumps({'data': 'success'}))


def cancelOrder(request):
    if request.method == "POST":
        orderId = request.POST['orderId']

        orders.objects.filter(id=orderId).update(
            status='banned'
        )

    return HttpResponse(json.dumps({'data': 'success'}))
