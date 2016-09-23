$(document).ready(function(){

	validate = function(element,type){

		if(type == "value"){

			if(element.val().length ==0){
				return false;
			}
			else{
				return true;
			}
		}
		else if(type == "email"){

			if(element.val().indexOf("@intellisys.com.do")==-1 && element.val().indexOf("@cincinnatus.com.do")==-1)
				return false;
			else
				return true;
		}

	}

	$('.message a, #register').click(function(){
        $('form').animate({height: "toggle", opacity: "toggle"}, "slow");
    });

	$(".logIn").click(function(e){
		e.preventDefault();

		if(validate($(".lcorreo"),"value"))
		{
			//if(validate($(".lcorreo"),"email")){

				if($(".lcorreo").val().length==0 || $(".lcontrasena").val().length==0)
				{
					sweetAlert("Campos vacios", "Debe completar todos los campos.", "error");
					return false;
				}

				var dic = {
					  email: $(".lcorreo").val(),
			          pwd: $(".lcontrasena").val(),
			          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
			    }

			    postData("usercredentials/",dic,function(data){

			    	data = $.parseJSON(data);

			    	if(data.exists)
			    	{
			    		var user_rol = data.data[0].rol_id;
			    		var user_email = data.data[0].email;
			    		var user_pwd = data.data[0].password;
			    		var status = data.data[0].status;

			    		if(status=="active")
			    		{
			    			if(user_pwd==$(".lcontrasena").val()){
				    			createCookie('userId',user_email,3000);
				    			createCookie('access-type',user_rol,3000);
				    			window.location.replace("/management");
				    		}
				    		else{
				    			swal({   
				    			   title: "Contraseña incorrecta",
				    			   text: "La contrasena ingresada es incorrecta, por favor intente nuevamente.",   
				    			   type: "info",   showCancelButton: false,   
				    			   closeOnConfirm: false,   
				    			   showLoaderOnConfirm: true, });

				    		//	sweetAlert("Contrasena incorrecta", "Su contrasena es incorrecta, por favor intente nuevamente.", "error");
				    		}
			    		}
			    		else{
			    			sweetAlert("Usuario inactivo", "Debe validar su cuenta", "error");
			    		}
			    	}
			    	else{
			    		sweetAlert("Usuario no encontrado", "Registrese", "error");
			    	}
			    });
			/*}
			else{
				sweetAlert("Dominio de correos incorrecto", "Los dominios validos son “@intellisys.com.do” o “@cincinnatus.com.do”", "error");
			}*/
		}
		else{
			sweetAlert("Campo vacios", "Debe introducir su usuario y contraseña para acceder.", "error");
		}

	});

	$(".signUp").click(function(e){
		e.preventDefault();

		if(validate($(".rcorreo"),"value"))
		{
			if(validate($(".rcorreo"),"email")){

				if($(".rnombre").val().length==0 || $(".rapellido").val().length==0 || 
					$(".rcorreo").val().length==0 || $(".rcontrasena").val().length==0)
				{
					sweetAlert("Campos vacios", "Por favor, complete todos los campos.", "error");
					return false;
				}
				else if($(".rcontrasena").val() != $(".rccontrasena").val())
				{
					sweetAlert("Contraseña no coinciden", "Introduzca la contraseña nuevamente.", "error");
					return false;
				}

				var code = Math.floor((Math.random()*1000000)+1);

				var dic = {
					  name: $(".rnombre").val(),
			          nickname: $(".rapellido").val(),
			          email: $(".rcorreo").val(),
			          pwd:$(".rcontrasena").val(),
			          status: "inactive",
			          rol: "1",
			          valcode:code,
			          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
			    }

			    postData("saveuser/",dic,function(data){

			    	data = $.parseJSON(data);

			    	console.log(data);

			    	if(data.exists)
			    	{
			    		swal({   
				    		title: "Usuario ya ha sido registrado",
				    		text: "Hay un usuario asociado a esta cuenta de correo.",   
				    		type: "info",   showCancelButton: false,   
				    		closeOnConfirm: false,   
				    		showLoaderOnConfirm: true, });
			    	}
			    	else if(data.success){
			    		$(".message a").click();
			    		swal("Registro exitoso", "Por favor, valide su cuenta", "success")
			    	}
			    });
			}
			else{
				sweetAlert("Dominio de correos incorrecto.", "“@intellisys.com.do” o “@cincinnatus.com.do”", "error");
			}
		}
		else{
			sweetAlert("Campo vacio", "Debe introducir una cuenta de correo - dom: “@intellisys.com.do” o “@cincinnatus.com.do”", "error");
		}

	});


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

});