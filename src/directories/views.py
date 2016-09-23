
from django.http import HttpResponse
from src.directories.models import *
from src.management.models import *
import json
import copy


def getTable(table):
    row = dict()
    tb = []

    for records in table:
        for field_name in [x.name for x in table.model()._meta.get_fields()]:
            row[field_name] = getattr(records, field_name)
        tb.append(copy.deepcopy(row))
        row = dict()

    return tb
# Create your views here.


def getAll(request):

    data = list(contacts.objects.values().filter(
        status="enable").order_by('rating').reverse())

    return HttpResponse(json.dumps(data))


def contactList(request):

    data = list(contacts.objects.values().all().order_by('name'))

    return HttpResponse(json.dumps(data))


def getcontactlistmenu(request):
    if request.method == "POST":
        cid = request.POST['cid']

        data = list(menu.objects.values().filter(
            cid=cid))

    return HttpResponse(json.dumps(data))


def getmenudetails(request):
    if request.method == "POST":
        mid = request.POST['mid']

        data = list(menu_desc.objects.values().filter(
            mid=mid))

    return HttpResponse(json.dumps(data))


def getmenucategories(request):

    data = list(menu_category.objects.values().all())

    return HttpResponse(json.dumps(data))


def getcategorywithid(request):
    if request.method == "POST":
        id = request.POST['id']

        data = list(menu_category.objects.values().filter(
            id=id))

    return HttpResponse(json.dumps(data))


def managemenu(request):
    if request.method == "POST":
        cid = request.POST['cid']
        mid = request.POST['mid']
        mdid = request.POST['mdid'].split("|")
        mcid = request.POST['mcid'].split("|")
        mdesc = request.POST['mdesc'].split("|")
        mprice = request.POST['mprice'].split("|")
        task = request.POST['task'].split("|")
        newmenu = request.POST['newmenu']

        if newmenu == "true":
            ccid = contacts.objects.get(id=cid)
            menu.objects.create(
                cid=ccid,
                name=mid
            )

            mid = menu.objects.filter(name=mid, cid=cid)
            mid = mid[0].id

        for x in range(len(mdid)):
            if(task[x] == "edit"):
                menu_desc.objects.filter(id=mdid[x]).update(
                    categoryId=mcid[x],
                    description=mdesc[x],
                    price=mprice[x],
                    mid=mid
                )
            elif(task[x] == "create"):
                menuId = menu.objects.get(id=mid)
                menuCat = menu_category.objects.get(id=mcid[x])
                menu_desc.objects.create(
                    categoryId=menuCat,
                    description=mdesc[x],
                    price=mprice[x],
                    mid=menuId
                )

        return HttpResponse(json.dumps("success"))


def deletemenu(request):
    if request.method == "POST":
        mid = request.POST['mid']
        menu.objects.filter(id=mid).delete()

    return HttpResponse(json.dumps("success"))


def deletemenuitem(request):
    if request.method == "POST":
        eid = request.POST['eid']

        menu_desc.objects.filter(id=eid).delete()

    return HttpResponse(json.dumps("success"))


def deletemenuelements(request):
    if request.method == "POST":
        mdid = request.POST['mdid'].split("|")

        for x in range(len(mdid)):
            menu_desc.objects.filter(id=mdid[x]).delete()

        return HttpResponse(json.dumps("success"))


def getContactsOrdered(request):

    if request.method == "POST":
        order = request.POST['order']

    if order == "c":
        data = list(contacts.objects.values().filter(
            status="enable").order_by('categoryId'))
    elif order == "1":
        data = list(contacts.objects.values().filter(
            rating=1, status="enable"))
    elif order == "2":
        data = list(contacts.objects.values().filter(
            rating=2, status="enable"))
    elif order == "3":
        data = list(contacts.objects.values().filter(
            rating=3, status="enable"))
    elif order == "4":
        data = list(contacts.objects.values().filter(
            rating=4, status="enable"))
    elif order == "5":
        data = list(contacts.objects.values().filter(
            rating=5, status="enable"))
    elif order == "r>":
        data = list(contacts.objects.values().filter(
            status="enable").order_by('rating').reverse())
    elif order == "r<":
        data = list(contacts.objects.values().filter(
            status="enable").order_by('rating'))
    else:
        data = list(contacts.objects.values().filter(
            status="enable").order_by('rating').reverse())

    return HttpResponse(json.dumps(data))


def getContactsName(request):
    if request.method == "POST":
        userRol = request.POST['userRol']

        if int(userRol) == 1:
            data = list(contacts.objects.values('name').all().order_by('name'))
        else:
            data = list(contacts.objects.values('name').filter(
                status="enable").order_by('name'))

    return HttpResponse(json.dumps(data))


def getCategories(request):

    data = list(category.objects.values('description').order_by('description'))

    return HttpResponse(json.dumps(data))


def findContact(request):

    if request.method == "POST":
        name = request.POST['name']

    data = list(contacts.objects.values().filter(
        name__icontains=name, status="enable"))

    return HttpResponse(json.dumps(data))


def getContactWithId(request):

    if request.method == "POST":
        id = request.POST['id']

    data = list(contacts.objects.values().filter(
        id=id))

    return HttpResponse(json.dumps(data))


def create(request):
    if request.method == "POST":
        rnc = request.POST['rnc']
        nombre = request.POST['nombre']
        categoria = request.POST['categoria']
        desc = request.POST['desc']
        telefono = request.POST['telefono']
        direccion = request.POST['direccion']
        status = request.POST['status']
        userId = request.POST['userId']

        exists = contacts.objects.filter(rnc=rnc)
        created = False

        if not exists:
            ci = category.objects.get(description=categoria)
            contacts.objects.create(
                rnc=rnc,
                categoryId=ci,
                name=nombre,
                image='',
                phone=telefono,
                address=direccion,
                rating=0,
                description=desc,
                status=status)

            if status == "enable":
                status = "new contact"
            elif status == "disable":
                status = "contact suggest"

            notifications.objects.create(
                uid=userId,
                oid=rnc,
                type="contact",
                description="",
                status=status
            )

            created = True
            exists = False
        elif exists:
            exists = True

        return HttpResponse(json.dumps({
            "exists": exists,
            "created": created
        }))


'''
def create(request):
    """
    Usuario administrador: 
    *si existe el contacto, lo actualiza. de lo contrario, lo crea.
    Usuario dev/ff:
    *Si no existe el contacto (rnc contact) lo crea. de lo contrario
    retorna msg error
    """

    if request.method == "POST":
        rnc = request.POST['rnc']
        nombre = request.POST['nombre']
        categoria = request.POST['categoria']
        desc = request.POST['desc']
        imagen = request.POST['imagen']
        telefono = request.POST['telefono']
        direccion = request.POST['direccion']
        menu_price = request.POST['menu_price']
        menu_desc = request.POST['menu_desc']
        status = request.POST['status']
        userRol = request.POST['userRol']

        category_Id = category.objects.get(description=categoria)

        exists = contacts.objects.filter(rnc=rnc)

        if int(userRol) == 1:
            # admin task

            if exists:
                # update contact
                updated = contacts.objects.filter(rnc=rnc).update(
                    name=nombre,
                    image=imagen,
                    description=desc,
                    categoryId=category_Id,
                    rating=0,
                    status=status
                )

                if updated:
                    msg = {"s": "Contacto actualizado correctamente."}

                else:
                    msg = {"f": """Ocurrio un error durante la
                             actualizacion del contacto"""}
            else:
                saveContact(rnc, nombre, imagen, desc, category_Id, 0, status,
                            telefono, direccion, menu_desc, menu_price)
                msg = {"s": """Contacto almacenado exitosamente."""}
        else:

            if not exists:
                saved = saveContact(rnc, nombre, imagen, desc, category_Id, 0,
                                    status, telefono, direccion,
                                    menu_desc, menu_price)

                if saved:
                    msg = {"s": "La solicitud ha sido enviada."}
                else:
                    msg = {"f": """No se ha podido enviar la solicitud.
                     Por favor, intentelo nuevamente."}"""}
            else:
                msg = {"a": "Contacto existe."}

    return HttpResponse(json.dumps(msg))
'''

"""
def saveContact(rnc, name, image, description, categoryId, rating,
                status, phone, addr, menu_desc, menu_price):

    phone = phone.split('|')
    addr = addr.split('|')

    success = contacts.objects.create(
        rnc=rnc,
        name=name,
        image=image,
        description=description,
        categoryId=categoryId,
        rating=rating,
        status=status
    )

    contactId = contacts.objects.get(rnc=rnc)

    temp_p = ""
    temp_a = ""

    for i in range(len(phone)):
        branch.objects.create(
            contactId=contactId,
            phone=phone[i],
            address=addr[i]
        )
        temp_a = addr[i]
        temp_p = phone[i]

    desc = menu_desc.split('|')
    price = menu_price.split('|')

    if len(desc) > 0 and len(price) > 0:

        branchId = branch.objects.get(
            contactId=contactId, phone=temp_p, address=temp_a)

        for i in range(len(desc)):
            menu.objects.create(
                branchId=branchId,
                description=desc[i],
                price=price[i]
            )

    return success
"""


def delete(request):

    if request.method == "POST":
        id = request.POST['id']

        contacts.objects.filter(id=id).delete()
    return HttpResponse("Contacto eliminado")


def getContactBranches(request):

    if request.method == "POST":
        contactId = request.POST['contactId']

        branch_data = list(branch.objects.filter(
            contactId=contactId).values('id', 'phone', 'address'))

    return HttpResponse(json.dumps(branch_data))


def getBranchMenu(request):
    if request.method == "POST":
        branchId = request.POST['branchId']

        branch_menu = list(menu.objects.filter(
            branchId=branchId).values('id', 'description', 'price'))

    return HttpResponse(json.dumps(branch_menu))


# Nueva orden
def createOrder(request):
    if request.method == "POST":
        userId = request.POST['userId']
        description = request.POST['dataOrder']
        status = request.POST['status']

        data = orders.objects.create(
            userId=userId,
            description=description,
            status=status
        )

        if data:
            data = True
            orderId = orders.objects.filter(
                userId=userId,
                description=description,
                status=status)

            notifications.objects.create(
                uid=userId,
                oid=orderId[0].id,
                type="order",
                description=description,
                status="no checked"
            )
        elif not data:
            data = False

    return HttpResponse(json.dumps({
        "success": data}))
