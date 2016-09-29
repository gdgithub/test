$(document).ready(function(){

// Top bar actions
$("#tsearch").keypress(function(){
    console.log("data");
    getContactWithName($(this).val(),function(data){
        data = $.parseJSON(data);
        if(data.data.length > 0)
        {
            console.log(data);
            contacts_table(data.data,1,10,$(".section_contacts_table"),true);
        }
    })
});

$(".button_contact_filter").click(function(){
    var order_field = $(".select_contact_filter").val();
    var order_px = $(".select_contact_filter_order").val();

    getContactWithFilter(order_field,order_px,function(data){
        data = $.parseJSON(data);
        if(data.data.length > 0)
        {
            console.log(data);
            contacts_table(data.data,1,10,$(".section_contacts_table"),true);
        }
    });
});

getCategories(function(data){

	data = $.parseJSON(data);
	
	if(data.data.length > 0)
    {
        console.log(data);
        categories_table(data.data,1,10,$(".section_categories_table"),true);
    }
    else{
        console.log("no categories");
    }
});

function categories_table(data, page=1, rows=10, parent,admin=true){

    var html = `
        <table class="table_categories_adm">
            <tr id="title">
                <th>Id</th>
                <th>Descripcion</th>
                <th class="removable">Operacion</th>
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

        var trows = `<tr id="rows">
                <td><a>`+data[i].id+`</a></td>
                <td>`+data[i].description+`</td>
                <td class="removable">
                    <div class="ui compact menu">
                      <div class="ui simple dropdown item">
                        -->
                        <i class="dropdown icon"></i>
                        <div class="menu">
                          <div class="item edit" cid="`+data[i].id+`">Editar</div>
                          <div class="item delete" cid="`+data[i].id+`">Eliminar</div>
                        </div>
                      </div>
                    </div>
                </td>
            </tr>`;

        $(".table_categories_adm").append(trows);
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
        <div class="ui right floated menu pagination" id="contact_pagination">
            <a class="icon item prevpagebutton">
                <i class="left chevron icon"></i>
            </a>
            `+pagination+`
            <a class="icon item nextpagebutton">
                <i class="right chevron icon"></i>
            </a>
        </div>`);

    $(".pagebutton").click(function(){
        categories_table(data,$(this).attr('pag'),rows,parent,admin);
    });

    $(".prevpagebutton").click(function(){
        if((page-1) >= 1)
            categories_table(data,page-1,rows,parent,admin);
    });

    $(".nextpagebutton").click(function(){
        if((page+1) <= pag_count)
            categories_table(data,page+1,rows,parent,admin);
    });

    $(".edit").click(function(){
        /*createCookie("edit-contact",$(this).attr("cid"),30000);
        window.location.href="/administration/create_contact";*/
    });

    $(".delete").click(function(){

        if (confirm("Desea eliminar este contacto?")) {

            deleteCategory($(this).attr("cid"),function(data){
                data = $.parseJSON(data);

                if(data.success){

                    getCategories(function(data){
                        data = $.parseJSON(data);
                        if(data.data.length > 0)
                        {
                            categories_table(data.data,1,10,$(".section_categories_table"),true);
                        }
                        else{
                            console.log("no categories");
                        }
                    });
                }
                else
                {
                    alert("error");
                }
            });
        }
        
    });

    if(admin==false)
        $(".table_contacts_adm").find(".removable").remove();

    $('.ui.rating').rating('disable');
}


function getCategories(callback){
	var dic = {
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getcontactscategories/",dic,callback);
}

function deleteCategory(cid,callback){

    var dic = {
        id: cid,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("deletecontact_category/",dic,callback);
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