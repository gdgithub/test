$(document).ready(function(){


    // Menu iterations
  	$("#menu li").click(function(){
		//var content_name = $(this).attr("id") + ".html"; 

    $("#new-contact-modal").modal("show");
	 });


    // Contacts DataTable - Settings
    $("#contacts_table").DataTable({
        "iDisplayLength": 10,
          "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "Todos"]],

        "oLanguage": {
          "oPaginate": {
            "sPrevious": "Anterior",
            "sNext": "Siguiente",
            "sLast": "Ultima pagina",
            "sFirst": "Primera pagina",
            "sEmptyTable": "No hay datos disponibles en la tabla.",
            "sInfoEmpty": "No hay registros para mostrar.",
            "sInfo": "Obtuvo un total de _TOTAL_ registros para mostrar (_START_ to _END_)",
            "sSearch": "Registros filtrados:",
            "sZeroRecords": "No hay registros para mostrar.",
            "sLoadingRecords": "Por favor espere - cargando...",
            "sLengthMenu": 'Display <select>'+
                '<option value="10">10</option>'+
                '<option value="20">20</option>'+
                '<option value="30">30</option>'+
                '<option value="40">40</option>'+
                '<option value="50">50</option>'+
                '<option value="-1">Todos</option>'+
                '</select> records'
          }
        }
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
          name: $("#contact_name").val(),
          address: $("#contact_address").val(),
          phone: $("#contact_phone").val(),
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
      }

      var post_success = postData("save/create/",dict,$(".alert-success"));



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


function postData(url,vars,msg_element)
{
  $.ajax({
      type:"POST",
          url:url,
          data: vars,
          success: function(data){
              msg_element.html(data);
              msg_element.show();
              //posted = true;
          }
  });
}


function isValidInput(text,valkey)
{
  if (text.length > 0) {

    return true;
  }

  return false;
}




