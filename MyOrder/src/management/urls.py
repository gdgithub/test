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
import management.views
import directories.views
import home.views
import uadmin.views

urlpatterns = [
    url(r'^$', management.views.management, name='management'),
    url(r'^orders/$', management.views.orders_subpage, name='orders_subpage'),
    url(r'^group/$',
        management.views.group_subpage, name='group_subpage'),
    url(r'^suggest/$',
        management.views.suggest_subpage, name='suggest_subpage'),
    url(r'^myinfo/$',
        management.views.myinfo_subpage, name='myinfo_subpage'),
    url(r'reorder/$',
        management.views.reorder, name='reorder'),
    url(r'cancelOrder/$',
        management.views.cancelOrder, name='cancelOrder'),
    url(r'getUserOrders/$',
        management.views.getUserOrders, name='getUserOrders'),
    url(r'directories/getContactsName/$',
        directories.views.getContactsName, name='getContactsName'),
    url(r'directories/findContact/$',
        directories.views.findContact, name='findContact'),
    url(r'directories/getContactBranches/$',
        directories.views.getContactBranches, name='getContactBranches'),
    url(r'directories/getBranchMenu/$',
        directories.views.getBranchMenu, name='getBranchMenu'),
    url(r'directories/createOrder/$',
        directories.views.createOrder, name='createOrder'),
    url(r'directories/getCategories/$',
        directories.views.getCategories, name='getCategories'),
    url(r'suggest_contact/$', directories.views.create, name='create'),
    url(r'userInfo/$',
        home.views.getUserInfo, name='getUserInfo'),
    url(r'userCredentials/$',
        home.views.userCredentials, name='userCredentials'),
    url(r'updateUserInfo/$',
        uadmin.views.updateUserInfo, name='updateUserInfo'),
    url(r'changepwd/$',
        uadmin.views.change_password, name='change_password'),
    url(r'group_members/$',
        uadmin.views.getMembers, name='getMembers'),
    url(r'contact/$', uadmin.views.contact, name='contact'),
    url(r'getContactWithId/$', directories.views.getContactWithId,
        name='getContactWithId'),
    url(r'deleteContact/$', directories.views.delete,
        name='delete'),
    url(r'getGroups/$',
        uadmin.views.getGroups, name='getGroups'),
    url(r'delGroup/$',
        uadmin.views.delGroup, name='delGroup'),
    url(r'delUserGroup/$',
        uadmin.views.delUserGroup, name='delUserGroup'),
    url(r'createGroup/$',
        uadmin.views.createGroup, name='createGroup'),

]
