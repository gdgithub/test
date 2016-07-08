$(document).ready(function(){

    var lemail = $(".login-form #temail");
    var lpassword = $(".login-form #tpass");
    var spassword = $(".register-form #tpass");
    var semail = $(".register-form #temail");
    var authAlert = $("#authAlert");



    getAllContacts();

    // init
    // default element attr and properties
    authAlert.hide();

     $(".ui.rating").click(function(){
        var a = $('.ui.rating').rating('get rating');

        alert(a);
    });

    $('.ui.dropdown')
      .dropdown()
    ;

    $('.ui.button')
      .popup({
      });


    $('.ui.modal')
        .modal();
    });

    $('.menu .item')
      .tab();

    $('.tabular.menu .item').tab();

    

    $('.message a, #register').click(function(){
        $('form').animate({height: "toggle", opacity: "toggle"}, "slow");
    });

    
    $(".login-form button, .register-form button").click(function(){

       // $(".login-form").submit();
    });


    // Log In
    $("#logIn-btn").click(function(e){

        e.preventDefault();

        if(lemail.val().length == 0 || lpassword.val().length == 0)
        {
            authAlert.html("Campos incompletos.");
            authAlert.attr("class","alert alert-warning");
            authAlert.show();
        }
        else
        {
            var dict = {
                email: lemail.val(),
                password: lpassword.val(),
                csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
            }

            postData("authenticate/login/",dict,function(data){

                if(data.success)
                {
                  location.reload();
                }
                else if(data.fail)
                { 
                  authAlert.attr("class","alert alert-warning");
                  authAlert.html("Usuario y/o contrasena incorrectos.");
                  authAlert.show();
                }
            });
        }
    });

    //Sig up 
    $("#signUp-btn").click(function(e){

        e.preventDefault();

        if(semail.val().length == 0 || spassword.val().length == 0)
        {
            authAlert.html("Campos incompletos.");
            authAlert.attr("class","alert alert-warning");
            authAlert.show();
        }
        else
        {
            var dict = {
                email: semail.val(),
                password: spassword.val(),
                csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
            }

            postData("authenticate/signup/",dict,function(data){

                if(data.exists)
                {
                    authAlert.attr("class","alert alert-warning");
                    authAlert.html("El usuario ya posee una cuenta de acceso.");
                    authAlert.show();
                }
                else if(data.success)
                { 
                    authAlert.attr("class","alert alert-success");
                    authAlert.html("El registro se ha realizado exitosamente, por favor valide su cuenta.");
                    authAlert.show();
                }
                else if(data.fail)
                {
                    authAlert.attr("class","alert alert-danger");
                    authAlert.html(data.fail);
                    authAlert.show();
                }
                else{
                    authAlert.hide();
                }
            });
        }
    });

    $(".message").click(function(){
        authAlert.hide();
    });



   


function getAllContacts()
{
    var dic = {
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

    postData('directories/getAll/',dic,function(data){
        createDirectoriesTableWithData($.parseJSON(data));
    });
}

function createDirectoriesTableWithData(data)
{
    if(data.length == 0)
    {
        console.log("The array is empty.");
        return false;
    }


    var numCol = 4;

    var count = 0; 

    var parent_table = $(".directories_tb");

    parent_table.html("");

    var html;

    for(var i = 0; i < data.length; i++)
    {
        if(count == 0)
            html += '<tr>';

        html += '<td>'
            +'<div class="ui link cards">'
              +'<div class="card" contact-id="'+data[i].id+'" contact-name="'+data[i].name+'"'
              +'contact-img="'+data[i].image+'" contact-rating="'+data[i].rating+'" contact-categoryId="'+data[i].categoryId_id+'"'
              +'contact-desc="'+data[i].description+'">'
                +'<div class="image">'
                  +'<img src="">'
                +'</div>'
                +'<div class="content">'
                  +'<div class="header">'+data[i].name+'</div>'
                  +'<div class="meta">'
                    +'<a id="menu" data-id="'+data[i].id+'">Menu</a>'
                  +'</div>'
                  +'<div class="description">'
                    +data[i].description
                  +'</div>'
                +'</div>'
                +'<div class="extra content">'
                  +'<span class="right floated">'
                    +'<div class="ui star rating" data-rating="'+data[i].rating+'" data-max-rating="5"></div>'
                  +'</span>'
                  +'<a id="comment" data-id="'+data[i].id+'"><span>'
                    +'<i class="comments icon"></i>'
                    +'Comentarios'
                  +'</span></a>'
                +'</div>'
              +'</div>'
              +'</div>'
              +'</td>';

        count++;

        if(count == numCol || i+1 == data.length){
            html += '</tr>';
            count == 0;
        }
    }

    parent_table.append(html);

    $('.ui.rating').rating();

    $(".card").click(function(){

        openConctactModal($(this));
    });
}

function openConctactModal(obj)
{
    var id = obj.attr("contact-id");
    var name = obj.attr("contact-name");
    var image = obj.attr("contact-img");
    var rating = obj.attr("contact-rating");
    var description = obj.attr("contact-desc");
	var category = obj.attr("categoryId");

    var contactModal = $('.contactModal');
    contactModal.modal("show");

    /*appending data*/
    $('.contactModal .header').html(name);
    $('.image content').find('img').prop('src',image);
    $('.contactModal #contact_description').html(description);


	// getting branches
    $('#sucursal_select').html('<option value="">Sucursales</option>');
    $(".branchesTb").html("");

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

            // Seccion sucursales

            $(".branchesTb").append(
                '<tr>'
                    +'<td>'
                        +branchName
                    +'</td>'
                    +'<td>'
                        +branch_info[i].phone
                    +'</td>'
                +'</tr>'
            );

            $("#menu_content").html("");          
       }
    });

    // getting branch menu

    $('#sucursal_select').change(function(){
        
        $("#MenuSelect").html("");
        
        var branchId = $('option:selected', this).attr('branch-id');

        var dic = {
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
            branchId: branchId
        }
        
        postData('directories/getBranchMenu/',dic,function(result){

            var menu = $.parseJSON(result);
            var menu_content = $("#MenuSelect");
            
            for(var i = 0; i < menu.length; i++)
            {
                $('<option>').val(menu[i].description).text(menu[i].description+' - (RD$: '+menu[i].price+')')
                .appendTo(menu_content);
            }
        });  
    });

    $("#addToOrderList").click(function(){

        $("#text_description").val("");

        $("#MenuSelect option").each(function(t)
        {
            if($(this).is(":selected"))
            {
                if($("#tcantidad").val().length > 0)
                {
                    var data = "("+$("#tcantidad").val()+")-"+$(this).val();

                    $("#text_description").val($("#text_description").val()+data+"\n");
                }
            }
        });
        
    });

    $("#doRequest").click(function(){

        var request = $("#text_description").val();

        if(request.length > 0)
        {
            // hace la solicitud del pedido.
            var dic = {
                csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
                userId: "1",
                branchId: "1",
                dataOrder: request,
                status: "pending"
            }

            postData('directories/createOrder/',dic,function(data){

                alert(data);
            });
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


