<?php

class Functions
{
   // include_once('/customers/4/5/4/gildevelopers.com//httpd.www/Gildevelopers/Connection.php');
   
   function createAnswerButtonFromStr($str)
   {
       echo'<table><tr>';
            
       for($i = 0; $i < strlen($str); $i++)
       {
            echo'
                <td>
                    <input class="letterBtn" type="button" value="'.$str[$i].'"></input>
                </td>
            ';
       }
       echo'</tr></table>';
   }
    
    function CharCombitationFromString($str)
    {
        $strResult = "";
        $arrayPosCharTaken = array();
        $exist = false;
    
        for($i = 0; $i < strlen($str); $i++)
        {
            $randValue = mt_rand(0,1);
            
            if($randValue == 1)
            {
                array_push($arrayPosCharTaken,$i);
                $strResult += $str[$i];
            }
        }
        //print_r($arrayPosCharTaken);
        //echo$strResult;
        
        for($i = 0; $i < strlen($str); $i++)
        {
            for($a = 0; $a < count($arrayPosCharTaken); $a++)
            {
                if($arrayPosCharTaken[$a] == $i)
                {
                    $exist = true;
                    
                }
                else
                {
                    $strResult += $str[$i];
                }
            }
        }
    }
    
    function getDataForLevel_Key_JSONfilePath($level,$key,$url)
    {
        $json = file_get_contents($url,0,null,null);
        $json_output = json_decode($json,true);
        
        $level = $level - 1;
        return $json_output[App][0][Metadata][$level][$key];
    }
    
    function getDataFromUserProgress_JSONFile($urlFile,$key)
    {
        $json = file_get_contents($urlFile,0,null,null);
        $data = json_decode($json,true);
        
        return $data[$key];
    }
    
    function getLevelCount_JSONFile($url)
    {
        $json = file_get_contents($url,0,null,null);
        $json_output = json_decode($json,true);
        
        return count($json_output[App][0][Metadata]);
    }
    
    function getDicComments($url)
    {
        $json = file_get_contents($url,0,null,null);
        $json_decoded = json_decode($json,true);
        
        return $json_decoded[Comments][0][All];
    }
}
    
?>
