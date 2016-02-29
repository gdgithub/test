<?php
// Tansfer-SQL Server
// Version: 1.0
// Copyright 2015 Gildevelopers, Inc. All Right Reserved.

// Instructions:
/*
1. Unzip and paste the whole transfer-sql folder in the apache root path.
2. Enpare the client and server host.
3. Make sure to give the corresponding permission to the server..
4. Make sure to have at least the PHP 5 version.
*/

$host = $_POST['host'];
$port = $_POST['port'];
$dbname = $_POST['dbname'];
$user = $_POST['user'];
$password = $_POST['password'];
$query = $_POST['query'];
$token = $_POST['token']; 
$tokeExpTime = $_POST['tokenexptime'];
$chost_type = $_POST['chost_type'];
$cvk = $_POST['convalkey'];
 
// paths
$server = "server";
$server_debug = "$server/debug";
$responses = "response";

// tree
if(!file_exists($server))
    mkdir($server);
if(!file_exists($server_debug))
    mkdir($server_debug);
if(!file_exists($reponses))
    mkdir($responses);

// imports
include("etc/qpad.php");

$_cch = new connection(); // class connection handle 
$_qeh = new error(); // query error handle
$_qtvh = new query(); // query type validation handle

// test server connection
if(strlen($cvk)>0)
{
    $_cch->TryConnWithCVK_SPath($cvk,"$server_debug/con.text");      
    return;
}

$_data = ""; // data fetched from the table.

if($chost_type == "psql")
{
    $connection = pg_connect("host=$host port=$port dbname=$dbname user=$user password=$password") or die("has occurred an error while trying to connect to the database.");

    $data = pg_query($connection,$query);
  
    if($data){
	if($_qtvh->query_type($query) == 0){
     	    while($r = pg_fetch_assoc($data)){
        	$_data = $_data.",\n".json_encode($r);}
	}
	else if($_qtvh->query_type($query) == 1)
	{
	    $_data = ',{"affected_rows_'.$token.'":"'.pg_affected_rows($data).'"}';
	}
	else if($_qtvh->query_type($query) == 2)
	{
	    $_data = ',{"notice_'.$token.'":"'.pg_last_notice($connection).'"}';
	}
    }else
    {
	$error = $_qeh->catch_error($connection);	  
	$_data = ',{"error_'.$token.'":"'.$error.'"}';
    }
    pg_close($connection);
}
else if($chost_type == "mysql")
{
    $connection = @mysql_connect($host,$user,$password);
    if(!mysql_select_db($dbname))
        echo"has occurred an error while trying to connect to the database.";

    $data = mysql_query($query,$connection);
    

    if($data){
        if($_qtvh->query_type($query) == 0){
            while($r = mysql_fetch_assoc($data)){
                $_data = $_data.",\n".json_encode($r);}
        }
        else if($_qtvh->query_type($query) == 1)
        {
            $_data = ',{"affected_rows_'.$token.'":"'.mysql_affected_rows($data).'"}';
        }
        else if($_qtvh->query_type($query) == 2)
        {
            $_data = ',{"notice_'.$token.'":"'.pg_last_notice($connection).'"}';
        }
    }else
    {
        $error = $_qeh->catch_error($connection);         
        $_data = ',{"error_'.$token.'":"'.$error.'"}';
    }

    mysql_close($connection_);  
}

//creating json text  
$_data = substr($_data,1,strlen($_data) - 1);

$_data = '{"data":['.$_data.']}';

// writer   
$data_file = fopen("$responses/$token.text","w");

fwrite($data_file,$_data);    

fclose($data_file);

//exec("sudo rm -f response/*");
?>
