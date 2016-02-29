<?php

$user = $_POST['user'];
$rcomment = $_POST['comment'];
$date = $_POST['date'];
$validation = $_POST['GILDEVELOPERS_VALIDATION_C'];
    	
if(strlen($validation) > 0)
{

$comment = "";

for ($i = 0; $i < strlen($rcomment); $i++)
{
    if($rcomment[$i] == '"')
    {
        $comment = $comment . '\"';
        continue;
    }
    $comment = $comment . $rcomment[$i];
}

$json = file_get_contents("Comments/Content.json",0,null,null);

$data = json_decode($json,true);

$count = count($data[Comments][0][All]) + 1;

// Carga el contenido del archivo y concatena el comentario publicado.

$comment_ = '{"User":"'.$user.'","Comment":"'.$comment.'","Date":"'.$date.'"}';

$new_json_content = substr($json,0,-4).","."\n".$comment_."]}]}";


if(file_exists("Comments/Content.json"))
    unlink("Comments/Content.json");
        
$file = fopen("Comments/Content.json","w");

fwrite($file,$new_json_content);
    		
fclose($file);
}

?>