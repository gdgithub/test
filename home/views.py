from django.shortcuts import render
from django.http import HttpResponse
from home.models import *
from directories.models import *
from django.template import loader, RequestContext
import json
import smtplib

# Create your views here.


def home(request):

    return render(request, 'home/home.html')


def login(request):

    if request.method == "POST":
        email = request.POST["email"]
        pwd = request.POST["password"]

        auth = users.objects.filter(email=email, password=pwd)

        if auth:
            return HttpResponse(json.dumps({
                'success': "User authenticate."
            }), content_type='application/json')
        else:
            return HttpResponse(json.dumps({
                'fail': "User do not exists."
            }), content_type='application/json')


def signup(request):

    if request.method == "POST":
        email = request.POST["email"]
        pwd = request.POST["password"]

        exists = users.objects.filter(email=email)

        if exists:  # user exists
            return HttpResponse(json.dumps({
                'exists': "User exists."
            }), content_type='application/json')
        else:  # user do not exists
            users.objects.create(
                email=email,
                password=pwd,
                rol="dev",
                status="pending")  # save user

            uid = users.objects.get(email=email)

            userInfo.objects.create(uid=uid)

            sent = sendMessage("starlin.gil.cruz@gmail.com", "ipad3ios6",
                               "smtp.gmail.com:587", email, "hihihihi")

            if sent:
                return HttpResponse(json.dumps({
                    'success': "Email validation sent."
                }), content_type='application/json')
            else:
                return HttpResponse(json.dumps({
                    'fail': """Ocurrio un error al momento de enviar el correo.
                     por valor verifique e intente nuevamente."""
                }), content_type='application/json')


def sendMessage(user, pwd, server, to, message):
    try:
        srv = smtplib.SMTP(server)
        srv.ehlo()
        srv.starttls()
        srv.login(user, pwd)
    except:
        return False

    try:
        srv.sendmail(user, to, message)
    except:
        return False
