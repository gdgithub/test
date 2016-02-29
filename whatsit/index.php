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

<title>What's it?</title></title>

<link rel="stylesheet" href="Styles/Content.css"></link>

<link rel="shortcut icon" href="Images/Icon/icon_1024.png"/> 

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

</head>
 
<body onload="startGame1_onLevel(0);">
    
<noscript>
  <p>What's it?</p>
  <p>Esta pagina requiere para su funcionamiento el uso de JavaScript. 
Si lo has deshabilitado intencionadamente, por favor vuelve a activarlo.</p>
</noscript>

<?php 

    include('Scripts/Methods.php'); 
    
    $class = new Functions();
    
    $JSON_META_PATH = "Game_Content/Content.json";
    
    if(strlen($_COOKIE["username"]) > 0)
    {
        $username = $_COOKIE["username"];
        $password = $_COOKIE["password"];
        
        $JSON_USER_PROGRESS_FILE = "Player_Progress/".$username.$password.".txt";
    }
    else
    {
        $JSON_USER_PROGRESS_FILE = "Player_Progress/default.txt";
    }
    
    $numLevel = $class->getDataFromUserProgress_JSONFile($JSON_USER_PROGRESS_FILE,"level");
    $score = $class->getDataFromUserProgress_JSONFile($JSON_USER_PROGRESS_FILE,"score");

    $level = $class->getDataForLevel_Key_JSONfilePath($numLevel,"Level",$JSON_META_PATH);
    $question = $class->getDataForLevel_Key_JSONfilePath($numLevel,"Question",$JSON_META_PATH);
    $imgPath = $class->getDataForLevel_Key_JSONfilePath($numLevel,"ImgPath",$JSON_META_PATH);
    $answer = $class->getDataForLevel_Key_JSONfilePath($numLevel,"Answer",$JSON_META_PATH);
    $disordered_Answer = $class->getDataForLevel_Key_JSONfilePath($numLevel,"DisorderedAnswer",$JSON_META_PATH);
    
    $levelCount = $class->getLevelCount_JSONFile($JSON_META_PATH);
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
                        <td><center><p><a class="loginButton" href="#">Sign in</a> to continue playing in another device.</p></center></td>
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
                                <table class="statusBar">
                                    <tr>
                                        <td class="tdleft"></td>
                                        
                                        <td class="tdcenter"><p class="level"><?php echo $level; ?></p></td>
                                        
                                        <td class="tdright">
                                            <div>
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <img width="30px" height="30px" src="Images/Others/Corona.png">
                                                        </td>
                                                        <td>
                                                            <p class="score"><?php echo$score;?></p>
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
                        <tr class="trQuestion">
                            <td>
                                <div><p class="question"><?php echo $question; ?></p></div>
                            </td>
                        </tr>
                        <tr class="trImage">
                            <td>
                                <div class="imageDiv"><img id="imgQuestion" style="width:100%;" src="<?php echo $imgPath; ?>"></img></div>
                            </td>
                        </tr>
                        <tr class="trAnswer">
                            <td>
                                <div class="answerDiv">
                                    <table>
                                        <tr>
                                            <td class="tdAnswerOutput">
                                                <table >
                                                    <tr>
                                                        <td><p class="pAnswerOutput"></p></td>
                                                        <td> <img class="imgSuggest" width="30" height="30" src="Images/Others/Help.png" title="Click for get suggests about this question"></img></td>
                                                    </tr>
                                                </table>
                                                
                                                <div class="answerLine"></div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tdAnswerInput">
                                                
                                                <?php
                                                    $class->createAnswerButtonFromStr($disordered_Answer);
                                                ?>
                                                
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
                                <p><b>HOW TO PLAY:</b> Answer the questions above to complete the level. Use the picture to help you find the correct word in the disordered piece below.<br><br><br>
                                <b>SIGN IN:</b> with an username and a password to continue playing your current progress in another device. This game is also available on <span class="footerLink"><a href="https://itunes.apple.com/us/app/whats-it-beyond-your-limits/id1057334731?l=es&ls=1&mt=8"><b>App Store</b></a></span> and very soon on the <span class="footerLink"><a href="https://itunes.apple.com/gb/artist/starlin-gil-cruz/id997164117"><b>Play Store</b></a></span>.<br><br><br>
                                <b>COMMUNITY:</b> Develops levels for the What's it? community around the world. Your contribution will help other people to improve their abilities. You will receive a statistic of all people around the world whom play your own level.<br><br>
                                <span class="communityLevel"><a href="CreateLevel.php">Create level</a></span><br><br>
                                <span class="communityLevel"><a href="Comments/index.php">Community's comments</a></span><br><br>
                                
                                Trader contact: <span class="footerLink"><a href="mailto:starlin.gil.cruz@gmail.com">Starlin Gil Cruz</a></span><br><br>
                                <b>Copyright © 2015 Gildevelopers inc. All Right Reserved.</b>
                                </p>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
    
    <p class="correctAnswer"><?php echo $answer;?></p>
    <p class="levelCount"><?php echo $levelCount;?></p>
    <p class="Au_UserName"><?php echo $username;?></p>
    <p class="Au_Password"><?php echo $password;?></p>
</div> 

<!--defer: permite descargar el fichero .js luego de cargar la pagina (mejor rendimiento)-->
<script type="text/javascript" src="Scripts/Behavior.js" defer="true"></script>

<!--Twitter-->
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>

</body>
</html>