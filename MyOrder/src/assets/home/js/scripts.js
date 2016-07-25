$(document).ready(function(){

    var lemail = $(".login-form #temail");
    var lpassword = $(".login-form #tpass");
    var spassword = $(".register-form #tpass");
    var semail = $(".register-form #temail");

    var directories_loader = $("#directory_loader");


    initUserCredentials();
    initializeSearcher();
    getCategories();
    getAllContacts();

    // init
    // default element attr and properties
    $(".login-form #authAlert").hide();
    $(".register-form #authAlert").hide();

    directories_loader.show();

     $(".ui.rating").click(function(){
        var a = $('.ui.rating').rating('get rating');

        alert(a);
    });

    $('.ui.dropdown')
      .dropdown();

    $('.ui.button')
      .popup({});


    $('.ui.modal')
        .modal();
    

    $('.menu .item')
      .tab();

    $('.tabular.menu .item').tab();

    $('.message a, #register').click(function(){
        $('form').animate({height: "toggle", opacity: "toggle"}, "slow");
        $(".login-form #authAlert").hide();
        $(".register-form #authAlert").hide();
    });

    
    $(".login-form button, .register-form button").click(function(){

       // $(".login-form").submit();
    });


    // Log In
    $("#logIn-btn").click(function(e){

        e.preventDefault();

        if(lemail.val().length == 0 || lpassword.val().length == 0)
        {
            $(".login-form #authAlert").html("Campos incompletos.");
            $(".login-form #authAlert").addClass("alert alert-warning");
            $(".login-form #authAlert").show();
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
                    createCookie('userId',lemail.val(),3000);

                  location.reload();
                }
                else if(data.fail)
                { 
                    console.log(data);
                  $(".login-form #authAlert").addClass("alert alert-warning");
                  $(".login-form #authAlert").html("Usuario y/o contraseña incorrectos.");
                  $(".login-form #authAlert").show();
                }
            });
        }
    });

    //Sig up 
    $("#signUp-btn").click(function(e){

        e.preventDefault();

        if(semail.val().length == 0 || spassword.val().length == 0)
        {
            $(".register-form #authAlert").html("Campos incompletos.");
            $(".register-form #authAlert").attr("class","alert alert-warning");
            $(".register-form #authAlert").show();
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
                    $(".register-form #authAlert").attr("class","alert alert-warning");
                    $(".register-form #authAlert").html("El usuario ya posee una cuenta de acceso.");
                    $(".register-form #authAlert").show();
                }
                else if(data.success)
                { 
                    $(".register-form #authAlert").attr("class","alert alert-success");
                    $(".register-form #authAlert").html("El registro se ha realizado exitosamente, por favor valide su cuenta.");
                    $(".register-form #authAlert").show();
                }
                else if(data.fail)
                {
                    $(".register-form #authAlert").attr("class","alert alert-danger");
                    $(".register-form #authAlert").html(data.fail);
                    $(".register-form #authAlert").show();
                }
                else{
                    $(".register-form #authAlert").hide();
                }
            });
        }
    });

    $(".message").click(function(){
        authAlert.hide();
    });


    $("#findButton").click(function(e){

        findContact(e,true);
    });

    $("#orden .menu .item").click(function(){
        
        var value = $(this).attr('data-value');

        getContactOrderBy(value);
    });
    
});

function findContact(e,f=false)
{
    if(e.which == 13 || f) {
        
        $("#directory_loader").show();

        var dic = {
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
            name:$("#tsearch").val()
        }

        postData('directories/findContact/',dic,function(data){

            data = $.parseJSON(data);

            if (data) 
            {   
                createDirectoriesTableWithData(data);
            }
            else
            {

                alert("no data found");
            }
        });
    }
}

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
                .appendTo('#mcategory');
            }
        }
    });
}

function getAllContacts()
{
    var dic = {
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
    }

    postData('directories/getAll/',dic,function(data){

        createDirectoriesTableWithData($.parseJSON(data));
        
    });
}

function getContactOrderBy(orderBy)
{
    var dic = {
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
        order: orderBy
    }

    postData('directories/getContactsOrdered/',dic,function(data){

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
            html += '<ul>';

        html += '<li>'
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
              +'</li>';

        count++;

        if(/*count == numCol || */i+1 == data.length){
            html += '</ul>';
            count == 0;
        }
    }

    $("#directory_loader").hide();

    parent_table.html(html);

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
                userId: getCookie('userId'),
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

function initUserCredentials()
{
    if(getCookie('userId').length > 0)
    {
        //alert();
        //Crea acceso al usuario de acuerdo a sus credenciales

        var dic = {
            email: getCookie('userId'),
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val()
        }

        // Carga las credenciales
        postData('authenticate/userCredentials/',dic,function(data){

            console.log(data.values);
            // access type: 1 - admin, 2 - ff, 3 - dev
            if (data.success) {
                $("#auth-side ul").html(
                    '<li class="manage" access-type="'+data.values.rol_id+'">Bienvenido, '+data.values.email+'</li>'
                    +$("#auth-side ul").html()
                );

                $(".manage").click(function(){

                    createCookie('access-type',data.values.rol_id,3000);

                    if(data.values.rol_id == 1)
                    {
                       // window.location.assign("/uadmin");  
                        window.location.assign("/management");  
                    }
                    else{
                        window.location.assign("/management");
                    }
                   
                });
            }
            else{alert("has occurred an error while loading user credentials");}
        });
    }
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
