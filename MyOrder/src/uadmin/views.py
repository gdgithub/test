from django.shortcuts import render
from django.http import HttpResponse
from directories.models import *
from home.models import *
from django.template import loader, RequestContext
import json

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


def contact(request):
    data = contacts.objects.select_related()
    rows = [x for x in data]

    dic = {
        "columns": [
            "Nombre",
            "Categoria",
            "Rating"],
        "data": rows
    }

    return render(request, 'components/contacts.html', dic)


def saveUser(request):

    if request.method == "POST":
        nombre = request.POST['nombre']
        apellido = request.POST['apellido']
        direccion = request.POST['direccion']
        correo = request.POST['correo']
        contrasena = request.POST['contrasena']
        rol = request.POST['rol']

        rolId = roles.objects.get(name=rol)

        users.objects.create(
            email=correo,
            password=contrasena,
            rol=rolId,
            status='available'
        )

        uid = users.objects.get(email=correo)

        userInfo.objects.create(
            uid=uid,
            first_name=nombre,
            last_name=apellido,
            address=direccion,
            groupId='0'
        )

    return HttpResponse("saved")


def updateUserInfo(request):

    if request.method == "POST":
        nombre = request.POST['nombre']
        apellido = request.POST['apellido']
        direccion = request.POST['direccion']
        correo = request.POST['correo']

        userInfo.objects.filter(uid=correo).update(
            first_name=nombre,
            last_name=apellido,
            address=direccion
        )

    return HttpResponse("saved")


def change_password(request):
    if request.method == "POST":
        correo = request.POST['correo']
        acontrasena = request.POST['acontrasena']
        ncontrasena = request.POST['ncontrasena']

        data = users.objects.filter(email=correo, password=acontrasena).update(
            password=ncontrasena
        )

        return HttpResponse(data)


def getMembers(request):
    if request.method == "POST":
        uid = request.POST['userId']

        groupId = userInfo.objects.filter(uid=uid)

        members = list(userInfo.objects.values().filter(
            groupId=groupId[0].groupId))

        return HttpResponse(json.dumps(members))


def user(request):
    data = userInfo.objects.select_related()
    rows = [x for x in data]

    dic = {
        "columns": [
            "Nombre",
            "Categoria",
            "Rating"],
        "data": rows
    }

    return render(request, 'components/users.html', dic)


def group(request):
    data = userInfo.objects.select_related()
    rows = [x for x in data]

    dic = {
        "columns": [
            "Nombre",
            "Categoria",
            "Rating"],
        "data": rows
    }

    return render(request, 'components/groups.html', dic)


def getGroups(request):
    if request.method == "POST":
        userId = request.POST['userId']
        rol = request.POST['userRol']

        if int(rol) == 1:
            # all groups
            group = []
            # group = list(groups.objects.values().all())
            groupp = groups.objects.values().all()

            for i in range(len(groupp)):
                usr = list(userInfo.objects.values().filter(
                    groupId=groupp[i]['id']))

                groupp[i]['user'] = usr

                ffu = list(userInfo.objects.values().filter(
                    uid=groupp[i]['ffId']))

                groupp[i]['ff_info'] = ffu

                group.append(groupp[i])

        elif int(rol) == 2:
            # ff user groups
            group = list(groups.objects.filter(ffId=userId))
        else:
            pass

        return HttpResponse(json.dumps(group))


def delGroup(request):
    if request.method == "POST":
        gid = request.POST['gid']

        groups.objects.filter(id=gid).delete()
    return HttpResponse("ok")


def delUserGroup(request):
    if request.method == "POST":
        userId = request.POST['userId']

        userInfo.objects.filter(uid_id=userId).update(
            groupId=0
        )
    return HttpResponse("ok")


def createGroup(request):
    if request.method == "POST":
        gname = request.POST['gname']
        gff = request.POST['gff']
        # gmembers = request.POST['gmembers']

        groups.objects.create(name=gname, ffId=gff)

        # setting members
    return HttpResponse("ok")


def notifications(request):
    return render(request, 'child.html', {})
