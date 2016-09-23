	'use strict' 

$(document).ready(function(){
	
	var menuBar = $(".menu-bar");

	confirmAuth();
	//getNotifications();

$('.ui.dropdown')
      .dropdown();

jQuery(window).load(function () {
	
	if(window.location.pathname == "/management/")
	{
		window.location.assign("/management/orders/");
	}
	else if(window.location.pathname == "/management/orders/")
	{
		$("#userForm .options").hide();
		$("#order_loader").show();
		initializeSearcher();
		createCookie("ormemfil");
		var userId = getCookie("userId");

		if(getCookie("access-type") == 1) // admin
		{
			createOrderTableForUserWithId("all", 1);
		}
		else if(getCookie("access-type") == 2) // ff
		{
			// Muestra los grupos del usuario
			// Los grupos son accesibles, muestran los pedidos de los integrantes del grupo

			createOrderTableForUserWithId(userId, 2);
		}
		else if (getCookie("access-type") == 3) // dev
		{
			createOrderTableForUserWithId(userId, 3);
		}
		
	}
	else if(window.location.pathname == "/management/contacts/")
	{
		initializeSearcher(getCookie("access-type"));
		getContacts();
	}
	else if(window.location.pathname == "/management/group/")
	{
		if (getCookie("access-type") != 3) 
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
			/*$("#show_contact_list").css({opacity:'1.0'});*/

			setContactTableSetting();
		}
		else
		{
			/*$("#show_contact_list").css({opacity:'0.0'});*/
		}

	}
	else if(window.location.pathname == "/management/myinfo/")
	{
		validate_userForm();
		validate_changePassForm();
		load_userFormData(getCookie('userId'));
	}

});

	$("#neworder").click(function(){
		$("#menu_select").parent().parent().hide();
		$(".total_order").hide();
		$(".order_menu_content").html();
	});

	$("#search_contact").click(function(e){

	    findContact(e,true);
	});

	$("#menu_select").change(function(){

		getMenuDetails($('option:selected', this).attr('mid'),function(data){

			data = $.parseJSON(data);

			if(data)
					{
						var menu_body = $(".order_menu_content");
						var html = "";
						var menu_html = "";
						var menu_content = {};

						for(var i=0; i<data.length; i++)
						{
							if(!menu_content[data[i].categoryId_id])
								menu_content[data[i].categoryId_id] = [];

							menu_content[data[i].categoryId_id].push({'id': data[i].id, 'desc': data[i].description, 'price':data[i].price});
						}	

						var categories = Object.keys(menu_content);
						var category_name = {};

						getMenuCategories(function(data){

							data = $.parseJSON(data);
							var all_categories = [];

							for(var i=0; i<data.length; i++)
							{
								category_name[data[i].id] = {'category_name': data[i].description};

								all_categories.push(data[i].id);
							}

							for(var j=0; j<categories.length; j++)
							{
								html = `<p class="order_menu_category_name" mcid="`+categories[j]+`"><b>`+category_name[categories[j]].category_name+`:</b></p>`;

								html += `<table class="menu_desc_table">`;
								for(var d=0; d<menu_content[categories[j]].length; d++)
								{
									html += `
									<tr>
										<td class="td_desc"><p>`+menu_content[categories[j]][d].desc+`</p></td>
										<td class="td_cant"><input class="mdcant" type="number" min="0" value="0"></input></td>
										<td class="td_price"><p>$`+menu_content[categories[j]][d].price+`</p></td>
									</tr>`;
								
								}
								html += `</table>`;

								html += `<div class="menu_section_space"></div>`;

								menu_html += html;
							}

							menu_body.html("<div class='menu_viewer'>"+menu_html+"</div>");
							$(".menu_cant_details").hide();
							$(".total_order").show();

							$(".td_desc, .td_price").click(function(){
								$(this).addClass("active");
								$(this).parent().find("input").fadeToggle(160,function(){
									calcItemSelected($(".menu_desc_table"),$(".total_order"));
								});
							});

							$(".mdcant").change(function(){
								calcItemSelected($(".menu_desc_table"),$(".total_order"));
							});
						});

					}
		});
	});


	function calcItemSelected(element,result){

		var total = 0;

		element.each(function() {
			//var value = $(this).val();
			$(this).find("tr").each(function() {

				if($(this).find(".mdcant").css('display') != 'none')
				{
					var cant = parseFloat($(this).find(".mdcant").val());
					var item_price = parseFloat($(this).find(".td_price p").html().replace("$","")).toFixed(2);

					total += (cant*item_price);
				}
			});
		});

		result.html("$"+total.toFixed(2));

		return "$"+total.toFixed(2);
	}

	$("#doRequest").click(function(){

		if($("#tsearch").val().length == 0)
		{
			swal("Informacion", "No establecimiento de comida");
			return false;
		}

		var order_description = "";
		var total = 0;

		$(".menu_desc_table").each(function() {
			
			$(this).find("tr").each(function() {

				if($(this).find(".mdcant").css('display') != 'none')
				{
					if(parseFloat($(this).find(".mdcant").val()) > 0){
						var cant = parseFloat($(this).find(".mdcant").val());
						var item_desc = $(this).find(".td_desc p").html();
						var item_price = parseFloat($(this).find(".td_price p").html().replace("$",""));
						total += (cant*item_price);
						order_description += "- "+cant+" "+item_desc+" ****** $"+item_price+" X "+cant+" = $"+ (cant*item_price)+"\n";
					}
				}
			});
		});

		if(order_description.length > 0)
		{
			var meta = $("#tsearch").val() +" - "+$("#menu_select").val()+"\n\n";

			order_description = meta +order_description;
			order_description += "\nTotal: $"+total;

			console.log(order_description);

			var dic = {
                csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
                userId: getCookie('userId'),
                dataOrder: order_description,
                status: "active"
            }

            postData('directories/createOrder/',dic,function(data){

            	data = $.parseJSON(data);

            	if(data.success)
            	{
            		var msg = getCookie("userId")+" su pedido ha sido enviado.";
            		swal("Pedido realizado exitosamente.", msg, "success");
            		$(".close.orderModal").click();
            		createOrderTableForUserWithId(getCookie("userId"),getCookie("access-type"));
            	}
            	else{
            		swal("Error.", "Ocurrio un error al realizar el pedido, intentelo nuevamente.", "error");
            	}
            });
		}
		else{
			swal("Solicitud cancelada", "Debe seleccionar los articulos que desee del menu e indicar la cantidad antes de realizar la solicitud.");
		}
    });












    /**Grupos**/
    $("#newGroup").click(function(){
    	$("#addGruopForm").attr("mode","create");
    	$("#addGruopForm").attr("gid","-1");
    	$("#gencargado").prop('disabled', false);

    });

    $("#addGruopForm").submit(function(e){
		e.preventDefault();
	});
    
    $("#newMember").click(function(){

    	var obj = $("#addGruopForm").find(".content");
		
		obj.append(`
			<div class="two fields">
			  	<div class="field">
			      <input placeholder="Ej. Juan Perez / Jp1592" name="gmiembro" id="gmiembro" class="gmiembro" type="text">
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
			  gid: $("#addGruopForm").attr("gid"),
	          gname: $("#gnombre").val(),
	          gff: $("#gencargado").val(),
	          gmembers : members.join("|"),
	          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
	    }

	    if($("#addGruopForm").attr("mode")=="create")
	    {
	    	postData('createGroup/',dic,function(data){

		     	if(data)
		     	{
		     		getGroups(getCookie('userId'),getCookie('access-type'));
		     		show_alert("success","Grupo creado.",3000);
		     	}
		     	else{
		     		show_alert("danger","Error.",3000);
		     	}
         	});
	    }
	    else if($("#addGruopForm").attr("mode")=="edit")
	    {

	    	postData('updateGroup/',dic,function(data){

		     	if(data)
		     	{
		     		getGroups(getCookie('userId'),getCookie('access-type'));
		     		show_alert("success","Grupo Actualizado.",3000);
		     	}
		     	else{
		     		show_alert("danger","Error.",3000);
		     	}
         	});
	    }
	     

		//$(".gruop_info").attr('members',members.join("|"));
		//$(".gruop_info").attr('groupName',$("#gnombre").val());
	    
	});

    /*Contactos*/
   /* $(".newMenu").click(function(){

    	alert("asd");
    });*/

    $("#tsearch").keydown(function(){
    	alert("sa");
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
	          telefono: $("#ctelefono").val(),
	          direccion: $("#cdireccion").val(),
	          status: getCookie('access-type') == 1 ? 'enable' :'disable',
	          userId: getCookie('userId'),
	          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
	      }

	      postData("suggest_contact/",dict,function(data){
	       
		       data = $.parseJSON(data);

		       if(data.created)
		       {
				swal("Contacto almacenado.", "", "success");
		       }
		       else if(data.exists)
		       {
		       		swal({   
		       			title: "Adventencia",
		       		    text: "Existe un contacto asociado al mismo RNC.",
		       		    type: "warning",   
		       		    showCancelButton: false,   
		       		    confirmButtonColor: "#DD6B55",   
		       		    confirmButtonText: "Ok",   
		       		    closeOnConfirm: false });
		       }
	       
	      });
	});

	$("#reset_Suggest_Form").click(function(){
		$('#suggest_form').form('clear');
	});

	/*Sugerencias admin-area*/
	$(".editContact").click(function(){
		alert("s");
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


/**********Contactos******************/

function getContacts()
{
	var dic = {
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

     postData('contactList/',dic,function(data){

     	createContactTableWithData($.parseJSON(data),1,10,$(".contact_adm_body .table_content"));
     });
}


function initializeSearcher(usrRol=1)
{
    var dic = {
    	userRol: usrRol,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

    postData('directories/getContactsName/',dic,function(names){

        var contacts_name = $.parseJSON(names);

        console.log(contacts_name);
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
			var msg = getCookie("userId")+" su pedido ha sido enviado.";
			swal("Pedido realizado exitosamente.", msg, "success");

			createOrderTableForUserWithId(userId, getCookie("access-type"), getCookie("ormemfil"));
		}
		else{
			swal("Error","Ocurrio un error al realizar el pedido, intente nuevamente.", "error");
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
			var msg = getCookie("userId")+" su pedido ha sido cancelado.";
			swal("La orden ha sido cancelada.", msg, "success");

			createOrderTableForUserWithId(userId, getCookie("access-type"), getCookie("ormemfil"));
		}
		else{
			swal("Error: No se ha podido cancelar la orden.", msg, "success");
		}
	});
}

function createOrderTableForUserWithId(id, access_type=false, filter=null)
{
	if(access_type == 1 || access_type == 3)
	{
		if (access_type == 1) {
			id = "all"; // todos los pedidos (admin)
		}
		
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
				$("#order_loader").hide();
			}
			
		});
	}
	else if(access_type == 2)
	{
		getGroupMeta(id, 2,function(data){

			var group = $.parseJSON(data);
				
			if (group) {

				var html ="";

				html = "Estos son tus grupos, <b>"+id+"</b>. Seleccione el grupo en el cual desea ver los pedidos realizados: <br><br>";
				$("#userForm .data").append(html);

				for(var i=0; i<group.length; i++)
				{						
					html = `<li><a class="order_gruop" gid="`+group[i].id+`">`+group[i].name+`</a></li>`;

					$("#userForm .data").append(html);

					$(".order_gruop").click(function(){

						$("#order_loader").show();	
						var gid = $(this).attr("gid");
						var group_name = $(this).text();

						if(gid.length==0){
							show_alert("Ocurrio un error al cargar los pedidos de este grupo.","gid - error",3000);
							$("#order_loader").hide();
							return false;
						}

						getGroupMemOrders(gid,2,function(data){

							data = $.parseJSON(data);

							$(".group_name").text(group_name);
							$("#userForm .options").show();
							$("#order_loader").show();
							constructTableWithData(data,5,1);
							$("#order_loader").hide();	

							// Filtro
							var members = [];
							for(var i=0; i<data.length; i++)
							{
								members.push(data[i].fields.userId);
							}	

							members = members.filter(function( item, index, inputArray ) {
								           		return inputArray.indexOf(item) == index;
								    		});

							$(".members_selecter optgroup").html(`
								<option value="" disabled selected>Filtrar por miembro</option>
								<option value="" >Todos</option>
							`);

							for(var i=0; i<members.length; i++)
							{
								$(".members_selecter optgroup").append(`<option>`+members[i]+`</option>`);
							}

							$(".members_selecter").click(function(){

								var filter_selected = filter != null ? filter: $(".members_selecter option:selected").text();

								// filter cookie for fowards handle
								createCookie("ormemfil",filter_selected,3000);

								if(filter_selected != "Todos")
								{
									var temp_data = [];

									for(var i=0; i<data.length; i++)
									{
										if(data[i].fields.userId == filter_selected)
										{
											temp_data.push(data[i]);
										}
										constructTableWithData(temp_data,5,1);
									}
								}
								else
								{
									constructTableWithData(data,5,1);
								}
									
							});

						});
					});
				}

				$("#order_loader").hide();
			}
		});
	}
	
}


function constructTableWithData(data,display_n=10,current_page=1,pg=true,dpg="")
{
	var container = $(".data");

	var pagination = dpg;
	var page_number = 0;

	var html = `
	<table class="orders_table">
		<tr>
			<th>#</th>
			<th>Usuario</th>
			<th>Descripcion de los pedidos</th>
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
			color = data[i].fields.status == "banned" ? "rgb(240,240,240)" : color;

			html += `
			<tr>
				<td id="tdnumrow">`+( i+1)+`</td>
				<td><p title="`+data[i].fields.userId+`">`+data[i].fields.userId+`</p></td>
				<td>
					<div id="order_div" style="background-color: `+color+`;">
						<p id="odate">`+data[i].fields.date+`</p>
						<p>`+data[i].fields.description.replace(/\n/g, "<br />")+`</p>
						<p id="ostatus">`+status_trans(data[i].fields.status)+`</p>
						<i class="reply icon" orderId="`+data[i].pk+`" title="Volver a pedir"></i>
						`; 
						if(data[i].fields.status != "banned"){ 
							html +=`<i class="remove circle icon" orderId="`+data[i].pk+`" title="Cancelar pedido"></i>`;
						}
					html +=`</div>
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
			window.location.assign("/login");
		});
	}
	else
	{
		//window.location.assign("/login");
		//window.location.assign("/");
	}
}

function getNotifications(){

	//var code                                              = Math.floor((Math.random()*1000000)+1);
	var current = 0;

	check = function(){

		if(getCookie("nc")!=current)
		{
			var dic = {
	                csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
	            }

			postData("getnotifications/",dic,function(data){

				data = $.parseJSON(data);

				if(data)
				{
					swal("Notificaciones", "It's pretty, isn't it?");

					current = data.length;
					createCookie("nc",current,3000000);
					setTimeout(check, 1000);
				}
			});
		}else{
			setTimeout(check, 1000);
		}
	}

	setTimeout(check, 1000);
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
            var categories = $.parseJSON(data);

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
	createCookie('ormemfil',null,3000);
}

function deleteCookie(name)
{
	createCookie(name,null,3000);
}

/*});*/
/////////////////////////JQUERY//////////////////////////////////////////////////
//});























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

function findContactWithName(e,f=false)
{
    if(e.which == 13 || f) {

        var dic = {
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
            name:$("#tsearch").val()
        }

        postData('findContact/',dic,function(data){

            createContactTableWithData($.parseJSON(data),1,10,$(".contact_adm_body .table_content"));
        });
    }
}


function createContactTableWithData(data,page=1,rows=10,parent)
{
	if (data.length>0) {

		var pagCount = 1;

		if((data.length % rows) == 0)
			pagCount = Math.floor(data.length/rows);
		else
			pagCount = Math.floor(data.length/rows)+1;
		

		var content = `
		<table class="ui celled table">
			  <thead>
			  <tr>
				<th>Contacto</th>
				<th>Categoria</th>
				<th>Puntuacion</th>
				<th>Estado</th>
				<th>Menu</th>
				<th id='options'>Opciones</th>
				</tr>
			  </thead>
			  <tbody>`;

		for(var i=(page-1)*rows; i<(((page-1)*rows)+rows); i++)
		{
			if((data.length-1) < i)
				break;

			content += `<tr>
			      <td>`+data[i].name+`</td>
			      <td>`+data[i].categoryId_id+`</td>
			      <td>`+data[i].rating+`</td>
			      <td>`+data[i].status+`</td>
			      <td>
			      	<div class="ui button load_menu" cid="`+data[i].id+`" data-toggle="modal" data-target="#menuModal">Menu</div>
			      </td>
			      <td>

			      	<div class="ui button">Mostrar opciones</div>
						<div class="ui flowing popup top left transition hidden">
						  <div class="ui two column divided center aligned grid">
						    <div class="column">
						      <div class="ui button editcontact" cid="`+data[i].id+`">Editar</div>
						    </div>
						    <div class="column">
						      <div class="ui button deletecontact" cid="`+data[i].id+`">Eliminar</div>
						    </div>
						  </div>
						</div>
			      </td>
			    </tr>`;
		}

		var pagination = "";

		for(var i=0; i<pagCount; i++)
		{
			pagination += `<a class="item pagebutton" pag=`+(i+1)+`>`+(i+1)+`</a>`;
		}

		content +=`
			  </tbody>
			  <tfoot>
			    <tr><th colspan="3">
			      <div class="ui right floated pagination menu">
			        <a class="icon item prevpagebutton">
			          <i class="left chevron icon"></i>
			        </a>
			        `+pagination+`
			        <a class="icon item nextpagebutton">
			          <i class="right chevron icon"></i>
			        </a>
			      </div>
			    </th>
			  </tr></tfoot>
			</table>`;

		parent.html(content);

		$('.button')
		  .popup({
		    inline: true,
			hoverable:true
		  });

		$(".pagebutton").click(function(){
				createContactTableWithData(data,$(this).attr('pag'),rows,parent)
			});

		$(".prevpagebutton").click(function(){
				if((page-1) >= 1)
					createContactTableWithData(data,page-1,rows,parent)
			});

		$(".nextpagebutton").click(function(){
				if((page+1) <= pagCount)
					createContactTableWithData(data,page+1,rows,parent)
			});


		//Menu
		var categories;
		var all_categories = [];
		var category_name = {};
		var category_control;
		
		$(".load_menu, .backtomenu").click(function(){

			$(".newMenu").css('display','inline');
			if($(".menuname").length>0)
				$(".menuname").replaceWith('<select class="cmenu" name="cmenu"></select>');

			$(".cmenu").html("");
			$(".menu_body_content").html("");
			$(".editMenu").hide();
			$(".newSection").hide();
			$(".saveMenu").hide();
			$(".deleteMenu").hide();
			$(".backtomenu").hide();

			$(".header_one").html("Seleccione el menu que desee desplegar.");

			var cid = $(this).attr('cid');
			if (typeof cid !== typeof undefined && cid !== false){

				$(".menu_body_content").attr("cid",cid);
				$("#menuForm").attr("cid",cid);
			}else
			{
				cid = $(".menu_body_content").attr("cid");
			}
				

			getContactListMenu(cid,function(data){

				data = $.parseJSON(data);

				if(data)
				{
					for(var i=0; i<data.length; i++)
					{
						$(".cmenu").append(`<option mid=`+data[i].id+`>`+data[i].name+`</option>`);
					}
				}
			});

			$(".cmenu").click(function(){

				$(".menu_body_content").html("");
				$(".newMenu").css('display','inline');
				$(".editMenu").hide();
				$(".newSection").hide();
				$(".saveMenu").hide();
				$(".deleteMenu").hide();
				$(".backtomenu").hide();

				getMenuDetails($('option:selected', this).attr('mid'),function(data){

					data = $.parseJSON(data);

					//console.log($(".cmenu option:selected").attr('mid'));
					if(data)
					{
						var menu_body = $(".menu_body_content");
						var html = "";
						var menu_html = "";
						var menu_content = {};

						for(var i=0; i<data.length; i++)
						{
							if(!menu_content[data[i].categoryId_id])
								menu_content[data[i].categoryId_id] = [];

							menu_content[data[i].categoryId_id].push({'id': data[i].id, 'desc': data[i].description, 'price':data[i].price});
						}	

						categories = Object.keys(menu_content);
						category_name = {};

						getMenuCategories(function(data){

							data = $.parseJSON(data);
							all_categories = [];

							for(var i=0; i<data.length; i++)
							{
								category_name[data[i].id] = {'category_name': data[i].description};

								all_categories.push(data[i].id);
							}

							for(var j=0; j<categories.length; j++)
							{
								html = `<p class="category_name" mcid="`+categories[j]+`"><b>`+category_name[categories[j]].category_name+`:</b></p>`;

								for(var d=0; d<menu_content[categories[j]].length; d++)
								{
									html += `<li class="menu_category_details" mdid="`+menu_content[categories[j]][d].id+`" mdcid="`+categories[j]+`" mdcn="`+category_name[categories[j]].category_name+`"><span class="menu_desc">`+menu_content[categories[j]][d].desc+`</span>  <span class="mp">$<span class="menu_price">`+menu_content[categories[j]][d].price+`</span></span></li>`;
								}

								html += `<div class="menu_section_space"></div>`;

								menu_html += html;
							}

							$(".editMenu").show();
							$(".deleteMenu").show();

							menu_body.html("<div class='menu_viewer'>"+menu_html+"</div>");
						});

					}
				});
			});

		});

		$(".newMenu").click(function(e){
			e.preventDefault();
			$(this).css('display','none');
			$(".newSection").show();
			$(".editMenu").hide();
			$(".deleteMenu").hide();
			$(".saveMenu").show();
			$(".backtomenu").show();
	    	$(".menu_body_content").html("");

	    	$(".header_one").html("Introduzca el nombre del menu. Presione el boton <b>'Crear nueva seccion'</b> para crear categorias del menu.");
	    	$(".cmenu").replaceWith('<input type="text" class="menuname" placeholder="Nombre del menu">');

	    	getMenuCategories(function(data){

				data = $.parseJSON(data);
				all_categories = [];

				for(var i=0; i<data.length; i++)
				{
					category_name[data[i].id] = {'category_name': data[i].description};

					all_categories.push(data[i].id);
				}

				category_control = "<select class='dropdown_category'><option value='-1' disabled>Seleccione la categoria</option>";

				for (var i=0; i<all_categories.length; i++)
				{
					category_control += `<option value="`+all_categories[i]+`">`+category_name[all_categories[i]].category_name+`</option>`;
				}

				category_control += "</select>";
			});
	    });

		$(".editMenu").click(function(e){
			e.preventDefault();
			$(this).hide();
			$(".newSection").show();
			$(".saveMenu").show();
			$(".deleteMenu").show();
			$(".backtomenu").show();

			var secheader = "";
			var field = "";

			category_control = "<select class='dropdown_category'><option value='-1' disabled>Seleccione la categoria</option>";

			for (var i=0; i<all_categories.length; i++)
			{
				category_control += `<option value="`+all_categories[i]+`">`+category_name[all_categories[i]].category_name+`</option>`;
			}

			category_control += "</select>";

			$('.menu_category_details').each(function(i,o,f) {

				if(secheader != $(this).attr("mdcid"))
				{
					secheader = $(this).attr("mdcid");

					$(".menu_body_content").append(
						`<div class='section section`+$(this).attr("mdcid")+`' id="section`+$(this).attr("mdcid")+`">`
						+`<h5 class="ui dividing header">`+category_control+`</h5>`
						+`<div class="sc"></div>`
						+`<div class="ui button addfield" >+</div>
						<div class="ui button hide_section" >Ver menos</div>
						<div class="ui button delete_section" >Eliminar</div>
						</div>`);
				}

				field = `
						<div class="fields menurow_edit" mdid="`+$(this).attr("mdid")+`">
						  <div class="twelve wide field">
						     <input type="text" class="desc" placeholder="Descripcion" value="`+$(this).find(".menu_desc").html()+`">
						  </div>
						  <div class="four wide field">
						     <input type="number" class="price" min="0" placeholder="Precio RD$" value="`+$(this).find(".menu_price").html()+`">
						  </div>
						  <div class="four wide field">
						    <div class="ui button removefield" mdid="`+$(this).attr("mdid")+`">X</div>
						  </div>
						</div>`; 

				$(".section"+$(this).attr('mdcid')+" .sc").append(field);
			});

			// establece categoria de menu
			var menuSelectedVal = [];
			$(".category_name").each(function(){
				//if(!menuSelectedVal.includes($(this).attr('mcid')))
				menuSelectedVal.push($(this).attr('mcid'));
			});

			$(".dropdown_category").each(function(i,obj){
				$(this).val(menuSelectedVal[i]);
				
			});

			// elimina menu - viewer
			$('.menu_category_details').each(function() {
				$(this).remove();
				$('.menu_body_content p').remove();
				$('.menu_section_space').remove();
				$('.menu_viewer').remove();
			});

			$(".addfield").click(function(){
				$(this).parent().find(".sc").append(`
						<div class="fields menurow_create">
						  <div class="twelve wide field">
						     <input type="text" class="desc" placeholder="Descripcion">
						  </div>
						  <div class="four wide field">
						     <input type="number" class="price" min="0" placeholder="Precio RD$">
						  </div>
						  <div class="four wide field">
						    <div class="ui button removefield" mdid="none">X</div>
						  </div>
						</div>`);

				$(".removefield").click(function(){
					$(this).parent().parent().remove();
				});
			});

			$(".removefield").click(function(){
				// just for edition
				var obj = $(this);
				deleteMenuItemWithId($(this).attr("mdid"),function(success){
					if(success){
						obj.parent().parent().remove();
					}
				});
				

			});

			$(".hide_section").click(function(){
				$(this).parent().find(".sc").slideToggle("slow");

				if($(this).parent().find(".addfield").css('opacity')==0){
					$(this).parent().find(".addfield").animate({opacity:"1"},200);
					$(this).html('Ver menos');
				}
				else{
					$(this).parent().find(".addfield").animate({opacity:"0"},200);
					$(this).html('Ver mas');
				}
			});

			$(".delete_section").click(function(){

				var obj = $(this);
				var parentClassName = obj.parent().attr("id");

				alert(parentClassName);

				if(confirm("Desea eliminar esta seccion?"))
				{
					var mdid = [];

					$("#"+parentClassName+" .menurow_edit").each(function(){

						var value = $(this).attr('mdid');

						if (typeof value !== typeof undefined && value !== false)
							mdid.push(value);
					});

					$("#"+parentClassName+" .menurow_create").each(function(){

						var value = $(this).attr('mdid');

						if (typeof value !== typeof undefined && value !== false)
							mdid.push(value);
					});

					if(mdid.length > 0)
					{
						var dic = {
							mdid: mdid.join('|'),
				            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
				    	}

				     	postData('deletemenuelements/',dic,function(success){

				     		if(success)
				     			obj.parent().remove();
				     	});
					}
					else
					{
						//obj.parent().remove();
					}
					
				}
			});
			
		});

		$(".newSection").click(function(){

			$(".menu_body_content").append(
						`<div class='section section`+($(".section").length) * 100+`'>`
						+`<h5 class="ui dividing header">`+category_control+`</h5>`
						+`<div class="sc">

						<div class="fields menurow_create">
						  <div class="twelve wide field">
						     <input type="text" class="desc" placeholder="Descripcion">
						  </div>
						  <div class="four wide field">
						     <input type="number" class="price" min="0" placeholder="Precio RD$">
						  </div>
						  <div class="four wide field">
						    <div class="ui button removefield" >X</div>
						  </div>
						</div>


						</div>`
						+`<div class="ui button addfieldni addfieldn`+($(".section").length) * 100+`" >+</div>
						<div class="ui button hide_sectionn`+($(".section").length) * 100+`" >Ver menos</div>
						<div class="ui button delete_sectionn`+($(".section").length) * 100+`" >Eliminar</div>
						</div>`);


			$(`.addfieldn`+($(".section").length - 1) * 100+``).click(function(){
			
				$(this).parent().find(".sc").append(`
						<div class="fields menurow_create">
						  <div class="twelve wide field">
						     <input type="text" class="desc" placeholder="Descripcion">
						  </div>
						  <div class="four wide field">
						     <input type="number" class="price" min="0" placeholder="Precio RD$">
						  </div>
						  <div class="four wide field">
						    <div class="ui button removefield" >X</div>
						  </div>
						</div>`);

				$(".removefield").click(function(){
					$(this).parent().parent().remove();
				});
			});

			$(`.hide_sectionn`+($(".section").length - 1) * 100+``).click(function(){
					$(this).parent().find(".sc").slideToggle("slow");

					if($(this).parent().find(`.addfieldni`).css('opacity')==0){
						$(this).parent().find(`.addfieldni`).animate({opacity:"1"},200);
						$(this).html('Ver menos');
					}
					else{
						$(this).parent().find(`.addfieldni`).animate({opacity:"0"},200);
						$(this).html('Ver mas');
					}
				});

			$(`.delete_sectionn`+($(".section").length - 1) * 100+``).click(function(){
					$(this).parent().remove();
				});
		});

		$(".saveMenu").click(function(){

			var cid = $(".menu_body_content").attr("cid");
			var mid = "";
			var mdid = [];
			var mcid = [];
			var mdesc = [];
			var mprice = [];
			var task = [];
			var newmenu = "false";

			if($(".cmenu").length > 0 && $(".menuname").length==0)
			{
				mid = $(".cmenu option:selected").attr('mid');
				newmenu = "false";
			}
			else
			{
				mid = $(".menuname").val();
				newmenu = "true";

				if(mid.length==0)
				{
					alert("no menu name");
					return;
				}
			}

			$(".menurow_edit").each(function(){

				if($(this).find(".desc").val().length > 0)
				{
					var price = 0;
					if($(this).find(".price").val().length > 0)
						price = $(this).find(".price").val();

					mdid.push($(this).attr('mdid'));
					mcid.push($(this).parent().parent().find('.dropdown_category').val());
					mdesc.push($(this).find(".desc").val());
					mprice.push(price);
					task.push('edit');
				}
			});

			$(".menurow_create").each(function(){

				if($(this).find(".desc").val().length > 0)
				{
					var price = 0;
					if($(this).find(".price").val().length > 0)
						price = $(this).find(".price").val();

					mdid.push('none');
					mcid.push($(this).parent().parent().find('.dropdown_category').val());
					mdesc.push($(this).find(".desc").val());
					mprice.push(price);
					task.push('create');
				}
			});

			var dic = {
				cid: cid,
				mid: mid,
				mdid: mdid.join('|'),
				mcid: mcid.join('|'),
				mdesc: mdesc.join('|'),
				mprice: mprice.join('|'),
				task: task.join('|'),
				newmenu, newmenu,
	            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
	    	}

	     	postData('managemenu/',dic,function(success){

	     		if(success)
	     			alert(success);
	     	});

		});

		$(".deleteMenu").click(function(){
			if(confirm("Desea eliminar este menu?"))
			{
				var dic = {
				mid: $(".cmenu option:selected").attr('mid'),
	            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
		    	}

		     	postData('deletemenu/',dic,function(success){

		     		if(success)
		     			alert(success);

		     		$(".backtomenu").click();
		     	});
			}
		});

		$(".categories").click(function(e){
			e.preventDefault();
			$(this).hide();
			$(".newSection").hide();
			$(".saveMenu").hide();
			$(".deleteMenu").hide();
			$(".backtomenu").show();

		});

		$(".editContact").click(function(){

				var contactId = $(this).attr('cid');

				if (!contactId) {
					alert("Error: No contact id provided.");
					return;
				}
				else
				{
					load_contactForm(contactId);
				}

			});

		$(".deletecontact").click(function(){
			var contactId = $(this).attr('cid');
				swal({   
					title: "Are you sure?",
					text: "You will not be able to recover this imaginary file!",
					type: "warning",
					showCancelButton: true,
					confirmButtonColor: "#DD6B55",
					confirmButtonText: "Yes, delete it!",
					closeOnConfirm: false }, 
					function(){   
					   	var paramns = {};

						paramns.data = data;
						paramns.page = 1;
						paramns.rows = rows;
						paramns.parent = parent;

						deleteContact(contactId,paramns);
				});
		});
	}
}

function getContactListMenu(cid, callback)
{
	var dic = {
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
            cid:cid
    	}

     postData('getcontactlistmenu/',dic,callback);
}

function getMenuDetails(mid, callback)
{
	var dic = {
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
            mid:mid
    	}

     postData('getmenudetails/',dic,callback);
}

function getMenuCategories(callback)
{
	var dic = {
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
        }

     postData('getmenucategories/',dic,callback);
}

function deleteMenuItemWithId(eid, callback)
{
	var dic = {
		eid: eid,
	    csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
	}

	postData('deletemenuitem/',dic,callback);
}

function getCategoryWithId(id, callback)
{
	var dic = {
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
            id:id
    	}

     postData('getcategorywithid/',dic,callback);
}

function deleteContact(contactId,paramns=null)
{
	var dic = {
          id: contactId,
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    	}

	postData('deleteContact/',dic,function(data){

		if(data)
		{
			swal("Directorio", "El contacto ha sido eliminado.", "success"); 
			getContacts();

			//if(paramns!=null)
			//	createContactTableWithData(paramns['data'],paramns['page'],paramns['rows'],paramns['parent']);
		}
		else{
			wal("Error", "Ocurrio un error al eliminar el contacto, por favor intentelo nuevamente.", "error"); 
		}
	});
}

function findContact(e,f=false)
{
	$("#menu_select").parent().parent().hide();
	$(".total_order").hide();

    if(e.which == 13 || f) {
        
        if($("#tsearch").val().length==0)
        	return false;

        var dic = {
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
            name:$("#tsearch").val()
        }

        postData('directories/findContact/',dic,function(data){

            data = $.parseJSON(data);

            if (data) 
            {   
               //getBranchForContactId(data[0].id);
               $('#menu_select').html('<option value="">Menu</option>');

               getContactListMenu(data[0].id,function(data){

               		data = $.parseJSON(data);

               		if(data){

               			$("#menu_select").parent().parent().show();

	               		for (var i=0; i<data.length; i++){

	               			$('<option>').val(data[i].name).text(data[i].name)
				            .attr("mid",data[i].id)
				            .appendTo('#menu_select');
	               		}	
	               	}
	               	else{
	               		$("#menu_select").parent().parent().hide();
	               	}
               });
            }
            else
            {

                alert("no data found");
            }
        });
    }
}
/*
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
}*/
/*
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
*/
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
		      ctelefono: {
		        identifier: 'ctelefono',
		        rules: [
		          {
		            type   : 'empty',
		            prompt : 'Por favor, introduzca el numero de telefono del contacto.'
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
		            prompt : 'Por favor introduzca la direccion del contacto.'
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

function getGroupMeta(ffid, userRol=2,callback)
{
	var dic = {
		userId: ffid,
		userRol: userRol,
		csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
	}

	postData('getGroups/',dic,callback);
}

function getGroupMemOrders(gid, userRol=2,callback)
{
	var dic = {
		groupId: gid,
		userRol: userRol,
		csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
	}

	postData('getGroupMemOrders/',dic,callback);
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

			if(data)
			{
				var obj = `<div class="ui styled accordion" style="width:100%;">`;

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
					var edit_group = (usrRol == 1 || usrRol == 2) ? `<div class="edit_group" gid="`+data[i].id+`" style="float:right; color:rgb(90,170,50); margin-right:10px;" data-toggle="modal" data-target="#groupModal">Editar</div>` : "";

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

			//	console.log($(this).prev().html());
				load_groupInfo($(this).attr('gid'),usrRol);
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

function load_groupInfo(gid,usrRol=null)
{
	var dic = {
          groupId: gid,
          csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

    postData('getGroupInfo/',dic,function(data){

    	data = $.parseJSON(data);

		if(data)
		{
			var form = $("#addGruopForm");
			var obj = form.find(".content");
			var gnombre = $("#gnombre");
			var gencargado = $("#gencargado");
			
			form.attr("mode","edit");
			form.attr("gid",gid);
			gencargado.val(data.group[0].ffId);
			gnombre.val(data.group[0].name);

			if(usrRol != null && usrRol == 2) 
				gencargado.prop('disabled', true);

			$(".gmiembro").parent().parent().remove();

			if (data.members.length == 0) {

				obj.append(`
					<div class="two fields">
					  	<div class="field">
					      <input placeholder="Ej. Juan Perez / Jp1592" name="gmiembro" id="gmiembro" class="gmiembro" type="text"></input>
					    </div>
					  </div>
					`);
			}
			
			for(var i=0; i<data.members.length; i++)
			{
				obj.append(`
					<div class="two fields">
					  	<div class="field">
					      <input placeholder="Ej. Juan Perez / Jp1592" name="gmiembro" id="gmiembro" class="gmiembro" type="text" value="`+data.members[i].uid_id+`"></input>
					    </div>
					   <div class="delrow">
					      <div class="ui submit button delGroupRow" id="delGroupRow">X</div>
					   </div>
					  </div>
					`);

				$(".delGroupRow").click(function(){

					$(this).parent().parent().remove();
				});
			}
		}
		else{
			alert("er");
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




});
//});