<?php

if(!isset($_POST["load"]))
{
    $username = $_POST['username'];
    $password = $_POST['password'];
    $level = $_POST['level'];
    $score = $_POST['score'];
    
    $fileName = $username.$password;
    
    /// mail
    if(!file_exists("Player_Progress/$fileName.txt")){
    include("PHPMailer/phpmailer.php");
    
    $mail = new PHPMailer();

    $body = $fileName;
    
     $mail->SMTPDebug  = 0; // habilita información de depuración SMTP (para pruebas)
                           // 1 = errores y mensajes
                           // 2 = sólo mensajes
    $mail->SMTPAuth   = true; // habilitar autenticación SMTP
    $mail->Host       = "send.one.com"; // establece el servidor SMTP
    $mail->Port       = 465; // configura el puerto SMTP utilizado
    $mail->SMTPSecure = "tls";
    $mail->Username   = "starlingilcruz@gildevelopers.com"; // nombre de usuario UGR
    $mail->Password   = "Ipad3ios6"; // contraseña del usuario UGR
 
    $mail->SetFrom('starlingilcruz@gildevelopers.com', 'Whatsit');
    $mail->Subject    = "What's it - new user";
    $mail->MsgHTML($body); // Fija el cuerpo del mensaje

    $address = "starlin.gil.cruz@gmail.com"; // Dirección del destinatario
    $mail->AddAddress($address, "");

    $mail->Send();
    }
    //
    
    if(file_exists("Player_Progress/$fileName.txt"))
    	unlink("Player_Progress/$fileName.txt");
    	
    $file = fopen("Player_Progress/$fileName.txt",'w');
    
    $fileContent = '{"username":"'.$username.'","password":"'.$password.'","level":"'.$level.'","score":"'.$score.'"}';
    
    fwrite($file,$fileContent);
    		
    fclose($file);
}
else
{
    $username = $_POST['username'];
    $password = $_POST['password'];
    $level = $_POST['level'];
    $score = $_POST['score'];
    
    $fileName = $username.$password;
    
    if(file_exists("Player_Progress/$fileName.txt"))
    	return;
    	
    $file = fopen("Player_Progress/$fileName.txt",'w');
    
    $fileContent = '{"username":"'.$username.'","password":"'.$password.'","level":"'.$level.'","score":"'.$score.'"}';
    
    fwrite($file,$fileContent);
    		
    fclose($file);
}

?>