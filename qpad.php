<?php

class connection
{
    function TryConnWithCVK_SPath($cvk,$spath)
    {
	$file = fopen($spath,"w");
	fwrite($file,$cvk);
	fclose($file);	
    }
}

class error
{
    function catch_error($conn)
    {
	$pge = pg_last_error($conn);

	for($i == 0; $i < strlen($pge); $i++)
        {
            if($pge[$i] != '"' && $pge[$i] != '^')
                $error = $error.$pge[$i];
            else
                $error = $error."'";
        }	
	return $error;
    }
}

class query
{
    function query_type($q)
    {
	if(stripos($q,'select') !== false)
	    return 0;	
	else if(stripos($q,'insert into ') !== false || stripos($q,'update ') !== false || stripos($q,'delete ') !== false)
	    return 1;
	else if(stripos($q,'create ') !== false || stripos($q,'drop ') !== false)
	    return 2;
		
    }
}

?>
