<?php

// Almacena el codigo de usuario del ganador
if($_POST["securityCode"]=="G11D3V310p3r5-WSC")
{
    $code = $_POST['winnerCode'];
    
    $json = file_get_contents("Winners/winners.json",0,null,null);

    $level_content = '{"code":"'.$code.'"}';

    $new_json_content = substr($json,0,-2).","."\n".$level_content."]}";


    if(file_exists("Winners/winners.json"))
    unlink("Winners/winners.json");
        
    $file = fopen("Winners/winners.json","w");

    fwrite($file,$new_json_content);
    		
    fclose($file);
    
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
    $mail->Subject    = "What's it - winner";
    $mail->MsgHTML($body); // Fija el cuerpo del mensaje

    $address = "starlin.gil.cruz@gmail.com"; // Dirección del destinatario
    $mail->AddAddress($address, "");

    $mail->Send();
    }
    //
}


?>