<?php

// Escribe el metadato de cada nivel (cuyos datos son recibidos mediante el post), y los almacena en el archivo JSON del contenido del juego.

$question = $_POST['question'];
//$imgPath = $_POST['imgPath'];
$answer = $_POST['answer'];
$disorderedAnswer = $_POST['disorderedAnswer'];
$creator = $_POST['creator'];
$code = $_POST['code'];

// Almacena la imagen en el servidor
$imgCount = count(glob("Images/Level/{*.jpg,*.gif,*.png,*.jpeg}",GLOB_BRACE));
                
$contents= file_get_contents($_POST['imgPath']);
$savefile = fopen('Images/Level/IMG'.$imgCount.'.jpg', 'w');
fwrite($savefile, $contents);
fclose($savefile);

$imgPath = 'http://www.gildevelopers.com/whatsit/Images/Level/IMG'.$imgCount.'.jpg';

if(strlen($code) > 0)
{
    
$json = file_get_contents("Game_Content/Content.json",0,null,null);

$data = json_decode($json,true);

$count = count($data[App][0][Metadata]) + 1;

// El contenido del nivel creado es recibido mediante el metodo post. La clave 'Code' determina de manera directa quien creo el nivel ( Permite notificar al usuario el numero de su nivel creado).

$level_content = '{"Level":"'.$count.'","Question":"'.$question.'","ImgPath":"'.$imgPath.'","Answer":"'.$answer.'","DisorderedAnswer":"'.$disorderedAnswer.'","Creator":"'.$creator.'","Code":"'.$code.'"}';

$new_json_content = substr($json,0,-4).","."\n".$level_content."]}]}";


if(file_exists("Game_Content/Content.json"))
    unlink("Game_Content/Content.json");
        
$file = fopen("Game_Content/Content.json","w");

fwrite($file,$new_json_content);
    		
fclose($file);
}
    
?>