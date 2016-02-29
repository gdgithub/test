<?php

$root = "gildevelopers.com.mysql";
$user = "gildevelopers_c";
$pass = "aR4Rtdfx";
$database = "gildevelopers_c";

$conexion = @mysql_connect($root,$user,$pass);

if(!(mysql_select_db($database)))
{
	printf("Error al conectar con la base de datos");	
}

?>
