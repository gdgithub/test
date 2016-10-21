$(document).ready(function(){

$(".create_user").click(function(){
    createCookie("bkpath",window.location.pathname,3000);
    window.location.replace("/administration/create_user");
});

var hasFullPermission = getCookie("urol") == "admin" ? true : false;
var users_status = (hasFullPermission == true) ? "all" : "active";

// Redirect if isnt admin user
if(!hasFullPermission){
    createCookie("edit-users",getCookie("userId"),3000);
    window.location.href = "/administration/create_user";
    return false;
}

interface();

// Top bar actions
$("#tsearch").keyup(function(){
    getUserWithName($(this).val(),function(data){
        data = $.parseJSON(data);
        console.log(data);
        if(data.data.length > 0)
        {
            console.log(data);
            users_table(data.data,1,10,$(".section_users_table"),hasFullPermission);
        }
    },users_status)
});

$(".button_users_filter").click(function(){
    var order_field = $(".select_users_filter").val();
    var order_px = $(".select_users_filter_order").val();

    getContactWithFilter(order_field,order_px,function(data){
        data = $.parseJSON(data);
        if(data.data.length > 0)
        {
            console.log(data);
            users_table(data.data,1,10,$(".section_users_table"),hasFullPermission);
        }
    },users_status);
});

load_users();

function load_users(){

    getUsers(function(data){

        data = $.parseJSON(data);
        console.log(data);
        if(data.data.length > 0)
        {
            console.log(data);
            users_table(data.data,1,10,$(".section_users_table"),hasFullPermission);
        }
        else{
            console.log("no users");
        }
    });
}

function users_table(data, page=1, rows=10, parent,admin=hasFullPermission){

    var html = `
        <table class="table_users_adm">
            <tr id="title">
                <th>#</th>
                <th>Correo</th>
                <th>Nombres</th>
                <th>Apellidos</th>
                <th class="removable">Rol</th>
                <th class="removable">Estado</th>
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

        var urol = "";
        if (data[i].rol == 1)
            urol = "Administrador";
        else if (data[i].rol == 2)
            urol = "FireFighter";
        else if (data[i].rol == 3)
            urol = "Developer";

        var activityOptions = "";
        if (data[i].status == "active")
            activityOptions = `<div class="item changestatus" uid="`+data[i].email+`" status="inactive">Inhabilitar</div>`;
        else if (data[i].status == "inactive")
            activityOptions = `<div class="item changestatus" uid="`+data[i].email+`" status="active">Habilitar</div>`;

        var trows = `<tr id="rows">
                <td>`+(i+1)+`</td>
                <td>`+data[i].email+`</td>
                <td>`+data[i].first_name+`</td>
                <td>`+data[i].last_name+`</td>
                <td class="removable">`+urol+`</td>
                <td class="removable">`+data[i].status+`</td>
                <td class="removable">
                    <div class="ui compact menu">
                      <div class="ui simple dropdown item">
                        -->
                        <i class="dropdown icon"></i>
                        <div class="menu">
                          <div class="item edit" uid="`+data[i].email+`">Editar</div>
                          <div class="item delete" uid="`+data[i].email+`">Eliminar</div>
                          <section class="menu-divider divider-top"></section>
                          `+activityOptions+`
                        </div>
                      </div>
                    </div>
                </td>
            </tr>`;

        $(".table_users_adm").append(trows);
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
        <div class="ui right floated menu pagination" id="users_pagination">
            <a class="icon item prevpagebutton">
                <i class="left chevron icon"></i>
            </a>
            `+pagination+`
            <a class="icon item nextpagebutton">
                <i class="right chevron icon"></i>
            </a>
        </div>`);

    $(".users_rnc").click(function(){
        console.log($(this).html());
    });

    $(".pagebutton").click(function(){
        users_table(data,$(this).attr('pag'),rows,parent,admin);
    });

    $(".prevpagebutton").click(function(){
        if((page-1) >= 1)
            users_table(data,page-1,rows,parent,admin);
    });

    $(".nextpagebutton").click(function(){
        if((page+1) <= pag_count)
            users_table(data,page+1,rows,parent,admin);
    });

    $(".menu_viewer").click(function(){
        /*createCookie("view-menu",$(this).attr("id"),30000);
        window.location.href="/administration/menu_viewer";*/
    });

    $(".edit").click(function(){
        createCookie("bkpath",window.location.pathname,3000);
        createCookie("edit-users",$(this).attr("uid"),30000);
        window.location.href="/administration/create_user";
    });

    $(".delete").click(function(){

        if (confirm("Desea eliminar este usuario?")) {

            deleteUser($(this).attr("uid"),function(data){
                data = $.parseJSON(data);

                if(data.success){

                    load_users();
                }
                else
                {
                    alert("error");
                }
            });
        }
        
    });

    $(".changestatus").click(function(){

        changeUserStatus($(this).attr("uid"),$(this).attr("status"),function(data){
            data = $.parseJSON(data);
            if(data.success)
                load_users();
        });
    });

    if(admin==false)
        $(".table_users_adm").find(".removable").remove();

    $('.ui.rating').rating('disable');
}


function getUsers(callback,ustatus="all"){
	var dic = {
        status: ustatus,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getUsers/",dic,callback);
}

function getUserWithName(uname,callback, ustatus="all")
{
    var dic = {
        name: uname,
        status: ustatus,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getuserwithname/",dic,callback);
}

function changeUserStatus(uid, ustatus, callback)
{
    var dic = {
        userId: uid,
        status: ustatus,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("changeuserstatus/",dic,callback);
}

function deleteUser(uid,callback){

    var dic = {
        email: uid,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("deleteuser/",dic,callback);
}

function interface(){
    if (hasFullPermission) {
        $(".create_user").html("Registrar Usuario");
    }
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

function createCookie(name, value, days) {
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