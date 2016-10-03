$(document).ready(function(){

getFireFighters(function(data){

    data = $.parseJSON(data);
    console.log(data);

    if(data.data.length > 0)
    {
        var content = `<option value="">Seleccione el usuario encargado</option>`;
        for(var i=0; i<data.data.length; i++){
            content += `<option value="`+data.data[i].uid+`">`+data.data[i].first_name+" "+ data.data[i].last_name+`</option>`;
        }

        $(".select_groups").html(content);
        $('.ui.dropdown').dropdown();
    }
    else{
        console.log("no groups");
    }
});
 
 checkIfEditGroup();

$("#groups_form").submit(function(e){
    e.preventDefault();
});

$(".addRow").click(function(){

    var content = `<option value="">Introduzca el nombre del integrante</option>`;
    getDevUsers(function(data){

        data = $.parseJSON(data);

        for(var i=0; i<data.data.length; i++){
            content += `<option gid="`+data.data[i].uid+`">`+data.data[i].first_name+" "+ data.data[i].last_name+`</option>`;
        }

        $(".groups_form_content").append(`
            <div class="one fields rows">
                <div class="required field">
                    <select class="ui search dropdown groups">
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
    var group_name = $("#nombre-grupo").val();
    var ff = $(".select_groups option:selected").val();

    if (group_name.length > 0 && ff.length>0) {
       
        var user = [];

        $(".rows").each(function(){
            var dev_user = $(this).find(".groups option:selected").attr("gid");

            if (dev_user.length>0) {
                user.push(dev_user);
            }
        });

        if (user.length>0) {

            var action = ($(".save").attr("editting") == "false")? "savegroup/": "updategroup/";
            var groupId = (getCookie("tmpgna").length>0) ? getCookie("tmpgna") : "-1"; // for update

            var dic = {
                gid: groupId,
                name: group_name,
                firefighter: ff,
                user: user.join("|"),
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
     window.location.href="/administration/groups";
});

function clearFields()
{
    $(".rows").remove();
    $("#nombre-grupo").val("");
    $(".select_groups").dropdown("clear");
}

function checkIfEditGroup()
{
    if(getCookie("edit-group") != "-1")
    {
        $(".save").attr("editting","true");

        var dic = {
            id: getCookie("edit-group"),
            csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
        }

        postData("getgroupwithid/",dic,function(data){
            data = $.parseJSON(data);
            console.log(data);

            if(data.data.length == 1){

                $("#nombre-grupo").val(data.data[0].name);
                $(".select_groups").dropdown("set selected",data.data[0].firefighter);

                getDevUsers(function(dev){
                    dev = $.parseJSON(dev);

                    var content = `<option value="">Introduzca el nombre del integrante</option>`;
                    for(var i=0; i<dev.data.length; i++){
                        content += `<option value="`+dev.data[i].uid+`" gid="`+dev.data[i].uid+`">`+dev.data[i].first_name+" "+ dev.data[i].last_name+`</option>`;
                    }

                    for(var i=0; i<data.data[0].members.length; i++){

                         $(".groups_form_content").append(`
                            <div class="one fields rows">
                                <div class="required field">
                                    <select class="ui search dropdown groups">
                                        `+content+`
                                    </select>
                                </div>
                                <div class="required field">
                                    <button class="ui button deleterow">X</button>
                                </div>
                            </div>`);

                        $('.groups:last').dropdown("set selected",data.data[0].members[i].userId);

                        $(".deleterow").click(function(){
                                $(this).parent().parent().remove();
                        });
                    }
                });
            }
            else{
                alert("group id no encontrado.");
            }
        });

        createCookie("tmpgna",getCookie("edit-group"),3000);
        deleteCookie("edit-group");
    }
    else
    {
        $(".save").attr("editting","false");
        deleteCookie("tmpgna");
    }
}

function getFireFighters(callback){
    var dic = {
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getfirefighters/",dic,callback);
}

function getDevUsers(callback){
    var dic = {
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

    postData("getdevusers/",dic,callback);
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