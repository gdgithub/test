$(document).ready(function(){


    // Menu iterations
  	$("#newContactBtn").click(function(){
		//var content_name = $(this).attr("id") + ".html"; 

    $("#new-contact-modal").modal("show");
	 });

    getCategories();


    // Contacts DataTable - Settings
    $("#contacts_table, #users_table").DataTable({
        "iDisplayLength": 10,
          "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "Todos"]],

        "oLanguage": {
          "oPaginate": {
            "sPrevious": "Anterior",
            "sNext": "Siguiente",
            "sLast": "Ultima pagina",
            "sFirst": "Primera pagina",
          },
            "sEmptyTable": "No hay datos disponibles en la tabla.",
            "sInfoEmpty": "No hay registros para mostrar.",
            "sInfo": "Obtuvo un total de _TOTAL_ registros para mostrar (_START_ a _END_)",
            "sSearch": "Buscar:",
            "sZeroRecords": "No hay registros para mostrar.",
            "sLoadingRecords": "Por favor espere - cargando...",
            "sLengthMenu": 'Mostrar <select>'+
                '<option value="10">10</option>'+
                '<option value="20">20</option>'+
                '<option value="30">30</option>'+
                '<option value="40">40</option>'+
                '<option value="50">50</option>'+
                '<option value="-1">Todos</option>'+
                '</select> registros'
          
        }
    });

    $("#addBranchInfo").click(function(){

        $("#f").append(
          '<div class="field">'
              +'<label>Telefono</label>'
              +'<input placeholder="Username" name="ctelefono" id="ctelefono" type="text">'
            +'</div>'
            +'<div class="field">'
              +'<label>Direccion</label>'
              +'<input type="text" name="cdireccion" id="cdireccion">'
            +'</div>'
            );
    });




  $('.ui.form')
  .form({
    fields: {
      crnc: {
        identifier: 'crnc',
        rules: [
          {
            type   : 'empty',
            prompt : 'Por favor, introduzca el RNC del contacto.'
          }
        ]
      },
      ccategoria: {
        identifier: 'ccategoria',
        rules: [
          {
            type   : 'minCount[1]',
            prompt : 'Por favor, seleccione la categoria.'
          }
        ]
      },
      cnombre: {
        identifier: 'cnombre',
        rules: [
          {
            type   : 'empty',
            prompt : 'Por favor, introduzca el nombre del contacto.'
          }
        ]
      },
      cimagen: {
        identifier: 'cimagen',
        rules: [
          {
            type   : 'empty',
            prompt : 'Por favor, introduzca la direccion del logo.'
          }
        ]
      },
      ctelefono: {
        identifier: 'ctelefono',
        rules: [
          {
            type   : 'empty',
            prompt : 'Por favor, introduzca el numero de telefono de la sucursal.'
          },
          {
            type   : 'minLength[10]',
            prompt : 'El numero de telefono debe ser de {ruleValue} caracteres.'
          }
        ]
      },
      cdireccion: {
        identifier: 'cdireccion',
        rules: [
          {
            type   : 'empty',
            prompt : 'Por favor introduzca la direccion de la sucursal.'
          }
        ]
      }
    }
  })
;


/**User Form**/
$('.ui.form')
  .form({
    fields: {
      unombre: {
        identifier: 'unombre',
        rules: [
          {
            type   : 'empty',
            prompt : 'Por favor, introduzca el nombre del usuario.'
          }
        ]
      },
      uapellido: {
        identifier: 'uapellido',
        rules: [
          {
            type   : 'empty',
            prompt : 'Por favor, introduzca el apellido del usuario.'
          }
        ]
      },
      udireccion: {
        identifier: 'udireccion',
        rules: [
          {
            type   : 'empty',
            prompt : 'Por favor, introduzca la direccion del usuario.'
          }
        ]
      },
      ucorreo: {
        identifier: 'ucorreo',
        rules: [
          {
            type   : 'empty',
            prompt : 'Por favor, introduzca el correo para la autenticacion del usuario.'
          }
        ]
      },
      ucontrasena: {
        identifier: 'ucontrasena',
        rules: [
          {
            type   : 'empty',
            prompt : 'Por favor, introduzca la contrasena para la autenticacion del usuario.'
          }
        ]
      },
      crol: {
        identifier: 'crol',
        rules: [
          {
            type   : 'minCount[1]',
            prompt : 'Por favor, introduzca el rol del usuario.'
          }
        ]
      }
    }
  })
;


$("#saveContact").click(function(){

    var dict = {
          rnc: $("#crnc").val(),
          nombre: $("#cnombre").val(),
          categoria: $("#ccategoria").val(),
          desc: $("#cdescripcion").val(),
          imagen: $("#cimagen").val(),
          telefono: $("#ctelefono").val(),
          direccion: $("#cdireccion").val(),
          status: 'enable',
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
      }

      postData("save/create/",dict,function(data){
       
        alert("saved");
      });
});


$("#delContact").click(function(){

  alert($(this));

    var dict = {
          id: $(this).attr("data-val"),
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

    var c = confirm("Desea eliminar este contacto?");

    if (c == true) {
      postData("directories/delete/",dict,function(data){
        location.reload();
      });
    }
     
});


$("#saveUser").click(function(e){
  
  e.preventDefault();

    var dict = {
          nombre: $("#unombre").val(),
          apellido: $("#uapellido").val(),
          direccion: $("#udireccion").val(),
          correo: $("#ucorreo").val(),
          contrasena: $("#ucontrasena").val(),
          rol: $("#urol").val(),
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
      }

      console.log(dict);

      postData("saveUser/",dict,function(data){
       
        location.reload();
      });
});






    

    // Add Contacts section

    $("#contacts-add").animate({'opacity':0.0},200);
    $("#contacts-add").hide();

	// New/Save contact button
    $("#cont-new").click(function(e){

		if($(this).attr('value') == "Nuevo")
		{
        	$("#contancts-div").animate({'opacity':0.0},200);
        	$("#contacts-add").animate({'opacity':1.0},200);
        	$("#contancts-div").hide();
        	$("#contacts-add").show();
			$(this).html("Guardar");
			$(this).attr("value","Guardar");
            $(this).attr("class","btn btn-success");
            $(".alert-success").hide();
		}
		else if($(this).attr('value') == "Guardar")
		{
			e.preventDefault();

			$(this).html("Nuevo");
			$(this).attr("value","Nuevo");
            $(this).attr("class","btn btn-info");


      var dict = {
          rnc: $("#crnc").val(),
          nombre: $("#cnombre").val(),
          categoria: $("#ccategoria").val(),
          desc: $("#cdescripcion").val(),
          imagen: $("#cimagen").val(),
          telefono: $("#ctelefono").val(),
          direccion: $("#cdireccion").val(),
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
      }

      var post_success = postData("save/create/",dict,function(data){
        alert("saved");
      });



      /*if(post_success)
      {
        alert("sdf");
        $("#contact_name").val() = "";
        $("#contact_address").val("");
        $("#contact_phone").val("");
      }*/



 			   /* $.ajax({
                 type:"POST",
                 url:"save/create/",
                 data: {
                   	   	name: $("#contact_name").val(),
						            address: $("#contact_address").val(),
                        phone: $("#contact_phone").val(),
						            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()	
                 },
                 success: function(data){
            
					$(".alert-success").html(data);
                    $(".alert-success").show();
                 }
            });*/
		}




         var typeahead_data = [];
        function get_client_names() {
            $.ajax({
                url: "/lookup",
                success: function (data) {
                    $.each(data, function (key, value) {
                        typeahead_data.push(value.toString());
                    });
                    // assign the array to my typeahead tag
                    $('.typeahead').typeahead({
                        source: typeahead_data,
                    });
                }
            });
        }
        $(function () {
            get_client_names();
        });



    })

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



function isValidInput(text,valkey)
{
  if (text.length > 0) {

    return true;
  }

  return false;
}

function getCategories()
{
    var dic = {
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

    postData('directories/getCategories/',dic,function(data){

        if(data)
        {
            categories = $.parseJSON(data);

            for(var i = 0; i < categories.length; i++)
            {
                $('<option>').val(categories[i].description).text(categories[i].description)
                .appendTo('#ccategoria');
            }
        }
    });
}



