$(document).ready(function(){

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
    createCookie("edit-users",getCookie("userId"),3000);
    $(".adm_users a").attr("href","/administration/create_user");
    $(".adm_users a").html("Mi Cuenta");
    $(".title-page").html("Informacion personal");
}
else{
     $(".adm_users a").attr("href","/administration/users");
     $(".adm_users a").html("Adm. de usuarios");
}

/*************************************************************/

function activeUserNavigationButtons()
{
    if(window.location.pathname=="/administration/contacts/"){
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
}

/************************************************************/
$(".notsettings").click(function(){
    $('.ui.modal').modal('show');
});

function accessType(idtype){
    var access_type = {"1":"admin", "2":"firefighter", "3":"dev"};
    createCookie("urol",access_type[idtype],3000);
}

function getUserInfo(uemail,callback){
    var dic = {
        email: uemail,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("userinfo/",dic,callback);
}

// Top bar actions
function setBarUserInfo(username,email)
{
    $(".user-name").html(username);
    $(".user-email").html(email);
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