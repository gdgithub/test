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
import uadmin.views
import directories.views


urlpatterns = [
    url(r'^$', uadmin.views.uadmin, name='uadmin'),
    url(r'^notifications/$', uadmin.views.notifications, name='notifications'),
    url(r'contact/$', uadmin.views.contact, name='contact'),
    url(r'user/$', uadmin.views.user, name='user'),
    url(r'group/$', uadmin.views.group, name='group'),
    url(r'save/create/$', directories.views.create, name='create'),
    url(r'saveUser/$', uadmin.views.saveUser, name='saveUser'),
    url(r'directories/delete/$', directories.views.delete, name='delete'),
    url(r'directories/getCategories/$',
        directories.views.getCategories, name='getCategories')

]