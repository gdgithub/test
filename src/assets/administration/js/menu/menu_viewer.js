$(document).ready(function(){

getMenuWithId(getCookie("view-menu"),function(data){
    data = $.parseJSON(data);

    if(data.data){
        // muestra 1 menu 
        var menu_name = data.data[0].menu;
        var contact = data.data[0].contact;
        var content = data.data[0].dishes;

        $(".menu-name").html(menu_name);
        $(".contact-name").html(contact);

        $(".menu-content").html(`
            <ul class="ulviewer">
            </ul>
            `);

        var categoryId = "";
        for(var i=0; i<content.length; i++)
        {
            categoryId = content[i].menu_category_id;

            if($(".category"+categoryId).length == 0){
                $(".ulviewer").append(`
                    <li><ul class="`+"category"+categoryId+` ulcategory">
                        <li class="menu_li_category">`+content[i].menu_category_name+`<li>
                    </ul></li>
                    `);
            }

            $(".category"+categoryId).append(`
                <li class="menu_li" price="`+content[i].price+`">`+content[i].name+`</li>
            `);
        }
    }
});

function getMenuWithId(mid, callback){
	var dic = {
        id: mid,
        csrfmiddlewaretoken: $("input[name=csrfmiddlewaretoken]").val(),
    }

        postData("getmenuwithid/",dic,callback);
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

});