$(document).ready(function(){

var hasFullPermission = getCookie("urol") == "admin" ? true : false;

loader();
initializeSearch();

// Top bar actions
$("#tsearch").keyup(function(){
    if($(this).val().length == 0)
        return false;

    getOrderWithParamns(getCookie("userId"),$(this).val(),$(".search_by").val(),function(data){
        data = $.parseJSON(data);
        if(data.data.length > 0)
        {
            console.log(data);
            orders_table(data.data,1,10,$(".section_orders_table"),hasFullPermission);
        }
    })
});

$(".button_orders_filter").click(function(){
    var order_field = $(".select_orders_filter").val();
    var order_px = $(".select_orders_filter_order").val();

    getOrderWithFilter(getCookie("userId"),order_field,order_px,function(data){
        data = $.parseJSON(data);
        if(data.data.length > 0)
        {
            console.log(data);
            orders_table(data.data,1,10,$(".section_orders_table"),hasFullPermission);
        }
    });
});

$(".new_order").click(function(){

    $(".select_contact").html("");
    $(".select_menu").html("");

    getContacts(function(data){
        data = $.parseJSON(data);

        if(data.data.length > 0){

            var content = `<option value="">Seleccionar contacto</option>`;
            for(var i=0; i<data.data.length; i++){
                content += `<option value="`+data.data[i].id+`">`+data.data[i].name+`</option>`;
            }

            $(".select_contact").html(content);
            $('.select_contact').dropdown();
            $('.ui.modal.neworders').modal('show');
        }
    },"active");
});

$(".select_contact").change(function(){

    $(".select_menu").html("");

    getContactMenu($(this).val(), function(data){
        data = $.parseJSON(data);
            
        if(data.data.length > 0)
        {
            var content = `<option value="">Seleccionar menu</option>`;
            for(var i=0; i<data.data.length; i++){
                content += `<option value="`+data.data[i].id+`">`+data.data[i].menu+`</option>`;
            }

            $(".select_menu").html(content);
            $('.select_menu').dropdown();
        }
        else{
            console.log("no contacts");
        }
    });
});


function load_orders()
{
    getOrders(getCookie("userId"),function(data){

        data = $.parseJSON(data);
        
        if(data.data.length > 0)
        {
            console.log(data);
            orders_table(data.data,1,10,$(".section_orders_table"),hasFullPermission);
        }
        else{
            console.log("no contacts");
        }
    });
}

function orders_table(data, page=1, rows=10, parent,admin=true){

    var html = `
        <table class="table_orders_adm">
            <tr id="title">
                <th>No. Orden</th>
                <th>Usuario</th>
                <th>Contacto</th>
                <th>Menu</th>
                <th>Detalle</th>
                <th class="removable">Estado</th>
                <th>Total</th>
                <th>Fecha</th>
                <th>Operacion</th>
            </tr>
        </table>`;

    parent.html(html);

    var pag_count = 1;

        if((data.length % rows) == 0)
            pag_count = Math.floor(data.length/rows);
        else
            pag_count = Math.floor(data.length/rows)+1;

    for(var i=(page-1)*rows; i<(page*rows); i++){

        if((data.length-1) < i)
            break;

        var details_visibility = "";
        if(data[i].details.length==0)
            details_visibility = "no-items";

        var deliverOption = "";
        if(data[i].status !="Entregado" && data[i].status !="Cancelado" && data[i].status !="Recibido")
            deliverOption = `<div class="item setOrderRecived removable" orderId="`+data[i].orderId+`">Recibido en almacen</div>`;

        var mountOption = "";
        if(data[i].status && data[i].status =="Recibido")
            mountOption = `<div class="item setOrderMount removable" orderId="`+data[i].orderId+`">Establecer monto</div>`;

        var trows = `<tr id="rows">
                <td>`+data[i].orderId+`</td>
                <td>`+data[i].userId+`</td>
                <td>`+data[i].contact_name+`</td>
                <td>`+data[i].menu_name+`</td>
                <td><a class="show_order_details `+details_visibility+`" orderId="`+data[i].orderId+`">Ver</a></td>
                <td class="estado removable">`+data[i].status+`</td>
                <td>$`+data[i].total_order+`</td>
                <td>`+data[i].date+`</td>
                <td>
                    <div class="ui compact menu">
                      <div class="ui simple dropdown item">
                        -->
                        <i class="dropdown icon"></i>
                        <div class="menu">
                            <div class="item reorder" orderId="`+data[i].orderId+`">Volver a pedir</div>
                          <div class="item cancelOrder" orderId="`+data[i].orderId+`">Cancelar</div>
                          <div class="item setOrderDelivered removable" orderId="`+data[i].orderId+`">Entregado</div>
                          <section class="menu-divider divider-top"></section>
                          `+deliverOption+`
                          `+mountOption+`
                        </div>
                      </div>
                    </div>
                </td>
            </tr>`;    

        $(".table_orders_adm").append(trows);

        if($(".estado:last").html()=="Entregado")
            $(".estado:last").addClass("delivered");
        else if($(".estado:last").html()=="Cancelado")
            $(".estado:last").addClass("canceled");
    }

    var pagination = "";
    var class_active = "";
    for(var i=0; i<pag_count; i++)
    {
        class_active="";
        if(i==page-1)
            class_active = "active";

        pagination += `<a class="item pagebutton `+class_active+`" pag=`+(i+1)+`>`+(i+1)+`</a>`;
    }

    parent.append(`
        <div class="ui right floated menu pagination" id="orders_pagination">
            <a class="icon item prevpagebutton">
                <i class="left chevron icon"></i>
            </a>
            `+pagination+`
            <a class="icon item nextpagebutton">
                <i class="right chevron icon"></i>
            </a>
        </div>`);


    $(".pagebutton").click(function(){
        orders_table(data,$(this).attr('pag'),rows,parent,admin);
    });

    $(".prevpagebutton").click(function(){
        if((page-1) >= 1)
            orders_table(data,page-1,rows,parent,admin);
    });

    $(".nextpagebutton").click(function(){
        if((page+1) <= pag_count)
            orders_table(data,page+1,rows,parent,admin);
    });

    $(".show_order_details").click(function(){

        if($(this).hasClass("no-items"))
        {   
            swal({   
                title: "<small>ORDEN</small>",   
                text: "No hay detalles.",   
                html: true });
            return false;
        }

        getOrderWithId($(this).attr("orderId"),function(data){
            data = $.parseJSON(data);
            $(".modal_no_orden").html(data.data[0].orderId);

            if(data.data){
                $('.ui.modal.orders').modal('show');
                
                $(".order_details_content").html(`
                    <ul class="nav">
                        <li>
                            <table class="nav-table no-select">
                                <tr>
                                    <th>Cantidad</th>
                                    <th>Plato</th>
                                    <th>Precio</th>
                                    <th>Total</th>
                                </tr>
                            </table>
                        </li>
                        <li>
                        <section class="menu-divider divider-top"></section>
                            <p class="total"></p>
                        </li>
                    </ul>
                `);
                for(var i=0; i<data.data[0].details.length; i++){
                    $(".nav-table").append(`
                        <tr>
                            <td><span class="scant">`+data.data[0].details[i].amount+`</span></td>
                            <td><span class="sitem">`+data.data[0].details[i].item+`</span></td>
                            <td> $ <span class="sprice">`+data.data[0].details[i].price+`</span></td>
                            <td> $ <span class="stotal">`+data.data[0].details[i].total+`</span></td>
                        </tr>
                    `);
                }
            }
        });
    });

    $(".reorder").click(function(){

        getOrderWithId($(this).attr("orderId"),function(data){
            data = $.parseJSON(data);

            if(data.data){
                
                var amount = [];
                var item = [];
                var price = [];
                var total = [];

                for(var i=0; i<data.data[0].details.length; i++){
                    amount.push(data.data[0].details[i].amount);
                    item.push(data.data[0].details[i].item);
                    price.push(data.data[0].details[i].price);
                    total.push(data.data[0].details[i].total);
                }

                var dic = {
                    uid: getCookie("userId"),
                    cid: data.data[0].contact_id,
                    mid: data.data[0].menu_id,
                    status:"waiting",
                    total: data.data[0].total_order,
                    amount: amount.join("|"),
                    items: item.join("|"),
                    price: price.join("|"),
                    total_item: total.join("|"),
                    csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
                }

                postData("createorder/",dic,function(data){
                    data = $.parseJSON(data);
                    if (data.success) {

                        load_orders();

                        swal({   
                            title: "<small>ORDEN</small>",   
                            text: "La orden se realizo exitosamente. <span style='color:#F8BB86'>Ver Orden</span>",   
                            html: true });

                    }
                });
            }
            else
            {
                swal({   
                    title: "<small>ORDEN</small>",   
                    text: "No se pudo cargar la orden.",   
                    html: true });
            }
        });
    });

    $(".cancelOrder").click(function(){

        if (confirm("Desea cancelar esta orden?")) {

            cancelOrder($(this).attr("orderId"),function(data){
                data = $.parseJSON(data);

                if(data.success)
                {
                    load_orders();

                    swal({   
                        title: "<small>ORDEN</small>",   
                        text: "La orden ha sido cancelada.",   
                        html: true });
                }
                else
                {
                    swal({   
                        title: "<small>ORDEN</small>",   
                        text: "Ocurrio un error durante la solicitud.",   
                        html: true });
                }
            });
        }
        
    });

    $(".setOrderDelivered").click(function(){

        if (confirm("Desea cambiar esta orden a estado entregado?")) {

            setOrderDelivered($(this).attr("orderId"),function(data){
                data = $.parseJSON(data);

                if(data.success)
                {
                    load_orders();

                    swal({   
                        title: "<small>ORDEN</small>",   
                        text: "Solicitud procesada correctamente.",   
                        html: true });
                }
                else
                {
                    swal({   
                        title: "<small>ORDEN</small>",   
                        text: "Ocurrio un error durante la solicitud.",   
                        html: true });
                }
            });
        }
        
    });

    $(".setOrderRecived").click(function(){

        if (confirm("Desea cambiar esta orden a estado recibido?")) {

            setOrderRecived(getCookie("userId"), $(this).attr("orderId"),function(data){
                data = $.parseJSON(data);

                if(data.success)
                {
                    load_orders();

                    swal({   
                        title: "<small>ORDEN</small>",   
                        text: "Solicitud procesada correctamente.",   
                        html: true });
                }
                else
                {
                    swal({   
                        title: "<small>ORDEN</small>",   
                        text: "Ocurrio un error durante la solicitud.",   
                        html: true });
                }
            });
        }
        
    });

    if(admin==false)
        $(".table_orders_adm").find(".removable").remove();

    $('.ui.rating').rating('disable');
}


function initializeSearch(){

    var content = [];

    getContacts(function(data){
        data = $.parseJSON(data);
        if(data)
        {
            for(var i=0; i<data.data.length; i++){
                content.push({
                    "title":data.data[i].name, 
                    "description":data.data[i].category,
                    "id":data.data[i].id
                });
            }
        }

        $('.ui.search')
          .search({
            source : content,
            searchFields   : [
              'title'
            ],
            searchFullText: false
          });

    },"active");
}

$(".contact_searcher").keyup(function(e){
    if (e.keyCode == 13) {
        var cid = $('.ui.search').search('get result', $(this).val())[0].id;

        if(cid)
            loadContactMenues(cid);
    }
});

function loadContactMenues(cid){

    $(".select_menu").html("<option value=''>Seleccione el menu</option>");

    var content = [];

    getContactMenu(cid,function(data){
        data = $.parseJSON(data);
        if(data){
            for(var i=0; i<data.data.length; i++){
                $(".select_menu").append(`
                    <option mid="`+data.data[i].id+`">`+data.data[i].menu+`</option>
                `);
            }
        }
    });
}

$(".select_menu").change(function(){
    var mid = $(".select_menu option:selected").attr("mid");
   // if(mid){
        getMenuWithId(mid,function(data){
            data = $.parseJSON(data);

            if(data.data){
                console.log(data);
                create_menu(data,null);
            }
        });
  //  }
});



function create_menu(data, li_handler){
    if(data.data){
        // muestra 1 menu 
        var menu_name = data.data[0].menu;
        var menu_id = data.data[0].id;
        var contact = data.data[0].contact;
        var contact_id = data.data[0].contactId;
        var content = data.data[0].dishes;

        $(".menu-name").html(menu_name);
        $(".contact-name").html(contact);
        $(".menu-id").html(menu_id);
        $(".contact-id").html(contact_id);

        $(".menu-content").html(`
            <ul class="ulviewer">
            </ul>
            `);

        var categoryId = "";
        for(var i=0; i<content.length; i++)
        {
            categoryId = content[i].menu_category_id;

            if($(".category"+categoryId).length == 0){
                $(".ulviewer").append(`
                    <li><ul class="`+"category"+categoryId+` ulcategory">
                        <li class="menu_li_category">`+content[i].menu_category_name+`<li>
                    </ul></li>
                    `);
            }

            $(".category"+categoryId).append(`
                <li class="menu_li" price="`+content[i].price+`">`+content[i].name+`<span class="itemPrice">$ `+content[i].price+`</span></li>
            `);
        }

        $(".menu_li").click(li_handler);
    }
}

function loader(){

    if(getCookie("view-order") != "null"){
        getOrderWithId(getCookie("view-order"),function(data){
            data = $.parseJSON(data);
            if(data.data.length > 0)
            {
                orders_table(data.data,1,10,$(".section_orders_table"),hasFullPermission);
                deleteCookie("view-order");
            }
        });
    }
    else{
        load_orders();
    }
}

function getOrders(usr, callback){
	var dic = {
        userId: usr,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getorders/",dic,callback);
}

function getOrderWithId(oid,callback){
    var dic = {
        id: oid,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getorderwithid/",dic,callback);
}

function getOrderWithParamns(userid,_text,_seachType,callback){
    var dic = {
        userId: userid,
        text: _text,
        searchType: _seachType,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getorderwithparamns/",dic,callback);
}

function getOrderWithFilter(userid, cfield, corderType ,callback)
{
    var dic = {
        userId: userid,
        field: cfield,
        orderType: corderType,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getorderwithfilter/",dic,callback);
}

function cancelOrder(oid, callback){

    var dic = {
        id: oid,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("cancelOrderWithId/",dic,callback);
}

function setOrderDelivered(oid, callback){

    var dic = {
        id: oid,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("setorderdelivered/",dic,callback);
}

function setOrderRecived(user, oid, callback){

    var dic = {
        uid: user,
        id: oid,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("setorderrecived/",dic,callback);
}

function getContacts(callback, cstatus="non-status"){
    // Non status: retorna todos los contactos sin dif. de estados.
    var dic = {
        status: cstatus,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getcontacts/",dic,callback);
}

function getContactMenu(cid, callback){
    var dic = {
        contactId: cid,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getcontactmenu/",dic,callback);
}

function getMenuWithId(mid, callback){
    var dic = {
        id: mid,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

        postData("getmenuwithid/",dic,callback);
}

function postData(url,vars,callback)
{
  $.ajax({
      type:"POST",
          url:url,
          data: vars,
          success: callback
  });
}

var createCookie = function(name, value, days) {
    var expires;
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toGMTString();
    }
    else {
        expires = "";
    }
    document.cookie = name + "=" + value + expires + "; path=/";
}

function getCookie(c_name) {
    if (document.cookie.length > 0) {
        c_start = document.cookie.indexOf(c_name + "=");
        if (c_start != -1) {
            c_start = c_start + c_name.length + 1;
            c_end = document.cookie.indexOf(";", c_start);
            if (c_end == -1) {
                c_end = document.cookie.length;
            }
            return unescape(document.cookie.substring(c_start, c_end));
        }
    }
    return "";
}

function deleteCookies()
{
	createCookie('userId',null,3000);
	createCookie('access-type',null,3000);
	createCookie('ormemfil',null,3000);
}

function deleteCookie(name)
{
	createCookie(name,null,3000);
}

});