$(document).ready(function(){

var hasFullPermission = getCookie("urol") == "admin" ? true : false;

// Top bar actions
$("#tsearch").keyup(function(){
    if($(this).val().length == 0)
        return false;

    getOrderWithParamns($(this).val(),$(".search_by").val(),function(data){
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

    getOrderWithFilter(order_field,order_px,function(data){
        data = $.parseJSON(data);
        if(data.data.length > 0)
        {
            console.log(data);
            orders_table(data.data,1,10,$(".section_orders_table"),hasFullPermission);
        }
    });
});

load_orders();

function load_orders()
{
    getOrders(function(data){

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

        var trows = `<tr id="rows">
                <td><a>`+data[i].orderId+`</a></td>
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

        $('.ui.modal').modal('show');

        getOrderWithId($(this).attr("orderId"),function(data){
            data = $.parseJSON(data);
            $(".modal_no_orden").html(data.data[0].orderId);

            if(data.data){
                console.log(data);
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

    if(admin==false)
        $(".table_orders_adm").find(".removable").remove();

    $('.ui.rating').rating('disable');
}


function getOrders(callback){
	var dic = {
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

function getOrderWithParamns(_text,_seachType,callback){
    var dic = {
        text: _text,
        searchType: _seachType,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getorderwithparamns/",dic,callback);
}

function getOrderWithFilter(cfield, corderType ,callback)
{
    var dic = {
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