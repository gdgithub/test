// What'it?
// JQUERY and JavaScripts

$(document).ready(function(){
    
    var Progresss_Buffer_URL = "http://gildevelopers.com/whatsit/Progress_Buffer.php";
    var Level_Buffer_URL = "http://gildevelopers.com/whatsit/Level_Buffer.php";
    var Comment_Buffer_URL = "http://gildevelopers.com/whatsit/Comment_Buffer.php";
    
    // Animacion de la pagina al iniciar
    $(".main_container").animate({opacity: '1.0'},500);
    $(".game_container").animate({paddingTop:'10px'},500);

    loadUserAuthentication(); // Carga el usuario y contrasena del jugador.
    
    checkUserProgress($("#username_input").val(),$("#password_input").val()); // verifica los cambios en el progreso del jugador, si encuentra diferencias actualiza la pagina.

    // Login
    $(".loginButton,#Sign_in").click(function(){
      
       $(".logInDiv").slideToggle();
    });
    
    $("#Sign_in").click(function(){
        
        createCookie("username",$("#username_input").val());
        createCookie("password",$("#password_input").val());
        
        // Carga o crea un archivo de progreso con la autenticacion del jugador, el nivel y la puntuacion actuales.
        loadUserProgressFile($("#username_input").val(),$("#password_input").val(),$(".level").text(),$(".score").text());
    });

    $(".letterBtn").click(function(){
        
        // valida si se ha presionado la letra, (si: establece opacidad 0.4 y no se podra presionar; no: la opacidad es 1.0 y se podra presionar)
        if($(this, "letterBtn").css('opacity') == 1.0)
        {
            $(this).animate({opacity: '0.4'},250);
           
           var answerOut = $(".pAnswerOutput");
           
            answerOut.text(answerOut.text() + $(this).val());
            
            if(answerOut.text() == $(".correctAnswer").text())
            {
                answerOut.css({opacity: '0.0'});
                answerOut.animate({opacity:'1.0'},500);
                answerOut.text("EXCELENT!");
                
                var explode = function(){
                    
                    answerOut.css({opacity: '0.0'}); 
                    answerOut.animate({opacity:'1.0'},500);
                    answerOut.text("SIGUIENTE");
                };
    
                setTimeout(explode, 2000);
            }
        }
    });
    
    // Si se presiona sobre el string de resultado (la respuesta) esta se eliminara y establecera la opacidad 1.0 en los input (las letras)
    $(".pAnswerOutput").click(function(){
        
        if($(".pAnswerOutput").text() != "SIGUIENTE")
        {
            $("input").animate({opacity: '1.0'},250);
            $(".pAnswerOutput").text("");
        }
        else
        {
            var level = parseInt($(".level").text()) + 1;
            var score = (((parseInt($(".levelCount").text()) / (level - 1)) % 5) + parseInt($(".score").text()) + 10);
          
            score = parseInt(score);
            
            // Crea un usuario anonimo para el jugador si este no ha iniciado sesion. Cuando el juego inicia por primera vez, carga el archivo de progreso 'default', cuando el jugador gana la partida, se le genera un registro unico al usuario.
            if($(".Au_UserName").text() == "")
            {
                var pwd = generateUserCode();
                
                createCookie("username","X060413ANoNiMouS");
                createCookie("password",pwd);
                
                createUserProgressFile("X060413ANoNiMouS",pwd,level,score);
            }
          
            $.post(Progresss_Buffer_URL,{username:getCookieValue("username"),password:getCookieValue("password"),level:level,score:score},
            function(data){
              
                  location.reload();
            });
        }
    });

    
    // Boton sugerencia - Animacion
    
    var imgSuggest = $(".imgSuggest");
    
    imgSuggest.hover(function(){
        
        $(this).animate({width:'40px', height:'40px', opacity:'1.0'},100);
    });
    
    imgSuggest.mouseleave(function(){
        
        $(this).animate({width:'35px', height:'35px', opacity:'0.8'},100);
    });
    
    imgSuggest.click(function(){
        
        var imageview = $("#imgQuestion");
        
        if(imageview.css('opacity') === "0")
        {
            imageview.animate({opacity:"1.0"},300);
        }
        else
        {
            imageview.animate({opacity:"0.0"},300);
        }
        
        
    });
  
  
   // LEVEL CREATOR
   
   // Submit - Crear nuevo nivel
   $("#submit_ctlv").click(function(){
       
       var date = new Date();
      
       var question = $(".questionInput").val();
       var imageURL = $(".imageURLInput").val();
       var answer = $(".answerInput").val().toUpperCase();
       var disorderedAnswer = rewriteString(answer);
       var creator = $("#username_input").val() + $("#password_input").val();
       var code = creator+""+date.getHours()+""+date.getMinutes()+""+date.getSeconds();
        
       if(question.length > 0 && imageURL.length > 0 && answer.length > 0)
       {
          $.post(Level_Buffer_URL,{question:question,imgPath:imageURL,answer:answer,disorderedAnswer:disorderedAnswer,creator:creator,code:code},
          function(data){
              location.reload();
          });
       }
       else
       {
           alert("Sorry, you have to complete the information required below.");
       }
     
   });
   
   setDefaultImage_LC(); // Image preview por default
   
   // Cancel - Crear nuevo nivel
   $("#cancel_ctlv").click(function(){
       $(".questionInput").val("");
       $(".imageURLInput").val("");
       $(".answerInput").val("");
   });
   
   // Cambia la ruta de la imagen introducida en el input
   $(".imageURLInput").bind("change paste keyup", function() {
        $("#imgQuestion").attr('src',$(".imageURLInput").val());
    });
   
   // Ajuste div principal al tamano de la pantalla (width < 1000: Dispositivos moviles)
   if($(document).width() < 1000)
   {
        $('.table_game').width($(document).width() - 100); // Dispositivos moviles
   }
   
   // Play Game - redirecciona a la pagina principal
   $("#goPlya_ctlv").click(function(){
       
       location.replace("http://gildevelopers.com/whatsit");
   });
   
   
   /* COMMENTS */
   
   $("#post_comment").click(function(){
       alert("Sorry, you have not wrote any message to post.");
       var _comment = $(".tcomment").val();
       var _name = $(".tname").val();
       var _date = new Date();
       var _dateVal = _date.getMonth() + "/" + _date.getDay() + "/" + _date.getYear() + "/ " + _date.getHours() + ":" + _date.getMinutes(); + ":" + _date.getSeconds(); 
       
       if(_comment.length > 0)
       {
           $.post(Comment_Buffer_URL,{user:_name,comment:_comment,date:_dateVal,GILDEVELOPERS_VALIDATION_C:"000"},
          function(data){
              location.reload();
          });
       }
       else
       {
           alert("Sorry, you have not wrote any message to post.");
       }
   });
    
});

function checkUserProgress(user,pass)
{
    aux_page = $(".Au_Page").html(); // verifica que la pagina actual no sea -- create level
    
    if(user.length > 0 && pass.length > 0 && aux_page != "crt")
    {
        var check = function(){
            
            $.getJSON("http://gildevelopers.com/whatsit/Player_Progress/"+user+pass+".txt", function(data){
                
                if(parseInt($(".level").text()) != parseInt(data.level))
                {
                    location.reload();
                }
            });
    
            setTimeout(checkUserProgress(user,pass), 200);
        };
        
        setTimeout(check, 200);
    }
}

function setImageFromUrl()
{
    document.getElementById("imgPreview").src = document.getElementsByClassName("imageURLInput")[0].value;
}

function setDefaultImage_LC()
{
    $("#imgPreview").attr('src',"http://gildevelopers.com/whatsit/Images/Others/placeholder.png")
}

function loadUserAuthentication()
{
        // Carga las cookies con la autenticacion del jugador
    if($(".Au_UserName").text().length > 0)
    {
        if($(".Au_UserName").text() != "X060413ANoNiMouS")
        {
            $("#username_input").val($(".Au_UserName").text());
            $("#password_input").val($(".Au_Password").text());
        }
    }
}

function createUserProgressFile(username, password, level, score)
{
    // Crea el archivo de progreso del jugador con los valores por defectos
    $.post("http://gildevelopers.com/whatsit/Progress_Buffer.php",{username:username,password:password,level:level,score:score},
        function(data){
                  
            location.reload();
        });
}

function loadUserProgressFile(username, password, level, score)
{
    $.post("http://gildevelopers.com/whatsit/Progress_Buffer.php",{username:username,password:password,level:level,score:score,load:"YES"},
        function(data){
                  
            location.reload();
        });
}

function createCookie(name, value) 
{
    document.cookie = name + "=" + value + "; expires=1000000000";
}

function rewriteString(string)
{ 
    var result="";
    var letters = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ1234567890";
    
    for (var i = 0; i < letters.length; i++)
    {
        for (var j = 0; j < string.length; j++)
        {
            if(letters[i] == string[j])
            {
                result = result+string[j];
            }
        }
    }
    return result;
}

function getCookieValue(name) 
{
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
}

function generateUserCode()
{
    var _date = new Date();
    
    var code = _date.getHours() +""+ _date.getMinutes() +""+  _date.getSeconds() +""+  _date.getMonth() +""+  _date.getDay() +""+  _date.getYear() +""+  _date.getMilliseconds();
    
    return code;
}


