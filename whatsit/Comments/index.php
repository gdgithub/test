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

<title>What's it? - comments</title></title>

<link rel="stylesheet" href="../Styles/Content.css"></link>

<link rel="shortcut icon" href="../Images/Icon/icon_1024.png"/> 

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

</head>
 
<body>
    
<noscript>
  <p>What's it?</p>
  <p>Esta pagina requiere para su funcionamiento el uso de JavaScript. 
Si lo has deshabilitado intencionadamente, por favor vuelve a activarlo.</p>
</noscript>

<?php 
    
    $JSON_META_PATH = "Content.json";
    
    include("../Scripts/Methods.php");
    
    $class = new Functions();
    
    $comments_Dic = $class->getDicComments($JSON_META_PATH);
    
    //echo$comments_Dic[User];
    
?>

<div class="main_container">
    
    <table class="table_container">
        <tr class="trTitle">
            <td class="tbHeaderL"></td>
            
            <td class="tbHeaderC">
                <p class="pTitle">What's it?<br><span>Everything is beyond your limits </span><a href="https://twitter.com/share" class="twitter-share-button" data-text="Check out 'What's it?', beyond your limits" data-via="gildevelopers" data-url="http://gildevelopers.com/whatsit/" data-counturl="http://gildevelopers.com/whatsit/"></a></p>
            </td>
            
            <td class="tbHeaderR">
            
            </td>
        </tr>
        <tr class="trLogin">
            <td colspan="3">
                
                <table class="signIn_Tb">
                    <tr>
                        <td>
                            <center><p>Share with this big community what has been for you this game, your concerns and your experience with our game.</p></center>
                        </td>
                    </tr>
                </table>
    
            </td>
        </tr> 
        <tr class="trBody"> 
            <td colspan="3">
                
                <div class="game_container">
                    
                    <table class="table_comments">
                        <tr>
                            <td>
                                <table class="statusBar">
                                    <tr>
                                        <td class="tdleft_comments">
                                            <div>
                                                <table>
                                                    <tr>
                                                        <td><p>Name:</p></td>
                                                        <td><textarea class="tname" ></textarea></td>
                                                        <td><p>Comment:</p></td>
                                                        <td><textarea class="tcomment" ></textarea></td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </td>
                                        
                                        <td class="tdright_comments">
                                            <table>
                                                    <tr><td><input id="post_comment" type="submit" value="POST COMMENT"></input></td></tr>
                                                    
                                            </table>
                                        </td>
                                    </tr>
                                    <tr><td colspan="3"><div class="sbLine"></div></td></tr>
                                </table>
                            </td>
                        </tr>
                        <tr class="trQuestion">
                            <td>
                                <table class="mainTbComments">
                                    
                                    <?php
                                    
                                    for ($i = 0; $i< count($comments_Dic); $i++)
                                    {
                                        echo'<tr>
                                        <td>
                                        <table class="tbUserComments">
                                        <tr><td><p class="username_c">'.$comments_Dic[$i][User].'</p><p class="date_c">'.$comments_Dic[$i][Date].'</p>
                                        <p class="usercomment">'.$comments_Dic[$i][Comment].'<br><div class="sbLine_c"></div></p></td></tr>
                                        
                                        </table>
                                        </td></tr>';
                                    }
                                    
                                    ?>
                                </table>
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
                                <p><b>Copyright © 2015 Gildevelopers inc. All Right Reserved.</b></p>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
</div> 

<!--defer: permite descargar el fichero .js luego de cargar la pagina (mejor rendimiento)-->
<script type="text/javascript" src="../Scripts/Behavior.js" defer="true"></script>

<!--Twitter-->
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>

</body>
</html>