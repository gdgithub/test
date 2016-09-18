from django.shortcuts import render
from django.http import HttpResponse
from src.directories.models import *
from src.home.models import *
from django.core import serializers
import json
# Create your views here.


def management(request):
    return render(request, 'management.html', {})


def orders_subpage(request):
    return render(request, 'components/orders.html', {})


def group_subpage(request):
    return render(request, 'components/group.html', {})


def contacts_subpage(request):
    data = contacts.objects.select_related()
    rows = [x for x in data]

    dic = {
        "columns": [
            "Nombre",
            "Telefono",
            "Direccion"],
        "data": rows
    }

    return render(request, 'components/contact.html', dic)


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


def contactList(request):

    data = list(contacts.objects.values().all().order_by('name'))

    return HttpResponse(json.dumps(data))


def findContact(request):

    if request.method == "POST":
        name = request.POST['name']

    data = list(contacts.objects.values().filter(
        name__icontains=name))

    """
    data = list(contacts.objects.values().filter(
        name__icontains=name, status="enable"))
    """

    return HttpResponse(json.dumps(data))


def getUserOrders(request):
    if request.method == "POST":
        uid = request.POST['userId']

        if uid == "all":  # admin
            data = serializers.serialize(
                "json", orders.objects.all().order_by("id"))
        else:
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


def createGroup(request):
    if request.method == "POST":
        gname = request.POST['gname']
        gff = request.POST['gff']
        gmembers = request.POST['gmembers']

        gmembers = gmembers.split('|')

        # creating group
        groups.objects.create(name=gname, ffId=gff)

        # getting group id
        gid = groups.objects.values().filter(name=gname, ffId=gff)

        # setting group members
        for i in range(len(gmembers)):
            # taking each uid
            userInfo.objects.filter(uid_id=gmembers[i]).update(
                groupId=gid[0]['id']
            )

        # setting members
    return HttpResponse("json.dumps(gid)")


def updateGroup(request):
    if request.method == "POST":
        gid = request.POST['gid']
        gname = request.POST['gname']
        gff = request.POST['gff']
        gmembers = request.POST['gmembers']

        gmembers = gmembers.split('|')

        # updating group meta
        groups.objects.filter(id=gid).update(
            name=gname,
            ffId=gff
        )

        # setting group members
        for i in range(len(gmembers)):
            # taking each uid
            userInfo.objects.filter(uid_id=gmembers[i]).update(
                groupId=gid
            )

        # setting members
    return HttpResponse("json.dumps(gid)")


def getGroups(request):
    if request.method == "POST":
        userId = request.POST['userId']
        rol = request.POST['userRol']

        group = []

        if int(rol) == 1:
            # all groups
            groupp = groups.objects.values().all()
        elif int(rol) == 2:
            # ff user groups
            groupp = groups.objects.values().filter(ffId=userId)

        for i in range(len(groupp)):
            usr = list(userInfo.objects.values().filter(
                groupId=groupp[i]['id']))

            groupp[i]['user'] = usr

            ffu = list(userInfo.objects.values().filter(
                uid=groupp[i]['ffId']))

            groupp[i]['ff_info'] = ffu

            group.append(groupp[i])

        else:
            pass

        return HttpResponse(json.dumps(group))


# pedidos del usuario ff y sus miembros
def getGroupMemOrders(request):
    if request.method == "POST":
        gid = request.POST['groupId']

        members = list(userInfo.objects.values().filter(groupId=gid))
        ffid = list(groups.objects.values().filter(id=gid))
        order = []

        order = order + list(orders.objects.filter(
            userId=ffid[0]["ffId"]).order_by("id"))

        for i in range(len(members)):
            order = order + list(orders.objects.filter(
                userId=members[i]["uid_id"]).order_by("id"))

        order = serializers.serialize("json", order)

        return HttpResponse(order)


def getGroupInfo(request):
    if request.method == "POST":
        gid = request.POST['groupId']

        group = list(groups.objects.values().filter(id=gid))
        members = list(userInfo.objects.values().filter(groupId=gid))

        group = {"group": group, "members": members}

        return HttpResponse(json.dumps(group))
