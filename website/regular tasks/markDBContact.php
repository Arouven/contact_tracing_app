<?php
require_once 'distanceCalculator.php';
class markdbcontacted
{
    function __construct()
    {
        $dc = new distanceCalculator(1, 2, 3, 4);
        $dc->distanceMetres();

        //update contact tracing
        //     $infectedMetres = floatval($data[0]['infected']);
        //if (isset($data) && $data != null) { //if there is something in the result
        //     $outputArray['msg'] = "data exist";
        //     //$outputArray['infected'] = $data[0]['infected'];
        //     $infectedMetres = floatval($data[0]['infected']);

        //     //https://www.php.net/manual/en/function.time.php
        //     $noDays = 1;
        //     $searchFrom = time() - ($noDays * 24 * 60 * 60); // xx days; 24 hours; 60 mins; 60 secs
        //     while ($searchFrom < time()) {
        //         $selectquery = "SELECT * FROM Coordinates;"; //<=2m
        //         $data = $db->select($selectquery);
        //         if (isset($data) && $data != null) { //if there is something in the result
        //             $outputArray['msg'] = "data exist";
        //             //$outputArray['infected'] = $data[0]['infected'];
        //             $infectedMetres = floatval($data[0]['infected']);
        //         }
        //         echo '<br>';
        //         echo  $searchFrom = $searchFrom + 1;
        //     }
    }
}
