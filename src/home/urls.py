"""src URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.9/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url
from . import views
import src.directories.views


urlpatterns = [
    url(r'^$', views.home, name='home'),
    url(r'authenticate/login/$', views.login, name='loginold'),
    url(r'authenticate/signup/$', views.signup, name='signup'),
    url(r'authenticate/userCredentials/$',
        views.userCredentials, name='userCredentials'),
    url(r'directories/getAll/$', src.directories.views.getAll, name='getAll'),
    url(r'directories/getContactBranches/$',
        src.directories.views.getContactBranches, name='getContactBranches'),
    url(r'directories/getBranchMenu/$',
        src.directories.views.getBranchMenu, name='getBranchMenu'),
    url(r'directories/createOrder/$',
        src.directories.views.createOrder, name='createOrder'),
    url(r'directories/getContactsName/$',
        src.directories.views.getContactsName, name='getContactsName'),
    url(r'directories/getCategories/$',
        src.directories.views.getCategories, name='getCategories'),
    url(r'directories/findContact/$',
        src.directories.views.findContact, name='findContact'),
    url(r'directories/getContactsOrdered/$',
        src.directories.views.getContactsOrdered, name='getContactsOrdered')
]
