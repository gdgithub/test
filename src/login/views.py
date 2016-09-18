from django.shortcuts import render
from django.http import HttpResponse
from django.core import serializers
from src.login.models import *
import json
import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
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

                sent = sendMessage("starlin.gil.cruz@gmail.com",
                                   "macbookpro13", "smtp.gmail.com:587",
                                   "starlin.gil.cruz@gmail.com", link)

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

    return HttpResponse("")
