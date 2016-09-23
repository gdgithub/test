/*$(document).ready(function(){

getContacts();


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

function getContacts()
{
	var dic = {
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

     postData('contactList/',dic,function(data){

     	createContactTableWithData($.parseJSON(data),1,10,$(".contact_adm_body .table_content"));
     });
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
			      <td>
			      	<div class="ui button load_menu" cid="`+data[i].id+`" data-toggle="modal" data-target="#menuModal">Menu</div>
			      </td>
			      <td>

			      	<div class="ui button">Mostrar opciones</div>
						<div class="ui flowing popup top left transition hidden">
						  <div class="ui two column divided center aligned grid">
						    <div class="column">
						      <div class="ui button editcontact" cid="`+data[i].id+`" data-toggle="modal" data-target="#menuModal">Editar</div>
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

				getMenuDetails($(".cmenu option:selected").attr('mid'),function(data){

					data = $.parseJSON(data);

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

	    	$(".header_one").html("Introduzca el nombre del menu. Presione el boton <b>'Nueva Seccion'</b> para crear categorias del menu.");
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


			$('.menu_category_details').each(function() {

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
						<div class="ui button delete_section" >Eliminar</div>
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

function postData(url,vars,callback)
{
  $.ajax({
      type:"POST",
          url:url,
          data: vars,
          success: callback
  });
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



});*/
