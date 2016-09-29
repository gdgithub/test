$(document).ready(function(){

activeUserNavigationButtons();

getUserInfo(getCookie("userId"),function(data){
    data = $.parseJSON(data);
    if(data.exists)
    {
        setBarUserInfo(data.data[0].status,getCookie("userId"));
    }
});

/*************************************************************/

function activeUserNavigationButtons()
{
    if(window.location.pathname=="/administration/contacts/"){
        $(".adm_contactos").addClass("selected");
        $(".title-page").html("Administracion de contactos");
    }
    else if(window.location.pathname=="/administration/create_contact/"){
        $(".adm_contactos").addClass("selected");
        $(".title-page").html("Registro de contactos");
    }
    else if(window.location.pathname=="/administration/contact_categories/"){
        $(".adm_contactos").addClass("selected");
        $(".title-page").html("Administracion de categorias");
    }
    else if(window.location.pathname=="/administration/menu/"){
        $(".adm_menu").addClass("selected");
        $(".title-page").html("Administracion de menu");
    }
    else if(window.location.pathname=="/administration/create_menu/"){
        $(".adm_menu").addClass("selected");
        $(".title-page").html("Registro de menu");
    }
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