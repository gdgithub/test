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
    url(r'^menu_categories/$', src.administration.views.menu_categories,
        name='menu_categories'),
    url(r'^menu_viewer/$', src.administration.views.menu_viewer,
        name='menu_viewer'),
    url(r'^orders/$', src.administration.views.orders,
        name='orders'),
    url(r'^groups/$', src.administration.views.groups,
        name='groups'),
    url(r'^create_group/$', src.administration.views.create_group,
        name='create_group'),
    url(r'^users/$', src.administration.views.users_page,
        name='users'),
    url(r'^create_user/$', src.administration.views.create_user,
        name='create_user'),
    url(r'^notifications/$', src.administration.views.notifications,
        name='notifications'),

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
    url(r'createcontactcategory/$', src.administration.views.
        createcontactcategory, name='createcontactcategory'),
    url(r'deletecontact_category/$', src.administration.views.
        deletecontact_category, name='deletecontact_category'),
    url(r'updatecontact_category/$', src.administration.views.
        updatecontact_category, name='updatecontact_category'),

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
    url(r'createmenucategory/$', src.administration.views.
        createmenucategory, name='createmenucategory'),
    url(r'updatemenucategory/$', src.administration.views.
        updatemenucategory, name='updatemenucategory'),
    url(r'getmenucategories/$', src.administration.views.
        getmenucategories, name='getmenucategories'),
    url(r'deletemenu_category/$', src.administration.views.
        deletemenu_category, name='deletemenu_category'),
    url(r'deletemenu/$', src.administration.views.
        deletemenu, name='deletemenu'),

    url(r'createorder/$', src.administration.views.
        createorder, name='createorder'),
    url(r'getorders/$', src.administration.views.
        getorders, name='getorders'),
    url(r'getorderwithid/$', src.administration.views.
        getorderwithid, name='getorderwithid'),
    url(r'getorderwithparamns/$', src.administration.views.
        getorderwithparamns, name='getorderwithparamns'),
    url(r'getorderwithfilter/$', src.administration.views.
        getorderwithfilter, name='getorderwithfilter'),
    url(r'cancelOrderWithId/$', src.administration.views.
        cancelOrderWithId, name='cancelOrderWithId'),
    url(r'setorderdelivered/$', src.administration.views.
        setorderdelivered, name='setorderdelivered'),

    url(r'usercredentials/$', src.login.views.
        usercredentials, name='usercredentials'),
    url(r'userinfo/$', src.login.views.
        userinfo, name='userinfo'),
    url(r'getUsers/$', src.login.views.
        getUsers, name='getUsers'),
    url(r'getuserwithname/$', src.login.views.
        getuserwithname, name='getuserwithname'),
    url(r'saveuser/$', src.login.views.
        saveuser, name='saveuser'),
    url(r'updateuser/$', src.login.views.
        updateuser, name='updateuser'),
    url(r'deleteuser/$', src.login.views.
        deleteuser, name='deleteuser'),



    url(r'getgroups/$', src.administration.views.
        getgroups, name='getgroups'),
    url(r'getgroupwithid/$', src.administration.views.
        getgroupwithid, name='getgroupwithid'),
    url(r'getgroupwithname/$', src.administration.views.
        getgroupwithname, name='getgroupwithname'),
    url(r'getfirefighters/$', src.administration.views.
        getfirefighters, name='getfirefighters'),
    url(r'getdevusers/$', src.administration.views.
        getdevusers, name='getdevusers'),
    url(r'getgroupmembers/$', src.administration.views.
        getgroupmembers, name='getgroupmembers'),
    url(r'savegroup/$', src.administration.views.
        savegroup, name='savegroup'),
    url(r'updategroup/$', src.administration.views.
        updategroup, name='updategroup'),
    url(r'deletegroups/$', src.administration.views.
        deletegroups, name='deletegroups'),



]
