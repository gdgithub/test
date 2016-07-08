
from django.http import HttpResponse
from directories.models import *
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

    data = list(contacts.objects.values().order_by('rating').reverse())

    return HttpResponse(json.dumps(data))


def create(request):

    if request.method == "POST":
        name = request.POST['name']
        address = request.POST['address']

        contacts.objects.create(
            name=name,
            phone="00",
            address=address,
            category_id=0
        )

    return HttpResponse('Informacion almacenada exitosamente.')


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
