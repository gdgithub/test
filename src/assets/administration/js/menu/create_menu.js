$(document).ready(function(){

getContacts(function(data){

    data = $.parseJSON(data);
    
    if(data.data.length > 0)
    {
        var content = `<option value="">Seleccionar contacto</option>`;
        for(var i=0; i<data.data.length; i++){
            content += `<option value="`+data.data[i].id+`">`+data.data[i].name+`</option>`;
        }

        $(".select_contact").html(content);
        $('.ui.dropdown').dropdown();
        //$('.ui.dropdown').dropdown({maxSelections: 1});
    }
    else{
        console.log("no contacts");
    }
},"active");
 
 checkIfEditMenu();

$("#menu_form").submit(function(e){
    e.preventDefault();
});

$(".addRow").click(function(){

    var content = `<option value="">Categoria de menu</option>`;
    getMenuCategories(function(data){

        data = $.parseJSON(data);

        for(var i=0; i<data.data.length; i++){
            content += `<option mid="`+data.data[i].id+`">`+data.data[i].description+`</option>`;
        }

        $(".menu_form_content").append(`
            <div class="three fields rows">
                <div class="required field">
                        <input placeholder="Descripcion del plato" class="description" type="text">
                </div>
                <div class="required field">
                        <input placeholder="Precio" class="precio" min="0" type="number">
                </div>
                <div class="required field">
                    <select class="ui search dropdown categoria">
                        `+content+`
                    </select>
                </div>
                <div class="required field">
                    <button class="ui button deleterow">X</button>
                </div>
            </div>`);

        $('.ui.dropdown').dropdown();

        $(".deleterow").click(function(){
            $(this).parent().parent().remove();
        });
    });
});

$(".save").click(function(){
    var titulo = $("#titulo").val();
    var contactId = $(".select_contact option:selected").val();

    if (titulo.length > 0 && contactId.length>0) {
       
        var desc = [];
        var pprice = [];
        var category = [];

        $(".rows").each(function(){
            var d = $(this).find(".description").val();
            var p = $(this).find(".precio").val();
            var c = $(this).find(".categoria option:selected").attr("mid");

            if (d.length>0 && p.length>0 && c.length>0) {
                desc.push(d);
                pprice.push(p);
                category.push(c);
            }
        });

        if (desc.length>0 && pprice.length>0 && category.length>0) {

            var action = ($(".save").attr("editting") == "false")? "savemenu/": "updatemenu/";
            var menuId = (getCookie("tmpacmi").length>0) ? getCookie("tmpacmi") : "-1";

            var dic = {
                mid: menuId,
                menu_title: titulo,
                cid: contactId,
                dishes: desc.join("|"),
                price: pprice.join("|"),
                categ: category.join("|"),
                    csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
                }

            postData(action,dic,function(data){
                data = $.parseJSON(data);
                console.log(data);
                if(data.success){
                    alert("saved");
                    if($(".save").attr("editting") == "false")
                        clearFields();
                }
                else{
                    alert("error");
                }
            });
        }
        else
        {
            alert("must add rows");
        }
    }
    else{
        alert("title o contact");
    }
}); 

$(".reset").click(function(){
    if($(".save").attr("editting") == "false")
        clearFields();
    else
     window.location.href="/administration/menu";
});

function clearFields()
{
    $(".rows").remove();
    $("#titulo").val("");
    $(".select_contact").dropdown("clear");
}

function checkIfEditMenu()
{
    if(getCookie("edit-menu") != "-1")
    {
        $(".save").attr("editting","true");

        var dic = {
            id: getCookie("edit-menu"),
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
        }

        postData("getmenuwithid/",dic,function(data){
            data = $.parseJSON(data);
            console.log(data);

            if(data.data.length == 1){

                $("#titulo").val(data.data[0].menu);
                //$("#titulo").prop('readonly', true);
                $(".select_contact").dropdown("set selected",data.data[0].contactId);

                getMenuCategories(function(category){
                    category = $.parseJSON(category);

                    var content = `<option value="">Categoria de menu</option>`;
                    for(var i=0; i<category.data.length; i++){
                        content += `<option mid="`+category.data[i].id+`" value="`+category.data[i].id+`">`+category.data[i].description+`</option>`;
                    }

                    for(var i=0; i<data.data[0].dishes.length; i++){

                         $(".menu_form_content").append(`
                            <div class="three fields rows">
                                <div class="required field">
                                        <input placeholder="Descripcion del plato" class="description" type="text" value="`+data.data[0].dishes[i].name+`">
                                </div>
                                <div class="required field">
                                        <input placeholder="Precio" class="precio" min="0" type="number" value="`+data.data[0].dishes[i].price+`">
                                </div>
                                <div class="required field">
                                    <select class="ui search dropdown categoria">
                                        `+content+`
                                    </select>
                                </div>
                                <div class="required field">
                                    <button class="ui button deleterow">X</button>
                                </div>
                            </div>`);

                        $('.categoria:last').dropdown("set selected",data.data[0].dishes[i].menu_category_id);

                        $(".deleterow").click(function(){
                                $(this).parent().parent().remove();
                        });
                    }
                        
                });
            }
            else{
                alert("menu id no encontrado.");
            }
        });

        createCookie("tmpacmi",getCookie("edit-menu"),3000);
        deleteCookie("edit-menu");
    }
    else
    {
        $(".save").attr("editting","false");
    }
}

function getContacts(callback, cstatus="non-status"){
    // Non status: retorna todos los contactos sin dif. de estados.
    var dic = {
        status: cstatus,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getcontacts/",dic,callback);
}

function getMenuCategories(callback){
    // Non status: retorna todos los contactos sin dif. de estados.
    var dic = {
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getmenucategories/",dic,callback);
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