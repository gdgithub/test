
from django.http import HttpResponse
from src.directories.models import *
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
        branchId = request.POST['branchId']
        description = request.POST['dataOrder']
        status = request.POST['status']

        b = branch.objects.get(id=branchId)

        orders.objects.create(
            userId=userId,
            branchId=b,
            description=description,
            status=status
        )

    return HttpResponse('Informacion almacenada exitosamente.')
