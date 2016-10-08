$(document).ready(function(){

var hasFullPermission = getCookie("urol") == "admin" ? true : false;

checkIfEditusers();
validate_usersForm();

$("#users_form").submit(function(e){
    e.preventDefault();
});

$(".save").click(function(e){
    e.preventDefault();

    var nombre = $("#nombre").val();
    var apellido = $("#apellido").val();
    var rol = $("#rol").val();
    var correo = $("#correo").val();
    var contrasena = $("#contrasena").val();
    var ccontrasena = $("#ccontrasena").val();

    if(nombre.length > 0 && apellido.length > 0 && rol.length > 0 && correo.length > 0 && contrasena.length > 0)
    {
        var code = Math.floor((Math.random()*1000000)+1);

        var dic = {
            name: nombre,
            nickname: apellido,
            rol: rol,
            email: correo,
            pwd: contrasena,
            status: "inactive",
            valcode: code,
            creator: "admin",
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
        }

        // form loading animation
        $("#users_form").addClass("ui loading form segment");

        var action = $(".save").attr("editting") == "false" ? "saveuser/": "updateuser/";
        
        postData(action,dic,function(data){
            data = $.parseJSON(data);

            if(data.success){
                $("#users_form").removeClass("ui loading form segment");
                $("#users_form").addClass("ui form segment");
                if($(".save").attr("editting") == "false")
                    reset_userForm();
            }
            else{
                $("#users_form").removeClass("ui loading form segment");
                $("#users_form").addClass("ui form segment");
            }
        });
    }
    else
    {
        console.log("campos en blanco");
    }
});

$(".reset").click(function(){
    if (hasFullPermission) {
        if($(".save").attr("editting") == "false")
        {
            reset_userForm();
            $(".save").attr("editting","false");
        }
        else
         window.location.href="/administration/users";
    }
    else{
        reset_userForm();
        $(".save").attr("editting","true"); // again
    }
});

function reset_userForm()
{
    $("#nombre").val("");
    $("#apellido").val("");
    $("#rol").val("");
    $("#correo").val("");
    $("#contrasena").val("");
    $("#ccontrasena").val("");
}

function validate_usersForm()
{
    $('.ui.form')
          .form({
            fields: {
              nombre: {
                identifier: 'nombre',
                rules: [
                  {
                    type   : 'empty',
                    prompt : 'Por favor, introduzca el nombre del usuario.'
                  }
                ]
              },
              apellido: {
                identifier: 'apellido',
                rules: [
                  {
                    type   : 'empty',
                    prompt : 'Por favor, introduzca el apellido del usuario.'
                  }
                ]
              },
              rol: {
                identifier: 'rol',
                rules: [
                  {
                    type   : 'minCount[1]',
                    prompt : 'Por favor, introduzca el rol del usuario.'
                  }
                ]
              },
              correo: {
                identifier: 'correo',
                rules: [
                  {
                    type   : 'empty',
                    prompt : 'Por favor, introduzca el correo del usuario.'
                  }
                ]
              },
              contrasena: {
                identifier: 'contrasena',
                rules: [
                  {
                    type   : 'empty',
                    prompt : 'Por favor, introduzca la contrasena del usuario.'
                  }
                ]
              }
            }
          });
}

function checkIfEditusers()
{
    if(getCookie("edit-users") != "-1" && getCookie("edit-users").length > 0)
    {
        $(".save").attr("editting","true");

        var correo = getCookie("edit-users");

        var dic = {
            email: correo,
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
        }

        // form loading animation
        $("#users_form").addClass("ui loading form segment");

        postData("userinfo/",dic,function(data){
            data = $.parseJSON(data);

            if(data.data.length == 1){
                $("#users_form").removeClass("ui loading form segment");
                $("#users_form").addClass("ui form segment");
                $("#correo").val(data.data[0].email);
                $("#rol").val(data.data[0].rol);
                $("#nombre").val(data.data[0].first_name);
                $("#apellido").val(data.data[0].last_name);
                $("#contrasena").val(data.data[0].password);
                $("#ccontrasena").val(data.data[0].password);
            }
            else{
                $("#users_form").removeClass("ui loading form segment");
                $("#users_form").addClass("ui form segment");
                console.log("users id no encontrado.");
            }
        });

        if (hasFullPermission)
            deleteCookie("edit-users");
    }
    else
    {
        $(".save").attr("editting","false");
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
	createCookie(name,"-1",3000);
}

});