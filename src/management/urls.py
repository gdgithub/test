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
import src.management.views
import src.directories.views
import src.home.views
import src.uadmin.views

urlpatterns = [
    url(r'^$', src.management.views.management, name='management'),
    url(r'^orders/$', src.management.views.orders_subpage, name='orders_subpage'),
    url(r'^group/$',
        src.management.views.group_subpage, name='group_subpage'),
    url(r'^suggest/$',
        src.management.views.suggest_subpage, name='suggest_subpage'),
    url(r'^myinfo/$',
        src.management.views.myinfo_subpage, name='myinfo_subpage'),
    url(r'reorder/$',
        src.management.views.reorder, name='reorder'),
    url(r'cancelOrder/$',
        src.management.views.cancelOrder, name='cancelOrder'),
    url(r'getUserOrders/$',
        src.management.views.getUserOrders, name='getUserOrders'),
    url(r'directories/getContactsName/$',
        src.directories.views.getContactsName, name='getContactsName'),
    url(r'directories/findContact/$',
        src.directories.views.findContact, name='findContact'),
    url(r'directories/getContactBranches/$',
        src.directories.views.getContactBranches, name='getContactBranches'),
    url(r'directories/getBranchMenu/$',
        src.directories.views.getBranchMenu, name='getBranchMenu'),
    url(r'directories/createOrder/$',
        src.directories.views.createOrder, name='createOrder'),
    url(r'directories/getCategories/$',
        src.directories.views.getCategories, name='getCategories'),
    url(r'suggest_contact/$', src.directories.views.create, name='create'),
    url(r'userInfo/$',
        src.home.views.getUserInfo, name='getUserInfo'),
    url(r'userCredentials/$',
        src.home.views.userCredentials, name='userCredentials'),
    url(r'updateUserInfo/$',
        src.uadmin.views.updateUserInfo, name='updateUserInfo'),
    url(r'changepwd/$',
        src.uadmin.views.change_password, name='change_password'),
    url(r'group_members/$',
        src.uadmin.views.getMembers, name='getMembers'),
    url(r'contact/$', src.uadmin.views.contact, name='contact'),
    url(r'getContactWithId/$', src.directories.views.getContactWithId,
        name='getContactWithId'),
    url(r'deleteContact/$', src.directories.views.delete,
        name='delete'),
    url(r'getGroups/$',
        src.uadmin.views.getGroups, name='getGroups'),
    url(r'delGroup/$',
        src.uadmin.views.delGroup, name='delGroup'),
    url(r'delUserGroup/$',
        src.uadmin.views.delUserGroup, name='delUserGroup'),
    url(r'createGroup/$',
        src.uadmin.views.createGroup, name='createGroup'),

]
