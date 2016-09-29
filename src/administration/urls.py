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
import src.administration.views
import src.login.views

urlpatterns = [
    url(r'^$', src.administration.views.administration, name='administration'),
    url(r'^contacts/$', src.administration.views.contacts_page, name='contacts_page'),
    url(r'^create_contact/$', src.administration.views.create_contact_page,
        name='create_contact_page'),
    url(r'^contact_categories/$', src.administration.views.contact_categories,
        name='contact_categories'),
    url(r'^menu/$', src.administration.views.menu_page, name='menu_page'),
    url(r'^create_menu/$', src.administration.views.create_menu_page,
        name='create_menu_page'),
    url(r'^menu_viewer/$', src.administration.views.menu_viewer,
        name='menu_viewer'),

    url(r'getcontacts/$', src.administration.views.getcontacts,
        name='getcontacts'),
    url(r'getcontactwithname/$', src.administration.views.getcontactwithname,
        name='getcontactwithname'),
    url(r'getcontactwithfilter/$', src.administration.views.
        getcontactwithfilter, name='getcontactwithfilter'),
    url(r'getcontactswithid/$', src.administration.views.
        getcontactswithid, name='getcontactswithid'),
    url(r'getcontactscategories/$', src.administration.views.
        getcontactscategories, name='getcontactscategories'),
    url(r'deletecontact_category/$', src.administration.views.
        deletecontact_category, name='deletecontact_category'),

    url(r'createcontact/$', src.administration.views.
        createcontact, name='createcontact'),
    url(r'updatecontact/$', src.administration.views.
        updatecontact, name='updatecontact'),
    url(r'deletecontact/$', src.administration.views.
        deletecontact, name='deletecontact'),

    url(r'getmenu/$', src.administration.views.
        getmenu, name='getmenu'),
    url(r'getmenuwithid/$', src.administration.views.
        getmenuwithid, name='getmenuwithid'),
    url(r'getmenutwithname/$', src.administration.views.
        getmenutwithname, name='getmenutwithname'),
    url(r'getmenuwithfilter/$', src.administration.views.
        getmenuwithfilter, name='getmenuwithfilter'),
    url(r'savemenu/$', src.administration.views.
        savemenu, name='savemenu'),
    url(r'updatemenu/$', src.administration.views.
        updatemenu, name='updatemenu'),
    url(r'getmenucategories/$', src.administration.views.
        getmenucategories, name='getmenucategories'),
    url(r'deletemenu/$', src.administration.views.
        deletemenu, name='deletemenu'),

    url(r'usercredentials/$', src.login.views.
        usercredentials, name='usercredentials'),
    url(r'userinfo/$', src.login.views.
        userinfo, name='userinfo'),

]
