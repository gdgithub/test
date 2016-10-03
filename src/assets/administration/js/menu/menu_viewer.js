$(document).ready(function(){

$(".div_calculator").click(function(){
    
    $(".items-selected-viewer").html(`
        <ul class="nav">
            <li>
                <table class="nav-table no-select">
                    <tr>
                        <th>Plato</th>
                        <th>Cantidad</th>
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

    var total = 0;
    $(".li-active").each(function(){
        total += parseFloat($(this).attr("price"));

        $(".items-selected-viewer .nav-table").append(`
            <tr>
                <td><span class="sitem">`+$(this).html()+`</span></td>
                <td><input type="number" value="1" class="input-cantidad" /></td>
                <td> $ <span class="sprice">`+$(this).attr("price")+`</span></td>
                <td> $ <span class="stotal">`+$(this).attr("price")+`</span></td>
            </tr>
        `);
    });

    $(".total").html("Total: $ "+total);

    $(".input-cantidad").change(function(){
        var cant = parseInt($(this).val());
        var item_price = parseFloat($(this).parent().parent().find(".sprice").html());  
        var item_total = cant*item_price;
        $(this).parent().parent().find(".stotal").html(item_total);

        total = 0;
        $(".stotal").each(function(){
            total += parseFloat($(this).html());
        });
        $(".total").html("Total: $ "+total);
    });
});

$(".do-request").click(function(){
    var cant = [];
    var item = [];
    var price = [];
    var total = [];
    var total_all = 0;

    $(".sitem").each(function(){
        cant.push(parseInt($(this).parent().parent().find(".input-cantidad").val()));
        item.push($(this).parent().parent().find(".sitem").html());
        price.push(parseFloat($(this).parent().parent().find(".sprice").html()));
        total.push(parseFloat($(this).parent().parent().find(".stotal").html()));
        total_all += parseFloat($(this).parent().parent().find(".stotal").html());
    });

    var dic = {
            uid: getCookie("userId"),
            cid:$(".contact-id").html(),
            mid:$(".menu-id").html(),
            status:"Pendiente",
            total: total_all,
            amount: cant.join("|"),
            items: item.join("|"),
            price: price.join("|"),
            total_item: total.join("|"),
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
        }

        postData("createorder/",dic,function(data){
            data = $.parseJSON(data);
            if (data.success) {
                $(".close").click();

                swal({   
                    title: "<small>ORDEN</small>",   
                    text: "La orden se realizo exitosamente. <a href='/administration/orders/' style='color:#F8BB86'>Ver Ordenes</a>",   
                    html: true });

            }
            console.log(data);
        });
});

getMenuWithId(getCookie("view-menu"),function(data){
    data = $.parseJSON(data);

    if(data.data){
        create_menu(data,menuItemEvents);
    }
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
                <li class="menu_li" price="`+content[i].price+`">`+content[i].name+`</li>
            `);
        }

        $(".menu_li").click(li_handler);
    }
}

function menuItemEvents()
{
    var item = $(this);

    if(item.hasClass("li-active"))
    {
        item.removeClass("li-active");
        setCalcDivText("Abrir calculadora");
    }
    else{
        item.addClass("li-active");
        setCalcDivText(`
            <ul>
                <li><p><b>Precio:</b> $`+item.attr("price")+`</p></li>
            </ul>
            `);
    }
}

function setCalcDivText(text){
    $(".div_calculator").html(text);
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