from django.shortcuts import render
from django.http import HttpResponse
from src.administration.models import *
from django.core import serializers
import json
# Create your views here.


def administration(request):
    return render(request, 'main.html', {})


def contacts_page(request):
    return render(request, 'components/contacts.html', {})


def create_contact_page(request):
    return render(request, 'components/create_contact.html', {})


def getcontacts(request):
    if request.method == "POST":
        status = request.POST["status"]

        if not status == "non-status":
            data = contacts.objects.prefetch_related("cid").filter(
                status=status)
        elif status == "non-status":
            data = contacts.objects.prefetch_related("cid")

        contact = []
        for i in range(len(data)):
            contact.append({
                "id": data[i].id,
                "rnc": data[i].rnc,
                "name": data[i].name,
                "category": data[i].cid.description,
                "phone": data[i].phone,
                "address": data[i].address,
                "rate": data[i].rate,
                "status": data[i].status
            })

    return HttpResponse(json.dumps({
        "data": contact
    }))


def getcontactwithname(request):
    if request.method == "POST":
        name = request.POST["name"]
        status = request.POST["status"]

        if not status == "non-status":
            data = contacts.objects.prefetch_related("cid").filter(
                name__icontains=name, status=status)
        elif status == "non-status":
            data = contacts.objects.prefetch_related("cid").filter(
                name__icontains=name)

        contact = []
        for i in range(len(data)):
            contact.append({
                "id": data[i].id,
                "rnc": data[i].rnc,
                "name": data[i].name,
                "category": data[i].cid.description,
                "phone": data[i].phone,
                "address": data[i].address,
                "rate": data[i].rate,
                "status": data[i].status
            })

    return HttpResponse(json.dumps({
        "data": contact
    }))


def getcontactwithfilter(request):
    if request.method == "POST":
        field = request.POST["field"]
        orderType = request.POST["orderType"]
        status = request.POST["status"]

        if not status == "non-status":
            if orderType == "asc":
                data = contacts.objects.prefetch_related("cid").filter(
                    status=status).order_by(field)
            elif orderType == "desc":
                data = contacts.objects.prefetch_related(
                    "cid").filter(status=status).order_by(field).reverse()
        elif status == "non-status":
            if orderType == "asc":
                data = contacts.objects.prefetch_related("cid").order_by(field)
            elif orderType == "desc":
                data = contacts.objects.prefetch_related(
                    "cid").order_by(field).reverse()

        contact = []
        for i in range(len(data)):
            contact.append({
                "id": data[i].id,
                "rnc": data[i].rnc,
                "name": data[i].name,
                "category": data[i].cid.description,
                "phone": data[i].phone,
                "address": data[i].address,
                "rate": data[i].rate,
                "status": data[i].status
            })

    return HttpResponse(json.dumps({
        "data": contact
    }))


def getcontactswithid(request):
    if request.method == "POST":
        id = request.POST["id"].split('|')
        data = []

        for i in range(len(id)):
            row = contacts.objects.prefetch_related("cid").filter(
                id=id[i])
            data.append(row)

        contact = []
        for i in range(len(data)):
            contact.append({
                "id": data[i][0].id,
                "rnc": data[i][0].rnc,
                "name": data[i][0].name,
                "category": data[i][0].cid.description,
                "phone": data[i][0].phone,
                "address": data[i][0].address,
                "rate": data[i][0].rate,
                "status": data[i][0].status
            })

    return HttpResponse(json.dumps({
        "data": contact
    }))


def getcontactscategories(request):
    if request.method == "POST":

        data = list(category.objects.values().all())

    return HttpResponse(json.dumps({
        "data": data
    }))


def createcontact(request):
    if request.method == "POST":
        rnc = request.POST["rnc"]
        categ = request.POST["category"]
        name = request.POST["name"]
        phone = request.POST["phone"]
        address = request.POST["address"]
        description = request.POST["description"]
        status = request.POST["status"]

        exists = contacts.objects.filter(rnc=rnc)
        success = True

        if not exists:
            success = True
            cid = category.objects.get(description=categ)
            contacts.objects.create(
                rnc=rnc,
                cid=cid,
                name=name,
                phone=phone,
                address=address,
                rate=0,
                description=description,
                status=status)

            if status == "inactive":
                master = contacts.objects.filter(rnc=rnc)
                notifications.objects.create(
                    type="contact-suggestion",
                    master_id=master[0].id,
                    status="no-checked"
                )
        elif exists:
            success = False

    return HttpResponse(json.dumps({
        "success": success
    }))


def updatecontact(request):
    if request.method == "POST":
        rnc = request.POST["rnc"]
        categ = request.POST["category"]
        name = request.POST["name"]
        phone = request.POST["phone"]
        address = request.POST["address"]
        description = request.POST["description"]
        status = request.POST["status"]

        exists = contacts.objects.get(rnc=rnc)
        success = True

        if exists:
            success = True
            cid = category.objects.get(description=categ)
            contacts.objects.filter(rnc=rnc).update(
                cid=cid,
                name=name,
                phone=phone,
                address=address,
                rate=0,
                description=description,
                status=status)

            if status == "inactive":
                master = contacts.objects.filter(rnc=rnc)
                notifications.objects.create(
                    type="contact-suggestion",
                    master_id=master[0].id,
                    status="no-checked"
                )
        elif not exists:
            success = False

    return HttpResponse(json.dumps({
        "success": success
    }))


def deletecontact(request):
    if request.method == "POST":
        id = request.POST["id"]

        result = contacts.objects.filter(id=id).delete()
        if result:
            result = True
        elif not result:
            result = False

    return HttpResponse(json.dumps({
        "success": result
    }))
