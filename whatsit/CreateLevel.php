<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="author" content="Gildevelopers.com">
<meta name="description" content="Everything is beyond your limits">

<meta name="apple-itunes-app" content="app-id=1057334731">

<meta property="og:title" content="What's it?"/>
<meta property="og:site_name" content="What's it?"/>
<meta property="og:description" content="Everything is beyond your limits. Careful: this game is extremely addictive!"/>
<meta property="og:image" content=""/>
  
<meta name="twitter:card" content="app" />
<meta name="twitter:site" content="@Gil_developers"/>
<meta name="twitter:title" content="What's it?" />
<meta name="twitter:description" content="Everything is beyond your limits. Careful: this game is extremely addictive!" />
<meta name="twitter:image" content="" />
<meta name="twitter:url" content="http://gildevelopers.com/whatsit/" />
<meta name="twitter:app:name:iphone" content="What's it?">
<meta name="twitter:app:id:iphone" content="1057334731">
<meta name="twitter:app:url:iphone" content="http://gildevelopers.com/whatsit/">
<meta name="twitter:app:name:ipad" content="What's it?">
<meta name="twitter:app:id:ipad" content="1057334731">
<meta name="twitter:app:url:ipad" content="http://gildevelopers.com/whatsit/">

<title>What's it? - Level creator</title></title>

<link rel="stylesheet" href="Styles/Content.css"></link>

<link rel="shortcut icon" href="Images/Icon/icon_1024.png"/> 

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

</head>

<body>
    
<noscript>
  <p>What's it?</p>
  <p>Esta pagina requiere para su funcionamiento el uso de JavaScript. 
Si lo has deshabilitado intencionadamente, por favor vuelve a activarlo.</p>
</noscript>

<?php 
    
    if(strlen($_COOKIE["username"]) > 0)
    {
        $username = $_COOKIE["username"];
        $password = $_COOKIE["password"];
    }
?>

<div class="main_container">
    
    <table class="table_container">
        <tr class="trTitle">
            <td class="tbHeaderL"></td>
            
            <td class="tbHeaderC">
                <p class="pTitle">What's it?<br><span>Everything is beyond your limits </span><a href="https://twitter.com/share" class="twitter-share-button" data-text="What's it? Everything is beyond your limits" data-via="gildevelopers" data-url="http://gildevelopers.com/whatsit/" data-counturl="http://gildevelopers.com/whatsit/"></a></p>
            </td>
            
            <td class="tbHeaderR">
            
            </td>
        </tr>
        <tr class="trLogin">
            <td colspan="3">
                
                <table class="signIn_Tb">
                    <tr>
                        <td><p>Introduce a new level into this big community around the word. Million peoples will can enjoy with your constribution.</p></td>
                    </tr>
                    <tr>
                        <td><center><p><a class="loginButton" href="#">Sign in</a> to receive statictis of players.</p></center></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="logInDiv">
                                <form>
                                    <table>
                                        <tr>
                                            <td><input id="username_input" type="text" placeholder="User name"></input></td>
                                            <td><input id="password_input" type="text" placeholder="Password"></input></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input id="Sign_in" type="button" value="Sign in"></input>
                                            </td>
                                        </tr>
                                    </table>
                                </form>
                            </div>
                        </td>
                    </tr>
                </table>
    
            </td>
        </tr> 
        <tr class="trBody"> 
            <td colspan="3">
                
                <div class="game_container">
                    
                    <table class="table_game">
                        <tr> 
                            <td>
                                <table class="controlBar">
                                    <tr>
                                        <td class="tdleft">
                                            <div>
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <input id="goPlya_ctlv" type="submit" value="PLAY GAME"></input>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                            
                                        </td>
                                        
                                        <td class="tdcenter"></p></td>
                                        
                                        <td class="tdright">
                                            <div>
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <input id="submit_ctlv" type="submit" value="SUBMIT"></input>
                                                        </td>
                                                        <td>
                                                            <input id="cancel_ctlv" type="submit" value="CANCEL"></input>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr><td colspan="3"><div class="sbLine"></div></td></tr>
                                </table>
                            </td>
                        </tr>
                        <tr class="trInputQuestion">
                            <td>
                                <div>
                                    <table>
                                        <tr><td><p>Introduce the question in the field below.</p></td></tr>
                                        <tr>
                                            <td><input class="questionInput" type="text" placeholder="Question"></input></td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr class="trInputImage">
                            <td>
                                <div>
                                    <table>
                                        <tr>
                                            <td>
                                                <p>Introduce an URL of the image. The image have to represent or content the answer of the question.</p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input class="imageURLInput" type="text" onkeyup="setImageFromUrl();" placeholder="URL of the image"></input>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="imageDiv"><img id="imgPreview" style="width:100%;" src="<?php echo $imgPath; ?>"></img></div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr class="trInputAnswer">
                            <td>
                                <div>
                                    <table>
                                        <tr>
                                            <td>
                                                <p>Introduce the correct answer of the question.</p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input class="answerInput" type="text" placeholder="Answer"></input>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                
            </td>
        </tr>
        <tr class="trFooter">
            <td colspan="3">
                <div class="footer">
                    <table class="footer_tb">
                        <tr>
                            <td>
                                <p>
                                <b>Copyright © 2015 Gildevelopers inc. All Right Reserved.</b>
                                </p>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
    
    <p class="Au_Page">crt</p>
    <p class="Au_UserName"><?php echo $username;?></p>
    <p class="Au_Password"><?php echo $password;?></p>
</div> 

<!--defer: permite descargar el fichero .js luego de cargar la pagina (mejor rendimiento)-->
<script type="text/javascript" src="Scripts/Behavior.js" defer="true"></script>

<!--Twitter-->
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>

</body>
</html>