$(document).ready(function(){

	var menuBar = $(".menu-bar");

	confirmAuth();

$('.ui.dropdown')
      .dropdown();

jQuery(window).load(function () {
	
	if(window.location.pathname == "/management/")
	{
		window.location.assign("/management/orders/");
	}
	else if(window.location.pathname == "/management/orders/")
	{
		if (getCookie("access-type") == 2) 
		{
			// El usuario ya ha sido autenticado. DEV
			// Carga tabla con los pedidos realizados por el mismo usuario.

			$("#order_loader").show();

			var userId = getCookie("userId");

			createOrderTableForUserWithId(userId);

			initializeSearcher();
		}
		else if(getCookie("access-type") == 3)
		{
			// Usuario FF.
		}
	}
	else if(window.location.pathname == "/management/group/")
	{
		

		if (getCookie("access-type") == 1) 
		{
			// Usuario admin: Guarda sugerencia enable
			getGroups(getCookie('userId'),getCookie("access-type"));
		}
		else
		{	
			getGroupMembers(getCookie('userId'),getCookie("access-type"));
		}
	}
	else if(window.location.pathname == "/management/suggest/")
	{
		getCategories();

		validate_suggestForm();

		if (getCookie("access-type") == 1) 
		{
			// Usuario admin: Guarda sugerencia enable
			$("#show_contact_list").css({opacity:'1.0'});

			setContactTableSetting();

		}
		else
		{
			$("#show_contact_list").css({opacity:'0.0'});
		}

	}
	else if(window.location.pathname == "/management/myinfo/")
	{
		validate_userForm();
		validate_changePassForm();
		load_userFormData(getCookie('userId'));
	}

});

	$("#search_contact").click(function(e){

	    findContact(e,true);
	});


	// getting branch menu
    $('#sucursal_select').change(function(){
        
         getBranchMenu($('option:selected', this).attr('branch-id'));
    });

    $("#addToOrderList").click(function(){

    	var clear_menu = false;

        $("#MenuSelect option").each(function(t)
        {
            if($(this).is(":selected"))
            {
                if(parseInt($("#tcantidad").val()) > 0)
                {
                    var data = "("+$("#tcantidad").val()+")-"+$(this).val();

                    $("#text_description").val($("#text_description").val()+data+"\n");
                    clear_menu = true;
                }
                else
                {
                	alert("Indique la cantidad");
                	clear_menu = false;
                }
            }
        });
        
        if (clear_menu) {
        	$('#MenuSelect').dropdown('clear');
        }
        
    });

    $("#text_comentario").keypress(function(){
    	$("#text_description").val($("#text_description").val()+"\n\n"+":: "+$(this).val());
    });

    $("#doRequest").click(function(){

        var request = $("#text_description").val();

        if(request.length > 0)
        {
            // hace la solicitud del pedido.
            if(!$('option:selected', "#sucursal_select").attr('branch-id'))
            {
            	alert("error: no branch id");
            	return;
            }

            var dic = {
                csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
                userId: getCookie('userId'),
                branchId: $('option:selected', "#sucursal_select").attr('branch-id'),
                dataOrder: request,
                status: "active"
            }

            postData('directories/createOrder/',dic,function(data){

				createOrderTableForUserWithId(getCookie("userId"));
				show_alert("success","El pedido se ha realizado exitosamente.",3000);
            });
        }
        else
        {
        	alert("No request");
        } 
    });

    /**Grupos**/
    $("#addGruopForm").submit(function(e){
		e.preventDefault();
	});
    
    $("#newMember").click(function(){

    	var obj = $("#addGruopForm").find(".content");
		
		obj.append(`
			<div class="two fields">
			  	<div class="field">
			      <input placeholder="Ej. Juan Perez / Jp1592" name="gmiembro" id="gmiembro" type="text">
			    </div>
			   <div class="delrow">
			      <div class="ui submit button delGroupRow" id="delGroupRow">X</div>
			   </div>
			  </div>
			`);

		$(".delGroupRow").click(function(){

			$(this).parent().parent().remove();
		});
    });

    $("#saveGroup").click(function(){

		var members = [];

		$(".content > .fields").each(function(i,element){
			
			members.push($(element).find(".field").find('#gmiembro').val());
		});

		var dic = {
	          gname: $("#gnombre").val(),
	          gff: $("#gencargado").val(),
	          gmembers : members.join("|"),
	          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
	    }

	     postData('createGroup/',dic,function(data){

	     	/*data = $.parseJSON(data);*/

	     	if(data)
	     	{
	     		getGroups(getCookie('userId'),getCookie('access-type'));
	     		show_alert("success","Grupo creado.",3000);
	     	}
			
         });

		//$(".gruop_info").attr('members',members.join("|"));
		//$(".gruop_info").attr('groupName',$("#gnombre").val());
	});


    /**Sugerencia**/
    $("#suggest_form, #addContactBranchForm, #addBranchMenuForm").submit(function(e){
		e.preventDefault();
	});

    $("#saveContact").click(function(){

	    var dict = {
	          rnc: $("#crnc").val(),
	          nombre: $("#cnombre").val(),
	          categoria: $("#ccategoria").val(),
	          desc: $("#cdescripcion").val(),
	          imagen: $("#cimagen").val(),
	          //telefono: $("#ctelefono").val(),
	          //direccion: $("#cdireccion").val(),
	          telefono: $(".branches_info").attr('phones'),
	          direccion: $(".branches_info").attr('address'),
	          menu_desc: $(".menu_info").attr('description'),
	          menu_price: $(".menu_info").attr('price'),
	          status: getCookie('access-type') == 1 ? 'enable' :'disable',
	          userRol: getCookie('access-type'),
	          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
	      }

	      postData("suggest_contact/",dict,function(data){
	       
	       data = $.parseJSON(data);

	       if (data.s) {

		       	$('#suggest_form').form('clear');

		        show_alert("success",data.s,3000,$("#alert_msg"));
	       }
	       else if (data.f){
	       		show_alert("danger",data.f,3000,$("#alert_msg"));
	       }
	       else if(data.a)
	       {
	       		show_alert("danger",data.a,3000,$("#alert_msg"));
	       }
	       
	      });
	});

	$("#reset_Suggest_Form").click(function(){
		$('#suggest_form').form('clear');
	});

	/*Sugerencias admin-area*/
	$(".editContact").click(function(){

		var contactId = $(this).find("i").attr("data-val");

		if (!contactId) {
			alert("Error: No contact id provided.");
			return;
		}
		else
		{
			load_contactForm(contactId);
		}

	});

	$(".delContact").click(function(){

		var contactId = $(this).find("i").attr("data-val");

		if (!contactId) {
			alert("Error: No contact id provided.");
			return;
		}
		else
		{
			if(confirm("Desea eliminar este contacto?"))
				deleteContact(contactId);
		}
	});

	$(".newBranch").click(function(){

		var obj = $("#addContactBranchForm").find(".content");

		//var rowid = $(".fields > .delrow").length;
		
		obj.append(`
			<div class="two fields">
			  	<div class="field">
			      <input placeholder="Ej. 809-222-1163" name="btelefono" id="btelefono" type="text">
			    </div>
			    <div class="field">
			      <input placeholder="Direccion" name="bdireccion" id="bdireccion" type="text">
			   </div>
			   <div class="delrow">
			      <div class="ui submit button delBranchRow" id="delrowbtn">X</div>
			   </div>
			  </div>
			`);

		$(".delBranchRow").click(function(){

			$(this).parent().parent().remove();
		});
	});

	$("#saveBranches").click(function(){

		var phone = [];
		var address = [];

		$(".content > .fields").each(function(i,element){
			
			phone.push($(element).find(".field").find('#btelefono').val());	
			address.push($(element).find(".field").find('#bdireccion').val());
		});

		$(".branches_info").attr('phones',phone.join("|"));
		$(".branches_info").attr('address',address.join("|"));
	});

	$(".newMenu").click(function(){

		var obj = $("#addBranchMenuForm").find(".content_m");
		
		obj.append(`
			<div class="two fields">
			  	<div class="field">
			      <input placeholder="Descripcion" name="mdescripcion" id="mdescripcion" type="text">
			    </div>
			    <div class="field">
			      <input placeholder="Precio" name="mprecio" id="mprecio" type="text">
			   </div>
			   <div class="delrow">
			      <div class="ui submit button delMenuRow" id="delrowbtn">X</div>
			   </div>
			  </div>
			`);

		$(".delMenuRow").click(function(){

			$(this).parent().parent().remove();
		});
	});
	
	$("#saveMenues").click(function(){

		var desc = [];
		var price = [];

		$(".content_m > .fields").each(function(i,element){
			
			desc.push($(element).find(".field").find('#mdescripcion').val());	
			price.push($(element).find(".field").find('#mprecio').val());
		});

		$(".menu_info").attr('description',desc.join("|"));
		$(".menu_info").attr('price',price.join("|"));
	});


	/**Mis datos**/
    $("#userForm").submit(function(e){
		e.preventDefault();
	});

	$("#saveUserInfo").click(function(){

		var values = $("#userForm").form('get values');

		var dict = {
	          correo: values.ucorreo,
	          nombre: values.unombre,
	          apellido: values.uapellido,
	          direccion: values.udireccion,
	          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
	      }

	    postData("updateUserInfo/",dict,function(data){
	       
	       if(data)
	       {
	       		show_alert("success","La informacion se ha actualizado correctamente.",3000);
	       }
	       else{
	       		show_alert("danger","Ha ocurrido un error durante la actualizacion de la informacion. Por favor, intentelo nuevamente.",3000);
	       }
	        
	      });
	});


	/*Cambiar contrasena*/
	$("#changePassForm").submit(function(e){
		e.preventDefault();
	});

	$("#changePassword").click(function(){

		var values = $("#changePassForm").form('get values');

		if (values.ncontrasena == values.ccontrasena && getCookie('userId')) {

			var dict = {
	          correo: getCookie('userId'),
	          ncontrasena: values.ncontrasena,
	          acontrasena: values.acontrasena,
	          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
	      	}

		    postData("changepwd/",dict,function(data){
		       
		       if(data == 1)
		       {
		       		show_alert("success","Contrasena actualizada correctamente.",3000, $("#alert_changePass"));
		       }
		       else{
		       		show_alert("danger","Ha ocurrido un error durante la actualizacion de la contrasena. Por favor, intentelo nuevamente.",5000, $("#alert_changePass"));
		       }
		     
		      });
		}
		else
		{
			show_alert("warning","Confirme su nueva contrasena.",3000,$("#alert_changePass"));
		}

	});	


function initializeSearcher()
{
    var dic = {
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

    postData('directories/getContactsName/',dic,function(names){

        contacts_name = $.parseJSON(names);
        var name = [];

        for(var i = 0; i < contacts_name.length; i++)
        {
            name.push({title:contacts_name[i].name});
        }

        $('.ui.search')
          .search({
            source: name,
            searchFields: ['title'],
            searchFullText: false,
            error : {
              source      : 'Cannot search. No source used, and Semantic API module was not included',
              noResults   : 'Su busqueda no obtuvo resultados',
              logging     : 'Error in debug logging, exiting.',
              noTemplate  : 'A valid template name was not specified.',
              serverError : 'There was an issue with querying the server.',
              maxResults  : 'Results must be an array to use maxResults setting',
              method      : 'The method you called is not defined.'
            }
          });
    });
}

function reorder(id,userId)
{
	// Reordena el pedido.

	var dic = {
          orderId: id,
          userId: userId,
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

    postData('reorder/',dic,function(data){

		data = $.parseJSON(data);

		if(data.data)
		{
			show_alert("warning","El pedido success.",3000);
			createOrderTableForUserWithId(userId);
		}
		else{
			show_alert("danger","No se ha podido reenviar el pedido.",3000);
		}
	});
}

function cancelOrder(id,userId)
{
	var dic = {
          orderId: id,
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

    postData('cancelOrder/',dic,function(data){

		data = $.parseJSON(data);

		if(data.data)
		{
			show_alert("warning","La orden ha sido cancelada.",3000);
			createOrderTableForUserWithId(userId);
		}
		else{
			show_alert("danger","Error: No se ha podido cancelar la orden.",5000);
		}
	});
}

function createOrderTableForUserWithId(id)
{
	var dic = {
          userId: id,
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

	postData('getUserOrders/',dic,function(data){

		// Retorna los pedidos realizados por el usuario

		data = $.parseJSON(data);

		if(data)
		{
			constructTableWithData(data,5,1);
			$("#order_loader").hide();
		}
		else{
			show_alert("danger","Error: no data fetched -(consulta de pedidos).",5000);
		}
		
	});
}


function constructTableWithData(data,display_n=10,current_page=1,pg=true,dpg="")
{
	console.log(data);
	var container = $(".data");

	var pagination = dpg;
	var page_number = 0;

	var html = `
	<table class="orders_table">
		<tr>
			<th>#</th>
			<th>Usuario</th>
			<th>Descripcion de los pedidos</th>
			<th>Estado</th>
			<th>Fecha</th>
			<th>Acciones</th>
		</tr>
	`;

	if (data.length == 0) {
		html = "<p class='notFound'>No ha realizado ningún pedido.</p>";
	}

	for(var i=(display_n*(current_page-1)); i<data.length; i++)
	{
		if (i < (display_n*current_page)) {

			var color = data[i].fields.status == "active" ? "rgb(200,220,100)" : "";
			color = data[i].fields.status == "received" ? "rgb(100,220,100)" : color;
			color = data[i].fields.status == "banned" ? "rgb(255,200,100)" : color;

			html += `
			<tr>
				<td id="tdnumrow">`+( i+1)+`</td>
				<td><p title="`+data[i].fields.userId+`">`+data[i].fields.userId+`</p></td>
				<td>
					<div id="order_div" style="background-color: `+color+`;">
						<p>`+data[i].fields.description.replace(/\n/g, "<br />")+`</p>
					</div>
				</td>
				<td>`+status_trans(data[i].fields.status)+`</td>
				<td>`+data[i].fields.date+`</td>
				<td>
					<ul style="display:inline-flex ">
						<li><i class="reply icon" orderId="`+data[i].pk+`" title="Volver a pedir"></i></li>
						<li><i class="remove circle icon" orderId="`+data[i].pk+`" title="Cancelar pedido"></i></li>
					</ul>
				</td>
			</tr>
			`;
		}
	
		if(i >= (display_n * page_number) && pg)
		{
			page_number++;

			if(page_number == 1)
			{
				pagination += `
			    <li><a class="previous_page">Anterior</a></li>
				`;
			}

			pagination += `
			    <li><a class="show_page" page_number="`+page_number+`">`+page_number+`</a></li>
			`;	
		}
	}

	if(data.length >= 1 && pg)
	{
		if(page_number > 1)
		{
			pagination += `
				<li><a class="next_page">Siguiente</a></li>
			`;
		}
		else{
			pagination += `
				<li class="disabled"><a >Siguiente</a></li>
			`;
		}
	}

	html += "</table>";

	html += `<table class="pagination_tb">
		<tr>
			<td>
	  			<ul class="pagination">
	    			`+pagination+`
	  			</ul>
	  		</td>
	  	</tr>
	  </table>`;

	container.html(html);

	$(".previous_page").click(function(){

		if (current_page-1 == 0) return;
		else if (current_page-1 == 1) {
			$(this).prop('disabled',true);
		}

		constructTableWithData(data,display_n,parseInt(current_page)-1,false,pagination);
	});

	$(".next_page").click(function(){
 
		constructTableWithData(data,display_n,parseInt(current_page)+1,false,pagination);
	});

	$(".show_page").click(function(){

		constructTableWithData(data,display_n,parseInt($(this).attr('page_number')),false,pagination);
	});

	$(".reply").click(function(){

    	reorder($(this).attr('orderId'), getCookie('userId'));
    });

    $(".remove").click(function(){

    	cancelOrder($(this).attr('orderId'), getCookie('userId'));
    });
}


function status_trans(status)
{
	var trans = {'received':'Recibido','active':'Activo','banned':'Cancelado'};

	return trans[status];
}

function show_alert(type,msg,delay,obj=false)
{
	var alert;
	if(!obj)
		alert = $("#alert");
	else
		alert = obj;

	alert.addClass("alert alert-"+type+"");
	alert.html(msg);
	alert.show();

	setTimeout(function(){ alert.hide(); }, delay);
}


function confirmAuth()
{
	if(getCookie('userId').length > 0 && getCookie('userId') != 'null')
	{
		$("#auth-side").html(
			'<ul><a class="close_sesion"><li>Cerrar Sesión</li></a></ul>'
			+$("#auth-side").html()
		);

		// Crea el menu de acuerdo con los permisos del usuario
		createMenu(getCookie('access-type'));

		$(".close_sesion").click(function(){
			deleteCookies();
			window.location.assign("/index");
		});
	}
	else
	{
		window.location.assign("/index");
	}
}

function createMenu(userRol)
{
	if(userRol == 2)
	{
		//FF user
		/*menuBar.html(
			'<ul>'
				+'<li id=""><a href="notifications">Mis pedidos</a></li>'
				+'<li id=""><a href="notifications">Mis Datos</a></li>'
				+'<li id=""><a href="notifications">Mis pedidos</a></li>'
			+'</ul>'
		);*/
	}
	else if(userRol == 3)
	{
		//Dev user
		/*menuBar.html(
			'<ul>'
				+'<li id=""><a href="notifications">Pedidos</a></li>'
			+'</ul>'
		);*/
	}
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
            
             $('.ui.dropdown').dropdown();
        }
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
}



});



// JS

function postData(url,vars,callback)
{
  $.ajax({
      type:"POST",
          url:url,
          data: vars,
          success: callback
  });
}



function findContact(e,f=false)
{
    if(e.which == 13 || f) {
        
        //$("#directory_loader").show();

        var dic = {
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
            name:$("#tsearch").val()
        }

        postData('directories/findContact/',dic,function(data){

            data = $.parseJSON(data);

            if (data) 
            {   
               getBranchForContactId(data[0].id);
            }
            else
            {

                alert("no data found");
            }
        });
    }
}

function getBranchForContactId(id)
{
	$('#sucursal_select').html('<option value="">Sucursales</option>');

	var dic = {
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
		contactId: id
    }

	postData('directories/getContactBranches/',dic,function(result){

        // Contiene  la informacion de las sucursales del contacto
       var branch_info = $.parseJSON(result);

       for(var i = 0; i < branch_info.length; i++)
       {
            var branchName = name + " ( "+branch_info[i].address+" ) ";

            // Dropdown sucursales
            $('<option>').val(branchName).text(branchName)
            .attr("branch-id",branch_info[i].id)
            .appendTo('#sucursal_select');
       }
    });
}

function getBranchMenu(branchid)
{
	$("#MenuSelect").html("");

        var branchId = $('option:selected', this).attr('branch-id');

        var dic = {
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
            branchId: branchid
        }
        
        postData('directories/getBranchMenu/',dic,function(result){

            var menu = $.parseJSON(result);
            var menu_content = $("#MenuSelect");
            
            for(var i = 0; i < menu.length; i++)
            {
                $('<option>').val(menu[i].description).text(menu[i].description+' - (RD$: '+menu[i].price+')')
                .appendTo(menu_content);
            }

            $("#menu_content").html("");
        }); 
}

function validate_suggestForm()
{
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
		  });
}

function validate_userForm()
{
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
		      }
		    }
		  });
}

function validate_changePassForm()
{
	/**User Form**/
		$('#changePassForm')
		  .form({
		    fields: {
		      ncontrasena: {
		        identifier: 'ncontrasena',
		        rules: [
		          {
		            type   : 'empty',
		            prompt : 'Por favor, introduzca su nueva contrasena de usuario.'
		          }
		        ]
		      },
		      ccontrasena: {
		        identifier: 'ccontrasena',
		        rules: [
		          {
		            type   : 'empty',
		            prompt : 'Por favor, confirme su nueva contrasena de usuario.'
		          }
		        ]
		      },
		      acontrasena: {
		        identifier: 'acontrasena',
		        rules: [
		          {
		            type   : 'empty',
		            prompt : 'Por favor, introduzca su contrasena actual.'
		          }
		        ]
		      }
		    }
		  });
}

function load_userFormData(userId)
{
	if(userId)
	{
		var dic = {
          email: userId,
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    	}

	    postData('userCredentials/',dic,function(data){

			if(data.success)
			{
				postData('userInfo/',dic,function(datau){

					if(datau.success)
					{
						$('#userForm').form('set values', {
						    unombre     : datau.values[0].first_name,
						    uapellido   : datau.values[0].last_name,
						    udireccion   : datau.values[0].address,
						    ucorreo : data.values.email,
						    ucontrasena : data.values.password
						  });
					}
				});
			}
			else{
				alert("er");
			}
		});
		
	}
	else{
		show_alert("danger","El usuario no ha iniciado session",5000);
	}
}

function getGroups(userId, usrRol)
{
	// userid=1: obtiene todos los grupos
	// userid=2: obtiene los grupos del usuario actual (ff)
	var dic = {
          userId: userId,
          userRol: usrRol,
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    	}

    postData('getGroups/',dic,function(data){

    	data = $.parseJSON(data);

    	console.log(data);

			if(data)
			{
				var obj = `<div class="ui styled accordion">`;

				for(var i=0; i<data.length; i++)
				{
					var users ="";
					for (var u=0; u<data[i].user.length; u++)
					{
						var delUser = (usrRol == 1 || usrRol == 2) ? `<a class="delete_user" uid="`+data[i].user[u].uid_id+`" style="color:rgb(200,90,50); margin-left:15px; cursor:pointer;">Eliminar</a>` : "";

						users += "<li>"+data[i].user[u].first_name+" "+data[i].user[u].last_name+ delUser+"</li>";
					}

					var ff ="";
					for (var u=0; u<data[i].ff_info.length; u++)
					{
						ff += "<b>"+data[i].ff_info[u].first_name+" "+data[i].ff_info[u].last_name+"</b>";
					}

					users = users.length == 0? "<li>No contiene integrantes.</li>" : users;

					var del_group = usrRol == 1 ? `<div class="delete_group" gid="`+data[i].id+`" style="float:right; color:rgb(200,90,50);">Eliminar</div>` : "";
					var edit_group = (usrRol == 1 || usrRol == 2) ? `<div class="edit_group" gid="`+data[i].id+`" style="float:right; color:rgb(90,170,50); margin-right:10px;">Editar</div>` : "";

					obj += `<div class="title">
						    <i class="dropdown icon"></i>
						    `+data[i].name+`
						    `+del_group+` 
						    `+edit_group+`
						  </div>
						  <div class="content">
						    <p class="transition visible" style="display: block !important;">
						    Encargado: `+ff+`
						    `+users+`
						    </p>
						  </div>`;
				}
			}
			else{
				alert("er");
			}

			obj += `</div>`;
			$(".data").html(obj);

			$('.ui.accordion')
				.accordion();

			$(".delete_group").click(function(){

				if (confirm("Desea eliminar este grupo?"))
				{
					var dic = {
			          gid: $(this).attr('gid'),
			          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
			    	}	

			    	postData('delGroup/',dic,function(data){

			    		if(data)
			    		{
			    				getGroups(userId,usrRol);
			    		}
			    	});
			    }
			});

			$(".edit_group").click(function(){

				
			});

			$(".delete_user").click(function(){

				if (confirm("Desea eliminar este usuario del grupo?"))
				{
					var dic = {
				          userId: $(this).attr('uid'),
				          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
				    	}	

				    postData('delUserGroup/',dic,function(data){

				    	if(data)
				    	{
				    		getGroups(userId,usrRol);
				    	}
				    });
			    }
			});
		});

}

function getGroupMembers(uid)
{
	var dic = {
          userId: uid,
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    	}

	    postData('group_members/',dic,function(data){

	    	data = $.parseJSON(data);

			if(data)
			{
				// Data > 1: Pertenece a un grupo (uno o  mas integrantes).
				// Data = 1: !groupId = 0, pertenece a un grupo sin integrantes.

				var list = "<ul>";

				if(data.length == 1)
				{
					if(data[0].groupId == 0)
					{
						list = `<li>Usted no pertenece a ningun grupo.</li>`;
					}
					else{
						list = `<li>Usted es el unico integrante de su grupo.</li>`;
					}
				}
				else if(data.length > 1)
				{
					if(data[0].groupId == 0)
					{
						// Usuarios con groudId == 0
						list = `<li>Usted no pertenece a ningun grupo.</li>`;
						return;
					}
					else
					{
						for(var i=0; i<data.length; i++)
						{
							list += `<li>`+data[i].first_name+` `+data[i].last_name;
							list += `(`+data[i].uid_id+`).</li>`;
						}
					}
				}

				list += "</ul>";

				$(".data").html(list);
			}
		});
}


function load_contactForm(contactId)
{
	if(contactId)
	{
		var dic = {
          id: contactId,
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    	}

	    postData('getContactWithId/',dic,function(data){

	    	data = $.parseJSON(data);

			if(data)
			{
				$('#suggest_form').form('set values', {
					crnc     : data[0].rnc,
					ccategoria   : data[0].categoryId_id,
					cnombre   : data[0].name,
					cimagen : data[0].image,
					cdescripcion : data[0].description,
					ctelefono : 'data[0].description',
					cdireccion : 'data[0].description'
				});

				//$("#contacts_modal").modal("hide");
			}
			else{
				alert("er");
			}
		});
	}	
}

function deleteContact(contactId)
{
	var dic = {
          id: contactId,
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    	}

	postData('deleteContact/',dic,function(data){

		if(data)
		{
			alert("Contact deleted");
		}
		else{
			alert("er");
		}
	});
}

function setContactTableSetting()
{
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
}





