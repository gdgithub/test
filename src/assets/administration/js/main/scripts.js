$(document).ready(function(){

if(getCookie("userId")=="null")
    window.location.replace("/login");

$(".logout").click(function(){
    deleteCookies();
    window.location.replace("/login");
});

$(".useraccount").click(function(){
    createCookie("bkpath",window.location.pathname,3000);
    createCookie("edit-users",getCookie("userId"),30000);
   // createCookie("mi-account","true",30000);
    window.location.replace("/administration/create_user/");
});

activeUserNavigationButtons();

accessType(getCookie("access-type"));

setBarUserInfo(getCookie("uname"),getCookie("userId"));
getUserInfo(getCookie("userId"),function(data){
    data = $.parseJSON(data);
    if(data.exists)
    {
        var username = data.data[0].first_name+" "+data.data[0].last_name;
        setBarUserInfo(username,getCookie("userId"));
        createCookie("uname",username,3000);
        createCookie("access-type",data.data[0].rol,3000);
    }
});

/*************************************************************/
var hasFullPermission = getCookie("urol") == "admin" ? true : false;

// Redirect if isnt admin user
if(!hasFullPermission){
    /*createCookie("edit-users",getCookie("userId"),3000);
    $(".adm_users a").attr("href","/administration/create_user");
    $(".adm_users a").html("Mi Cuenta");
    $(".title-page").html("Informacion personal");*/
    $(".adm_users a").attr("href","/administration/users");
}
else{
     $(".adm_users a").attr("href","/administration/users");
     $(".adm_users a").html("Adm. de usuarios");
}

/*************************************************************/

function activeUserNavigationButtons()
{
    if(window.location.pathname=="/administration/welcome/"){
        $(".welcome").addClass("selected");
        $(".title-page").html("Bienvenido");
    }
    else if(window.location.pathname=="/administration/contacts/"){
        $(".adm_contactos").addClass("selected");
        $(".title-page").html("Administración de contactos");
    }
    else if(window.location.pathname=="/administration/create_contact/"){
        $(".adm_contactos").addClass("selected");
        $(".title-page").html("Registro de contactos");
    }
    else if(window.location.pathname=="/administration/contact_categories/"){
        $(".adm_contactos").addClass("selected");
        $(".title-page").html("Administración de categorias");
    }
    else if(window.location.pathname=="/administration/menu/"){
        $(".adm_menu").addClass("selected");
        $(".title-page").html("Administracion de menu");
    }
    else if(window.location.pathname=="/administration/create_menu/"){
        $(".adm_menu").addClass("selected");
        $(".title-page").html("Registro de menu");
    }
    else if(window.location.pathname=="/administration/menu_categories/"){
        $(".adm_menu").addClass("selected");
        $(".title-page").html("Administración de categorias");
    }
    else if(window.location.pathname=="/administration/menu_viewer/"){
        $(".adm_menu").addClass("selected");
        $(".title-page").html("Detalles del menu");
    }
    else if(window.location.pathname=="/administration/orders/"){
        $(".adm_ordenes").addClass("selected");
        $(".title-page").html("Ordenes realizadas");
    }
    else if(window.location.pathname=="/administration/groups/"){
        $(".adm_groups").addClass("selected");
        $(".title-page").html("Administración de grupos");
    }
    else if(window.location.pathname=="/administration/create_group/"){
        $(".adm_groups").addClass("selected");
        $(".title-page").html("Registro de grupos");
    }
    else if(window.location.pathname=="/administration/users/"){
        $(".adm_users").addClass("selected");
        $(".title-page").html("Administración de usuarios");
    }
    else if(window.location.pathname=="/administration/create_user/"){
        $(".adm_users").addClass("selected");
        $(".title-page").html("Registro de usuarios");
    }
    else if(window.location.pathname=="/administration/notifications/"){
        $(".adm_notifications").addClass("selected");
        $(".title-page").html("Notificaciones");
    }
}

$(".menu-option").click(function(){
    deleteCookie("view-menu");
    deleteCookie("view-order");
    deleteCookie("edit-contact");
    deleteCookie("getcontactmenu");
    deleteCookie("bkpath");
});

// Boton "volver" de cada modulo.
$(".goback").click(function(){
    window.location.replace(getCookie("bkpath"));
});

/*********************CONFIGURACION DE NOTIFICACIONES***************************************/
$('.ui.checkbox').checkbox();
$('.ui.radio.checkbox').checkbox();

$(".notsettings, .notsetting-2").click(function(){
    $('.ui.modal.notsetting').modal('show');
    loadNotSettings();
});

loadNotSettings();

$(".savenotsetting").click(function(){
    
    var not_way = $('input[name="throughput"]:checked').val();
    var not_sound = $('input[name="gift"]:checked').val() == "on" ? true : false;

    saveNotificationSettings(getCookie("userId"),not_way,not_sound,function(data){
        data = $.parseJSON(data);
        if (data.success) {
            $('.ui.modal.notsetting').modal('hide');
        }
    });
});

$(".cancelnotsetting").click(function(){
    
    $('.ui.modal.notsetting').modal('hide');
});

function loadNotSettings()
{
    getNotificationSettings(getCookie("userId"),function(data){
        data = $.parseJSON(data);
        if(data.data.length > 0){
            var sound = data.data[0].sound == "true" ? true : false;
            $('input[id="n'+data.data[0].not_way+'"]').prop("checked",true);
            $('input[id="notification-sound"]').prop("checked",sound);
        }
        else{
            // set default configuration
            $('input[id="nboth"]').prop("checked",true);
            $('input[id="notification-sound"]').prop("checked",true);
        }
    })
}

/*************************END NOTIFICATION SETTINGS***********************************************************/

/*************************NOTIFICACIONES***********************************************/

var obj = document.createElement("audio");
obj.src="https://kahimyang.com/resources/sound/click.mp3";
obj.volume=0.90;
obj.autoPlay=false;
obj.preLoad=true;       

var timer;
fetchNotifications(true);

function threadNotifications()
{
    timer = setInterval(fetchNotifications, 3000);
}

function fetchNotifications(initial=false){

    clearInterval(timer);

    getNotifications(getCookie("userId"),"true",function(data){
        data  = $.parseJSON(data);
        console.log(data);
        if(data.data.length == 0)
        {
            $(".section_notifications").html("Usted no tiene notificaciones");
        }
        else{

            if(data.newNotifications){

                var newNotifications = 0;

                for (var i=0; i<data.data.length; i++){
                    if(data.data[i].checked == "false")
                        newNotifications++;
                }

                $(".badget.notification-number").html("+"+newNotifications);

                notifications_table(data.data,1,10,$(".section_notifications"),true);
                
                if($('input[name="gift"]:checked').val() == "on")
                    obj.play();
            }
            else{
                // No hay nuevas notificaciones.
                if (initial) {
                    if($(".badget.notification-number").text().length == 0)
                    {
                        var newNotifications = 0;

                        for (var i=0; i<data.data.length; i++){
                            if(data.data[i].checked == "false")
                                newNotifications++;
                        }//alert("s");
                        
                        $(".badget.notification-number").html("+"+newNotifications);
                    }
                }
            }
            
            if (initial)
                notifications_table(data.data,1,10,$(".section_notifications"),true);

            initial = false;
        }
        threadNotifications();
    });
}

function notifications_table(data, page=1, rows=10, parent,admin=hasFullPermission){

    var html = `
        <table class="table_notifications_adm">
            
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


        var notification = "";
        var path = "";

        if (data[i].type == "contact-creation"){
            path = "/administration/create_contact/";
            notification = "<b>"+data[i].ufrom+"</b>, registro un nuevo contacto en el sistema.";
        }
        else if (data[i].type == "contact-suggestion"){
            path = "/administration/create_contact/";
            notification = "<b>"+data[i].ufrom+"</b>, suguiere contacto para ser registrado.";
        }
        else if (data[i].type == "contact-updated"){
            path = "/administration/create_contact/";
            notification = "<b>"+data[i].ufrom+"</b>. Actualizacion de informacion de contacto.";
        }
        else if (data[i].type == "menu-creation"){
            path = "/administration/menu_viewer/";
            notification = "<b>"+data[i].ufrom+"</b>. Creacion de menu.";
        }
        else if (data[i].type == "order-creation"){
            path = "/administration/orders";
            notification = "Orden realizada por:"+"<b>"+data[i].ufrom+"</b>.";
        }
        else if (data[i].type == "order-received"){
            path = "/administration/orders";
            notification = "Orden recibida.";
        }
        else{
            notification = data[i].type;
        }

        // notification checked ?
        var checkeClass = "";
        var hoverTitle = "";
        if (data[i].checked == "false"){
            checkeClass = "unreadednotification";
            hoverTitle = "Notificaciones no leidas.";
        }
        else if (data[i].checked == "true"){
            checkeClass = "readednotification";
            hoverTitle = "Notificaciones leidas.";
        }


        var trows = `<tr id="rows">
                <td class="`+checkeClass+`" title="`+hoverTitle+`">`+(i+1)+`</td>
                <td class="gotomaster no-select" path="`+path+`" notId="`+data[i].id+`" masterId="`+data[i].masterId+`" >`+notification+`</td>
            </tr>`;

        $(".table_notifications_adm").append(trows);
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
        notifications_table(data,$(this).attr('pag'),rows,parent,admin);
    });

    $(".prevpagebutton").click(function(){
        if((page-1) >= 1)
            notifications_table(data,page-1,rows,parent,admin);
    });

    $(".nextpagebutton").click(function(){
        if((page+1) <= pag_count)
            notifications_table(data,page+1,rows,parent,admin);
    });


    $(".gotomaster").click(function(){
        createCookie("bkpath",window.location.pathname,3000);
        createCookie("edit-contact",$(this).attr("masterId"),30000);
        createCookie("view-menu",$(this).attr("masterId"),30000);
        createCookie("view-order",$(this).attr("masterId"),30000);

        setNotificationChecked($(this).attr("notId"),function(){});

        window.location.href=$(this).attr("path");
    });


    if(admin==false)
        $(".table_notifications_adm").find(".removable").remove();

    $('.ui.rating').rating('disable');
}


/*************************END NOTIFICACIONES*******************************************/



function accessType(idtype){
    var access_type = {"1":"admin", "2":"firefighter", "3":"dev"};
    createCookie("urol",access_type[idtype],3000);
}

function getUserInfo(uemail,callback){
    var dic = {
        email: uemail,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

    postData("userinfo/",dic,callback);
}

// Top bar actions
function setBarUserInfo(username,email)
{
    $(".user-name").html(username);
    $(".user-email").html(email);
}

function saveNotificationSettings(userid, notification_way, enable_sound, callback)
{
    var dic = {
        userId: userid,
        not_way: notification_way,
        sound : enable_sound,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }
    console.log(dic);
    postData("savenotsettings/",dic,callback);
}

function getNotificationSettings(userid,callback)
{
    var dic = {
        userId: userid,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

    postData("getnotsettings/",dic,callback);
}

function setNotificationChecked(notId,callback)
{
    var dic = {
        nid: notId,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

    postData("setnotificationchecked/",dic,callback);
}

function getNotifications(userid, autoupd,callback)
{
    var dic = {
        userId: userid,
        autoUpd: autoupd,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

    postData("getnotifications/",dic,callback);
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
    createCookie('urol',null,3000);
    createCookie('uname',null,3000);

}

function deleteCookie(name)
{
	createCookie(name,null,3000);
}

});