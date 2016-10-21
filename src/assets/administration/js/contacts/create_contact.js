$(document).ready(function(){

var hasFullPermission = getCookie("urol") == "admin" ? true : false;

validate_contactForm();
setCategories_contactForm();
checkIfEditContact();

$("#contact_form").submit(function(e){
    e.preventDefault();
});

$(".save").click(function(e){
    e.preventDefault();

    var uid = getCookie("userId");
    var rnc = $("#rnc").val();
    var categoria = $("#categoria").val();
    var nombre = $("#nombre").val();
    var telefono = $("#telefono").val();
    var direccion = $("#direccion").val();
    var descripcion = $("#descripcion").val();
    var estado = hasFullPermission == true ? "active": "inactive";

    if(rnc.length > 0 && categoria.length > 0 && nombre.length > 0 && telefono.length > 0 && direccion.length > 0)
    {
        var dic = {
            userId: uid,
            rnc: rnc,
            category: categoria,
            name: nombre,
            phone: telefono,
            address: direccion,
            description: descripcion,
            status: estado,
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
        }

        // form loading animation
        $("#contact_form").addClass("ui loading form segment");

        var action = $(".save").attr("editting") == "false" ? "createcontact/": "updatecontact/";
        
        postData(action,dic,function(data){
            data = $.parseJSON(data);
            console.log(data);

            if(data.success){
                $("#contact_form").removeClass("ui loading form segment");
                $("#contact_form").addClass("ui form segment");
                //  $(".message").html("La informacion ha sido registrada exitosamente.");
                if($(".save").attr("editting") == "false")
                    reset_contactForm();
            }
            else{
                $("#contact_form").removeClass("ui loading form segment");
                $("#contact_form").addClass("ui form segment");
                  //  $(".message").html("Ocurrio un error al momento de registrar la informacion.");
            }
        });
    }
    else
    {
        console.log("campos en blanco");
    }
});

$(".reset").click(function(){
    if($(".save").attr("editting") == "false")
        reset_contactForm();
    else
     window.location.href="/administration/contacts";
    
});

function reset_contactForm()
{
    $("#rnc").val("");
    $("#categoria").val("");
    $("#nombre").val("");
    $("#telefono").val("");
    $("#direccion").val("");
    $("#descripcion").val("");

    $(".save").attr("editting","false");
}

function validate_contactForm()
{
    $('.ui.form')
          .form({
            fields: {
              rnc: {
                identifier: 'rnc',
                rules: [
                  {
                    type   : 'empty',
                    prompt : 'Por favor, introduzca el RNC del contacto.'
                  }
                ]
              },
              categoria: {
                identifier: 'categoria',
                rules: [
                  {
                    type   : 'minCount[1]',
                    prompt : 'Por favor, seleccione la categoria.'
                  }
                ]
              },
              nombre: {
                identifier: 'nombre',
                rules: [
                  {
                    type   : 'empty',
                    prompt : 'Por favor, introduzca el nombre del contacto.'
                  }
                ]
              },
              telefono: {
                identifier: 'telefono',
                rules: [
                  {
                    type   : 'empty',
                    prompt : 'Por favor, introduzca el numero de telefono del contacto.'
                  },
                  {
                    type   : 'number',
                    prompt : 'El numero de telefono debe ser de {ruleValue} caracteres.'
                  }
                ]
              },
              direccion: {
                identifier: 'direccion',
                rules: [
                  {
                    type   : 'empty',
                    prompt : 'Por favor introduzca la direccion del contacto.'
                  }
                ]
              }
            }
          });
}

function checkIfEditContact()
{
    if(getCookie("edit-contact") != "-1" && getCookie("edit-contact") != "null")
    {
        $(".save").attr("editting","true");

        var cid = [];
        cid.push(getCookie("edit-contact"));

        var dic = {
            id: cid.join("|"),
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
        }

        // form loading animation
        $("#contact_form").addClass("ui loading form segment");

        postData("getcontactswithid/",dic,function(data){
            data = $.parseJSON(data);

            if(data.data.length == 1){
                $("#contact_form").removeClass("ui loading form segment");
                $("#contact_form").addClass("ui form segment");
                $("#rnc").val(data.data[0].rnc);
                $("#categoria").val(data.data[0].category);
                $("#nombre").val(data.data[0].name);
                $("#telefono").val(data.data[0].phone);
                $("#direccion").val(data.data[0].address);
                $("#descripcion").val(data.data[0].description);
            }
            else{
                $("#contact_form").removeClass("ui loading form segment");
                $("#contact_form").addClass("ui form segment");
                console.log("contact id no encontrado.");
            }
        });

        deleteCookie("edit-contact");
    }
    else
    {
        $(".save").attr("editting","false");
    }
}

function setCategories_contactForm()
{
    var dic = {
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getcontactscategories/",dic,function(data){
        data = $.parseJSON(data);
        if(data.data)
        {
            $("#categoria").html("");

            for(var i=0; i < data.data.length; i++)
            {
                $("#categoria").append(`<option value="`+data.data[i].description+`">`
                    +data.data[i].description+`</option>`);
            }
        }
        else{
            alert("error al cargar categorias");
        }
    });
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