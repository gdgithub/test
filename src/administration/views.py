from django.shortcuts import render
from django.http import HttpResponse
from src.administration.models import *
from src.login.models import *
from django.core import serializers
import json
# Create your views here.


def administration(request):
    return render(request, 'main.html', {})


def contacts_page(request):
    return render(request, 'components/contacts.html', {})


def create_contact_page(request):
    return render(request, 'components/create_contact.html', {})


def contact_categories(request):
    return render(request, 'components/categories.html', {})


def menu_page(request):
    return render(request, 'components/menu.html', {})


def create_menu_page(request):
    return render(request, 'components/create_menu.html', {})


def menu_viewer(request):
    return render(request, 'components/menu_viewer.html', {})


def menu_categories(request):
    return render(request, 'components/menu_categories.html', {})


def orders(request):
    return render(request, 'components/orders.html', {})


def groups(request):
    return render(request, 'components/groups.html', {})


def create_group(request):
    return render(request, 'components/create_group.html', {})


def users_page(request):
    return render(request, 'components/users.html', {})


def getcontacts(request):
    if request.method == "POST":
        status = request.POST["status"]

        if not status == "non-status":
            data = contacts.objects.prefetch_related("cid").filter(
                status=status)
        elif status == "non-status":
            data = contacts.objects.prefetch_related("cid")

        contact = []
        for i in range(len(data)):
            contact.append({
                "id": data[i].id,
                "rnc": data[i].rnc,
                "name": data[i].name,
                "category": data[i].cid.description,
                "phone": data[i].phone,
                "address": data[i].address,
                "rate": data[i].rate,
                "status": data[i].status
            })

    return HttpResponse(json.dumps({
        "data": contact
    }))


def getcontactwithname(request):
    if request.method == "POST":
        name = request.POST["name"]
        status = request.POST["status"]

        if not status == "non-status":
            data = contacts.objects.prefetch_related("cid").filter(
                name__icontains=name, status=status)
        elif status == "non-status":
            data = contacts.objects.prefetch_related("cid").filter(
                name__icontains=name)

        contact = []
        for i in range(len(data)):
            contact.append({
                "id": data[i].id,
                "rnc": data[i].rnc,
                "name": data[i].name,
                "category": data[i].cid.description,
                "phone": data[i].phone,
                "address": data[i].address,
                "rate": data[i].rate,
                "status": data[i].status
            })

    return HttpResponse(json.dumps({
        "data": contact
    }))


def getcontactwithfilter(request):
    if request.method == "POST":
        field = request.POST["field"]
        orderType = request.POST["orderType"]
        status = request.POST["status"]

        if not status == "non-status":
            if orderType == "asc":
                data = contacts.objects.prefetch_related("cid").filter(
                    status=status).order_by(field)
            elif orderType == "desc":
                data = contacts.objects.prefetch_related(
                    "cid").filter(status=status).order_by(field).reverse()
        elif status == "non-status":
            if orderType == "asc":
                data = contacts.objects.prefetch_related("cid").order_by(field)
            elif orderType == "desc":
                data = contacts.objects.prefetch_related(
                    "cid").order_by(field).reverse()

        contact = []
        for i in range(len(data)):
            contact.append({
                "id": data[i].id,
                "rnc": data[i].rnc,
                "name": data[i].name,
                "category": data[i].cid.description,
                "phone": data[i].phone,
                "address": data[i].address,
                "rate": data[i].rate,
                "status": data[i].status
            })

    return HttpResponse(json.dumps({
        "data": contact
    }))


def getcontactswithid(request):
    if request.method == "POST":
        id = request.POST["id"].split('|')
        data = []

        for i in range(len(id)):
            row = contacts.objects.prefetch_related("cid").filter(
                id=id[i])
            data.append(row)

        contact = []
        for i in range(len(data)):
            contact.append({
                "id": data[i][0].id,
                "rnc": data[i][0].rnc,
                "name": data[i][0].name,
                "category": data[i][0].cid.description,
                "phone": data[i][0].phone,
                "address": data[i][0].address,
                "rate": data[i][0].rate,
                "status": data[i][0].status
            })

    return HttpResponse(json.dumps({
        "data": contact
    }))


def getcontactscategories(request):
    if request.method == "POST":

        data = list(category.objects.values().all())

    return HttpResponse(json.dumps({
        "data": data
    }))


def createcontactcategory(request):
    if request.method == "POST":
        name = request.POST["name"]

        rest = category.objects.filter(
            description=name)

        if rest:
            rest = False
        elif not rest:
            rest = category.objects.create(
                description=name)
            if rest:
                rest = True
            elif not rest:
                rest = False

    return HttpResponse(json.dumps({
        "success": rest
    }))


def deletecontact_category(request):
    if request.method == "POST":
        id = request.POST["id"]

        result = category.objects.filter(id=id).delete()
        if result:
            result = True
        elif not result:
            result = False

    return HttpResponse(json.dumps({
        "success": result
    }))


def updatecontact_category(request):
    if request.method == "POST":
        id = request.POST["id"]
        name = request.POST["name"]

        rest = category.objects.filter(
            id=id).update(
            description=name
        )

        if rest:
            rest = True
        elif not rest:
            rest = False

    return HttpResponse(json.dumps({
        "success": rest
    }))


def createcontact(request):
    if request.method == "POST":
        rnc = request.POST["rnc"]
        categ = request.POST["category"]
        name = request.POST["name"]
        phone = request.POST["phone"]
        address = request.POST["address"]
        description = request.POST["description"]
        status = request.POST["status"]

        exists = contacts.objects.filter(rnc=rnc)
        success = True

        if not exists:
            success = True
            cid = category.objects.get(description=categ)
            contacts.objects.create(
                rnc=rnc,
                cid=cid,
                name=name,
                phone=phone,
                address=address,
                rate=0,
                description=description,
                status=status)

            if status == "inactive":
                master = contacts.objects.filter(rnc=rnc)
                notifications.objects.create(
                    type="contact-suggestion",
                    master_id=master[0].id,
                    status="no-checked"
                )
        elif exists:
            success = False

    return HttpResponse(json.dumps({
        "success": success
    }))


def updatecontact(request):
    if request.method == "POST":
        rnc = request.POST["rnc"]
        categ = request.POST["category"]
        name = request.POST["name"]
        phone = request.POST["phone"]
        address = request.POST["address"]
        description = request.POST["description"]
        status = request.POST["status"]

        exists = contacts.objects.get(rnc=rnc)
        success = True

        if exists:
            success = True
            cid = category.objects.get(description=categ)
            contacts.objects.filter(rnc=rnc).update(
                cid=cid,
                name=name,
                phone=phone,
                address=address,
                rate=0,
                description=description,
                status=status)

            if status == "inactive":
                master = contacts.objects.filter(rnc=rnc)
                notifications.objects.create(
                    type="contact-suggestion",
                    master_id=master[0].id,
                    status="no-checked"
                )
        elif not exists:
            success = False

    return HttpResponse(json.dumps({
        "success": success
    }))


def deletecontact(request):
    if request.method == "POST":
        id = request.POST["id"]

        result = contacts.objects.filter(id=id).delete()
        if result:
            result = True
        elif not result:
            result = False

    return HttpResponse(json.dumps({
        "success": result
    }))


def getmenu(request):
    if request.method == "POST":

        data = menu.objects.prefetch_related("contact_id")

        menu_array = []
        for i in range(len(data)):
            menu_array.append({
                "id": data[i].id,
                "menu": data[i].name,
                "contact": data[i].contact_id.name,
                "contactId": data[i].contact_id.id
            })

    return HttpResponse(json.dumps({
        "data": menu_array
    }))


def getmenutwithname(request):
    if request.method == "POST":
        name = request.POST["name"]

        data = menu.objects.prefetch_related("contact_id").filter(
            name__icontains=name)

        menu_array = []
        for i in range(len(data)):
            menu_array.append({
                "id": data[i].id,
                "menu": data[i].name,
                "contact": data[i].contact_id.name,
                "contactId": data[i].contact_id.id
            })

    return HttpResponse(json.dumps({
        "data": menu_array
    }))


def getmenuwithfilter(request):
    if request.method == "POST":
        field = request.POST["field"]
        orderType = request.POST["orderType"]

        if orderType == "asc":
            data = menu.objects.prefetch_related("contact_id").order_by(field)
        elif orderType == "desc":
            data = menu.objects.prefetch_related(
                "contact_id").order_by(field).reverse()

        menu_array = []
        for i in range(len(data)):
            menu_array.append({
                "id": data[i].id,
                "menu": data[i].name,
                "contact": data[i].contact_id.name,
                "contactId": data[i].contact_id.id
            })

    return HttpResponse(json.dumps({
        "data": menu_array
    }))


def getmenuwithid(request):
    if request.method == "POST":
        id = request.POST["id"]
        # data = []

        data = menu.objects.prefetch_related("contact_id").filter(
            id=id)
        # data.append(row)

        ddishes = dishes.objects.prefetch_related("menuId").\
            prefetch_related("menu_category_id").filter(
            menuId=id)

        dishes_array = []
        for i in range(len(ddishes)):
            dishes_array.append({
                "id": ddishes[i].id,
                "name": ddishes[i].name,
                "description": ddishes[i].description,
                "price": ddishes[i].price,
                "menu_category_id": ddishes[i].menu_category_id.id,
                "menu_category_name": ddishes[i].menu_category_id.description
            })

        menu_array = []
        for i in range(len(data)):
            menu_array.append({
                "id": data[i].id,
                "menu": data[i].name,
                "contact": data[i].contact_id.name,
                "contactId": data[i].contact_id.id,
                "dishes": dishes_array
            })

    return HttpResponse(json.dumps({
        "data": menu_array
    }))


def savemenu(request):
    if request.method == "POST":
        title = request.POST["menu_title"]
        cid = request.POST["cid"]
        dishe = request.POST["dishes"].split("|")
        price = request.POST["price"].split("|")
        categ = request.POST["categ"].split("|")

        success = True
        if len(dishe) > 0 and \
                len(price) > 0 and \
                len(categ) > 0:
            success = True
        else:
            success = False

        if success:
            cid = contacts.objects.get(id=cid)
            success = menu.objects.create(
                contact_id=cid,
                name=title
            )
            menu_id = menu.objects.get(
                contact_id=cid,
                name=title
            )

            for i in range(len(dishe)):
                if success:
                    menu_cid = menu_category.objects.get(id=categ[i])
                    dishes.objects.create(
                        menuId=menu_id,
                        name=dishe[i],
                        description="",
                        price=price[i],
                        menu_category_id=menu_cid
                    )
                    success = True
                elif not success:
                    success = False

    return HttpResponse(json.dumps({
        "success": success
    }))


def updatemenu(request):
    if request.method == "POST":
        menu_id = request.POST["mid"]
        title = request.POST["menu_title"]
        cid = request.POST["cid"]
        dishe = request.POST["dishes"].split("|")
        price = request.POST["price"].split("|")
        categ = request.POST["categ"].split("|")

        success = True
        if len(dishe) > 0 and \
                len(price) > 0 and \
                len(categ) > 0:
            success = True
        else:
            success = False

        if success:
            cid = contacts.objects.get(id=cid)
            success = menu.objects.filter(
                id=menu_id
            ).update(
                contact_id=cid,
                name=title
            )

            dishes.objects.filter(menuId=menu_id).delete()

            menu_id = menu.objects.get(id=menu_id)

            for i in range(len(dishe)):
                if success:
                    menu_cid = menu_category.objects.get(id=categ[i])
                    dishes.objects.create(
                        menuId=menu_id,
                        name=dishe[i],
                        description="",
                        price=price[i],
                        menu_category_id=menu_cid
                    )
                    success = True
                elif not success:
                    success = False

    return HttpResponse(json.dumps({
        "success": success
    }))


def createmenucategory(request):
    if request.method == "POST":
        name = request.POST["name"]

        rest = menu_category.objects.filter(
            description=name)

        if rest:
            rest = False
        elif not rest:
            rest = menu_category.objects.create(
                description=name)
            if rest:
                rest = True
            elif not rest:
                rest = False

    return HttpResponse(json.dumps({
        "success": rest
    }))


def updatemenucategory(request):
    if request.method == "POST":
        id = request.POST["id"]
        name = request.POST["name"]

        rest = menu_category.objects.filter(
            id=id).update(
            description=name
        )

        if rest:
            rest = True
        elif not rest:
            rest = False

    return HttpResponse(json.dumps({
        "success": rest
    }))


def getmenucategories(request):
    if request.method == "POST":

        data = list(menu_category.objects.values().all())

    return HttpResponse(json.dumps({
        "data": data
    }))


def deletemenu_category(request):
    if request.method == "POST":
        id = request.POST["id"]

        result = menu_category.objects.filter(id=id).delete()
        if result:
            result = True
        elif not result:
            result = False

    return HttpResponse(json.dumps({
        "success": result
    }))


def deletemenu(request):
    if request.method == "POST":
        id = request.POST["id"]

        result = menu.objects.filter(id=id).delete()
        if result:
            result = True
        elif not result:
            result = False

    return HttpResponse(json.dumps({
        "success": result
    }))


def createorder(request):
    if request.method == "POST":
        uid = request.POST["uid"]
        cid = request.POST["cid"]
        mid = request.POST["mid"]
        status = request.POST["status"]
        total = request.POST["total"]
        amount = request.POST["amount"].split("|")
        items = request.POST["items"].split("|")
        price = request.POST["price"].split("|")
        total_item = request.POST["total_item"].split("|")
        success = True

        contact = contacts.objects.get(id=cid)
        cmenu = menu.objects.get(id=mid)

        master = orders_master.objects.create(
            user_id=uid,
            contact_id=contact,
            menu_id=cmenu,
            status=status,
            total=total
        )

        if master:
            success = True
            for i in range(len(items)):
                orders_details.objects.create(
                    order_master_id=master,
                    amount=amount[i],
                    description=items[i],
                    price=price[i],
                    total=total_item[i]
                )
        elif not master:
            success = False

    return HttpResponse(json.dumps({
        "success": success
    }))


def getorders(request):
    if request.method == "POST":

        data = orders_master.objects.prefetch_related("contact_id").\
            prefetch_related("menu_id")

        orders = []
        for i in range(len(data)):
            order_detail = orders_details.objects.filter(
                order_master_id=data[i].id)

            details = []
            for x in range(len(order_detail)):
                details.append({
                    "amount": order_detail[x].amount,
                    "item": order_detail[x].description,
                    "price": order_detail[x].price,
                    "total": order_detail[x].total
                })

            orders.append({
                "orderId": data[i].id,
                "userId": data[i].user_id,
                "contact_id": data[i].contact_id.id,
                "contact_name": data[i].contact_id.name,
                "menu_id": data[i].menu_id.id,
                "menu_name": data[i].menu_id.name,
                "status": data[i].status,
                "date": str(data[i].date),
                "total_order": data[i].total,
                "details": details
            })

    return HttpResponse(json.dumps({
        "data": orders
    }))


def getorderwithid(request):
    if request.method == "POST":
        id = request.POST["id"]

        data = orders_master.objects.prefetch_related("contact_id").\
            prefetch_related("menu_id").filter(id=id)

        orders = []
        for i in range(len(data)):
            order_detail = orders_details.objects.filter(
                order_master_id=data[i].id)

            details = []
            for x in range(len(order_detail)):
                details.append({
                    "amount": order_detail[x].amount,
                    "item": order_detail[x].description,
                    "price": order_detail[x].price,
                    "total": order_detail[x].total
                })

            orders.append({
                "orderId": data[i].id,
                "userId": data[i].user_id,
                "contact_id": data[i].contact_id.id,
                "contact_name": data[i].contact_id.name,
                "menu_id": data[i].menu_id.id,
                "menu_name": data[i].menu_id.name,
                "status": data[i].status,
                "date": str(data[i].date),
                "total_order": data[i].total,
                "details": details
            })

    return HttpResponse(json.dumps({
        "data": orders
    }))


def getorderwithparamns(request):
    if request.method == "POST":
        text = request.POST["text"]
        searchType = request.POST["searchType"]

        if searchType == "orden":
            data = orders_master.objects.prefetch_related("contact_id").\
                prefetch_related("menu_id").filter(id=text)
        elif searchType == "user":
            data = orders_master.objects.prefetch_related("contact_id").\
                prefetch_related("menu_id").filter(user_id=text)
        elif searchType == "contact":
            data = orders_master.objects.prefetch_related("contact_id").\
                prefetch_related("menu_id").filter(contact_id=text)

        orders = []
        for i in range(len(data)):
            order_detail = orders_details.objects.filter(
                order_master_id=data[i].id)

            details = []
            for x in range(len(order_detail)):
                details.append({
                    "amount": order_detail[x].amount,
                    "item": order_detail[x].description,
                    "price": order_detail[x].price,
                    "total": order_detail[x].total
                })

            orders.append({
                "orderId": data[i].id,
                "userId": data[i].user_id,
                "contact_id": data[i].contact_id.id,
                "contact_name": data[i].contact_id.name,
                "menu_id": data[i].menu_id.id,
                "menu_name": data[i].menu_id.name,
                "status": data[i].status,
                "date": str(data[i].date),
                "total_order": data[i].total,
                "details": details
            })

    return HttpResponse(json.dumps({
        "data": orders
    }))


def getorderwithfilter(request):
    if request.method == "POST":
        field = request.POST["field"]
        orderType = request.POST["orderType"]

        if orderType == "asc":
            if field == "show_delivered":
                data = orders_master.objects.prefetch_related("contact_id").\
                    prefetch_related("menu_id").filter(
                        status="Entregado").order_by("id")
            elif field == "show_canceled":
                data = orders_master.objects.prefetch_related("contact_id").\
                    prefetch_related("menu_id").filter(
                        status="Cancelado").order_by("id")
            elif field == "show_pending":
                data = orders_master.objects.prefetch_related("contact_id").\
                    prefetch_related("menu_id").filter(
                        status="Pendiente").order_by("id")
            else:
                data = orders_master.objects.prefetch_related("contact_id").\
                    prefetch_related("menu_id").order_by(field)

        elif orderType == "desc":
            if field == "show_delivered":
                data = orders_master.objects.prefetch_related("contact_id").\
                    prefetch_related("menu_id").filter(
                        status="Entregado").order_by("id").reverse()
            elif field == "show_canceled":
                data = orders_master.objects.prefetch_related("contact_id").\
                    prefetch_related("menu_id").filter(
                        status="Cancelado").order_by("id").reverse()
            elif field == "show_pending":
                data = orders_master.objects.prefetch_related("contact_id").\
                    prefetch_related("menu_id").filter(
                        status="Pendiente").order_by("id").reverse()
            else:
                data = orders_master.objects.prefetch_related("contact_id").\
                    prefetch_related("menu_id").order_by(field).reverse()

        orders = []
        for i in range(len(data)):
            order_detail = orders_details.objects.filter(
                order_master_id=data[i].id)

            details = []
            for x in range(len(order_detail)):
                details.append({
                    "amount": order_detail[x].amount,
                    "item": order_detail[x].description,
                    "price": order_detail[x].price,
                    "total": order_detail[x].total
                })

            orders.append({
                "orderId": data[i].id,
                "userId": data[i].user_id,
                "contact_id": data[i].contact_id.id,
                "contact_name": data[i].contact_id.name,
                "menu_id": data[i].menu_id.id,
                "menu_name": data[i].menu_id.name,
                "status": data[i].status,
                "date": str(data[i].date),
                "total_order": data[i].total,
                "details": details
            })

    return HttpResponse(json.dumps({
        "data": orders
    }))


def cancelOrderWithId(request):
    if request.method == "POST":
        id = request.POST["id"]

        success = orders_master.objects.filter(id=id).update(
            status="Cancelado"
        )

        if success:
            success = True
        elif not success:
            success = False

    return HttpResponse(json.dumps({
        "success": success
    }))


def setorderdelivered(request):
    if request.method == "POST":
        id = request.POST["id"]

        success = orders_master.objects.filter(id=id).update(
            status="Entregado"
        )

        if success:
            success = True
        elif not success:
            success = False

    return HttpResponse(json.dumps({
        "success": success
    }))


def getgroups(request):
    if request.method == "POST":

        data = list(groups_master.objects.values().all())

    return HttpResponse(json.dumps({
        "data": data
    }))


def getgroupwithid(request):
    if request.method == "POST":
        id = request.POST["id"]
        group = []

        data = groups_master.objects.filter(id=id)

        if data:
            members = []
            details = groups_details.objects.filter(group_master_id=id)
            for i in range(len(details)):
                members.append({
                    "userId": details[i].user_id
                })

            group.append({
                "name": data[0].name,
                "firefighter": data[0].ffid,
                "members": members
            })

    return HttpResponse(json.dumps({
        "data": group
    }))


def getgroupwithname(request):
    if request.method == "POST":
        name = request.POST["name"]

        data = groups_master.objects.filter(
            name__icontains=name)

        contact = []
        for i in range(len(data)):
            contact.append({
                "id": data[i].id,
                "name": data[i].name,
                "ffid": data[i].ffid,
            })

    return HttpResponse(json.dumps({
        "data": contact
    }))


def getfirefighters(request):
    if request.method == "POST":

        data = users.objects.filter(status="active", rol=2)

        usrs = []
        for i in range(len(data)):
            user_info = userInfo.objects.filter(uid=data[i].email)
            usrs.append({
                "uid": data[i].email,
                "first_name": user_info[0].first_name,
                "last_name": user_info[0].last_name,
                "groupId": user_info[0].groupId
            })

    return HttpResponse(json.dumps({
        "data": usrs
    }))


def getdevusers(request):
    if request.method == "POST":

        data = users.objects.filter(status="active", rol=3)

        usrs = []
        for i in range(len(data)):
            user_info = userInfo.objects.filter(uid=data[i].email)
            usrs.append({
                "uid": data[i].email,
                "first_name": user_info[0].first_name,
                "last_name": user_info[0].last_name,
                "groupId": user_info[0].groupId
            })

    return HttpResponse(json.dumps({
        "data": usrs
    }))


def getgroupmembers(request):
    if request.method == "POST":
        gid = request.POST["id"]

        data = groups_details.objects.filter(group_master_id=gid)

        members = []
        for x in xrange(len(data)):
            username = userInfo.objects.filter(uid=data[x].user_id)
            members.append({
                "userId": data[x].user_id,
                "first_name": username[0].first_name,
                "last_name": username[0].last_name
            })

    return HttpResponse(json.dumps({
        "data": members
    }))


def savegroup(request):
    if request.method == "POST":
        gid = request.POST["gid"]
        name = request.POST["name"]
        firefighter = request.POST["firefighter"]
        user = request.POST["user"].split("|")

        if gid == "-1":
            # delete user - gruops
            for i in range(len(user)):
                groups_details.objects.filter(user_id=user[i]).delete()
            # create group with users
            group = groups_master.objects.create(
                name=name,
                ffid=firefighter)

            for i in range(len(user)):
                groups_details.objects.create(
                    group_master_id=group,
                    user_id=user[i]
                )

        elif gid != "-1":
            # update group
            pass

    return HttpResponse(json.dumps({
        "success": True
    }))


def updategroup(request):
    if request.method == "POST":
        gid = request.POST["gid"]
        name = request.POST["name"]
        firefighter = request.POST["firefighter"]
        user = request.POST["user"].split("|")

        success = groups_master.objects.filter(id=gid).update(
            name=name,
            ffid=firefighter
        )

        gruop = groups_master.objects.get(id=gid)

        if success:
            for i in range(len(user)):
                groups_details.objects.filter(user_id=user[i]).delete()

            for i in range(len(user)):
                groups_details.objects.create(
                    group_master_id=gruop,
                    user_id=user[i]
                )

    return HttpResponse(json.dumps({
        "success": True
    }))


def deletegroups(request):
    if request.method == "POST":
        gid = request.POST["id"]

        success = groups_master.objects.filter(id=gid).delete()
        # cascade
        if success:
            success = True
            groups_details.objects.filter(
                group_master_id=gid).delete()
        elif not success:
            success = False

    return HttpResponse(json.dumps({
        "success": success
    }))
