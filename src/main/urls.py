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
from django.conf.urls import include, url
from django.contrib import admin
import src.login.views
import view

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^$', view.main, name='main'),
    url(r'^activation/$', src.login.views.uActivation, name='uActivation'),
    url(r'^login/', include('src.login.urls')),
    url(r'^index/', include('src.home.urls')),
    url(r'^uadmin/', include('src.uadmin.urls')),
    url(r'^management/', include('src.management.urls'))
]
