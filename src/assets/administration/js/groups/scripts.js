$(document).ready(function(){

var hasFullPermission = getCookie("urol") == "admin" ? true : false;

interface();

// Top bar actions
$("#tsearch").keyup(function(){
    console.log("data");
    getGroupsWithName($(this).val(),function(data){
        data = $.parseJSON(data);
        if(data.data.length > 0)
        {
            console.log(data);
            groups_table(data.data,1,10,$(".section_groups_table"),hasFullPermission);
        }
    })
});

$(".button_groups_filter").click(function(){
    var order_field = $(".select_groups_filter").val();
    var order_px = $(".select_groups_filter_order").val();

    getGroupsWithFilter(order_field,order_px,function(data){
        data = $.parseJSON(data);
        if(data.data.length > 0)
        {
            console.log(data);
            groups_table(data.data,1,10,$(".section_groups_table"),hasFullPermission);
        }
    });
});


load_groups();

function load_groups(){

    getGroups(function(data){
        data = $.parseJSON(data);
        if(data.data.length > 0)
        {
            console.log(data);
            groups_table(data.data,1,10,$(".section_groups_table"),hasFullPermission);
        }
        else{
            console.log("no groups");
        }
    });
}

function groups_table(data, page=1, rows=10, parent,admin=hasFullPermission){

    var html = `
        <table class="table_groups_adm">
            <tr id="title">
                <th>#</th>
                <th>Grupo</th>
                <th>Encargado</th>
                <th>Miembros</th>
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
                <td>`+(i+1)+`</td>
                <td>`+data[i].name+`</td>
                <td>`+data[i].ffid+`</td>
                <td><a class="members_viewer" gid='`+data[i].id+`'>Ver</a></td>
                <td class="removable">
                    <div class="ui compact menu">
                      <div class="ui simple dropdown item">
                        -->
                        <i class="dropdown icon"></i>
                        <div class="menu">
                          <div class="item edit" gid="`+data[i].id+`">Editar</div>
                          <div class="item delete" gid="`+data[i].id+`">Eliminar</div>
                        </div>
                      </div>
                    </div>
                </td>
            </tr>`;

        $(".table_groups_adm").append(trows);

        console.log(data);
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
        <div class="ui right floated menu pagination" id="groups_pagination">
            <a class="icon item prevpagebutton">
                <i class="left chevron icon"></i>
            </a>
            `+pagination+`
            <a class="icon item nextpagebutton">
                <i class="right chevron icon"></i>
            </a>
        </div>`);

    $(".pagebutton").click(function(){
        groups_table(data,$(this).attr('pag'),rows,parent,admin);
    });

    $(".prevpagebutton").click(function(){
        if((page-1) >= 1)
            groups_table(data,page-1,rows,parent,admin);
    });

    $(".nextpagebutton").click(function(){
        if((page+1) <= pag_count)
            groups_table(data,page+1,rows,parent,admin);
    });

    $(".members_viewer").click(function(){

        getGroupMembers($(this).attr("gid"),function(data){
            data = $.parseJSON(data);
console.log(data);
            if(data.data.length > 0){
                $('.ui.modal').modal('show');

                $(".members_content").html(`
                    <ul class="nav">
                        <li>
                            <table class="nav-table no-select">
                                <tr>
                                    <th>Usuario</th>
                                    <th>Nombre</th>
                                </tr>
                            </table>
                        </li>
                    </ul>
                `);
                for(var i=0; i<data.data.length; i++){
                    $(".nav-table").append(`
                        <tr>
                            <td><span>`+(i+1)+") "+data.data[i].userId+`</span></td>
                            <td><span>`+data.data[i].first_name+" "+data.data[i].last_name+`</span></td>
                        </tr>
                    `);
                }
            }
            else{
                swal({   
                title: "<small>Miembros</small>",   
                text: "No hay miembros.",   
                html: true });
            }
        });


    });

    $(".edit").click(function(){
        createCookie("edit-group",$(this).attr("gid"),30000);
        window.location.href="/administration/create_group";
    });

    $(".delete").click(function(){

        if (confirm("Desea eliminar este grupo?")) {

            deleteGroup($(this).attr("gid"),function(data){
                data = $.parseJSON(data);
                console.log(data);
                if(data.success){

                    //load_groups();
                }
                else
                {
                    alert("error");
                }
            });
        }
        
    });

    if(admin==false)
        $(".table_groups_adm").find(".removable").remove();

    $('.ui.rating').rating('disable');
}


function getGroups(callback){

	var dic = {
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getgroups/",dic,callback);
}

function getGroupsWithName(gname,callback)
{
    var dic = {
        name: gname,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getgroupwithname/",dic,callback);
}

function getGroupsWithFilter(cfield, corderType ,callback, cstatus="non-status")
{
    // Non status: retorna todos los contactos sin dif. de estados.
    var dic = {
        field: cfield,
        orderType: corderType,
        status: cstatus,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getcontactwithfilter/",dic,callback);
}

function getGroupMembers(gid,callback){

    var dic = {
        id: gid,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getgroupmembers/",dic,callback);
}

function deleteGroup(gid,callback){

    var dic = {
        id: gid,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("deletegroups/",dic,callback);
}

function interface(){
    if (hasFullPermission) {
        $(".create_group").html("Crear Nuevo Grupo");
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