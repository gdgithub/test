from django.shortcuts import render
from django.http import HttpResponse
from django.core import serializers
from django.core.mail import send_mail
from src.login.models import *
import json
from django.http import HttpResponseRedirect
from django.core.urlresolvers import reverse
# Create your views here.


def login(request):
    return render(request, 'login.html', {})


def usercredentials(request):
    if request.method == "POST":
        email = request.POST['email']

        uid_exists = users.objects.values().filter(email=email)
        exists = False

        if uid_exists:
            exists = True
        elif not uid_exists:
            exists = False

        return HttpResponse(json.dumps({
            "exists": exists,
            "data": list(uid_exists)
        }))


def userinfo(request):
    if request.method == "POST":
        email = request.POST['email']

        data = userInfo.objects.prefetch_related("uid").filter(uid=email)
        userinfo = []
        userinfo.append({
            "email": data[0].uid.email,
            "password": data[0].uid.password,
            "rol": data[0].uid.rol.name,
            "status": data[0].uid.status,
            "first_name": data[0].first_name,
            "last_name": data[0].last_name,
            "group_id": data[0].groupId,
        })

        exists = False

        if data:
            exists = True
        elif not data:
            exists = False

        return HttpResponse(json.dumps({
            "exists": exists,
            "data": userinfo
        }))


def getUsers(request):
    if request.method == "POST":
        status = request.POST['status']

        if status == "all":
            data = userInfo.objects.prefetch_related("uid")
        else:
            data = userInfo.objects.prefetch_related(
                "uid").filter(status=status)

        userinfo = []
        for i in range(len(data)):
            userinfo.append({
                "email": data[i].uid.email,
                "password": data[i].uid.password,
                "rol": data[i].uid.rol.name,
                "status": data[i].uid.status,
                "first_name": data[i].first_name,
                "last_name": data[i].last_name,
                "group_id": data[i].groupId,
            })

        exists = False

        if data:
            exists = True
        elif not data:
            exists = False

        return HttpResponse(json.dumps({
            "exists": exists,
            "data": userinfo
        }))


def getuserwithname(request):
    if request.method == "POST":
        name = request.POST['name']
        status = request.POST['status']

        if status == "all":
            data = userInfo.objects.prefetch_related("uid").filter(
                first_name__icontains=name)
        else:
            data = userInfo.objects.prefetch_related(
                "uid").filter(
                first_name__icontains=name,
                status=status)

        userinfo = []
        for i in range(len(data)):
            userinfo.append({
                "email": data[i].uid.email,
                "password": data[i].uid.password,
                "rol": data[i].uid.rol.name,
                "status": data[i].uid.status,
                "first_name": data[i].first_name,
                "last_name": data[i].last_name,
                "group_id": data[i].groupId,
            })

        exists = False

        if data:
            exists = True
        elif not data:
            exists = False

        return HttpResponse(json.dumps({
            "exists": exists,
            "data": userinfo
        }))




def saveuser(request):
    if request.method == "POST":
        email = request.POST['email']
        pwd = request.POST['pwd']
        name = request.POST['name']
        nickname = request.POST['nickname']
        rol = request.POST['rol']
        status = request.POST['status']
        valcode = request.POST['valcode']

        uid_exists = users.objects.filter(email=email)
        success = False
        sent = False

        if uid_exists:
            uid_exists = True
        elif not uid_exists:
            uid_exists = False
            rol = roles.objects.get(id=rol)

            users.objects.create(
                email=email,
                password=pwd,
                rol=rol,
                status=status)

            uid = users.objects.get(email=email)

            userInfo.objects.create(
                uid=uid,
                first_name=name,
                last_name=nickname,
                groupId="0"
            )

            activation.objects.create(
                uid=uid,
                code=valcode
            )

            success = users.objects.filter(email=email)

            if success:
                success = True

                link = "https://g-052.herokuapp.com/activation?uc=" + valcode
                body = "Para activar su cuenta en MyOrders haga click en el enlace siguiente:\n{0}.\n\nEn caso de ser un error, obvie este mensaje.".format(
                    link)

                """
                sent = sendMessage("starlin.gil.cruz@gmail.com",
                                   "macbookpro13", "smtp.gmail.com:587",
                                   "starlin.gil.cruz@gmail.com", link)
                """

                sent = send_mail('Activacion de cuenta MyOrders', body, 'starlin.gil.cruz@gmail.com', [
                    email])

            elif not success:
                success = False

    return HttpResponse(json.dumps(
        {"success": success,
         "exists": uid_exists,
         "msg_sent": sent}))


def sendMessage(user, pwd, server, to, message):
    try:
        srv = smtplib.SMTP(server)
        srv.ehlo()
        srv.starttls()
        srv.login(user, pwd)
    except:
        return False

    try:
        msg = MIMEMultipart('mixed')
        msg['from'] = user
        msg['to'] = to
        msg['subject'] = 'Activacion de cuenta MyOrders.'
        msg.attach(MIMEText(message, 'plain'))

        srv.sendmail(user, to, msg.as_string())
        return True

    except:
        return False


def uActivation(request):
    if request.method == "GET":
        uc = request.GET["uc"]

        uid = activation.objects.filter(code=uc)

        if uid:
            uid[0].uid_id

            users.objects.filter(email=uid[0].uid_id).update(
                status="active"
            )
            pass

    return HttpResponseRedirect(reverse('login'))
