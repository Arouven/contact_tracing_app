<?php


require_once '../database.php';
$db = new database();
$conn = $db->getConnection();

$files = glob('csvFiles/*.{csv}', GLOB_BRACE);
foreach ($files as $file) {
    //do your work here
    $inserted = array();

    $f = fopen($file, "r");

    while (($column = fgetcsv($f, 10000, ",")) !== FALSE) {

        $mobileId = "";
        if (isset($column[0])) {
            $mobileId = mysqli_real_escape_string($conn, $column[0]);
        }
        $dateTime = "";
        if (isset($column[1])) {
            $dateTime = mysqli_real_escape_string($conn, $column[1]);
        }
        $latitude = "";
        if (isset($column[2])) {
            $latitude = mysqli_real_escape_string($conn, $column[2]);
        }
        $longitude = "";
        if (isset($column[3])) {
            $longitude = mysqli_real_escape_string($conn, $column[3]);
        }
        $accuracy = "";
        if (isset($column[4])) {
            $accuracy = mysqli_real_escape_string($conn, $column[4]);
        }

        $sqlInsert = "INSERT into Coordinates (mobileId,dateTimeEpoch,latitude,longitude,accuracy)
                values (?,?,?,?,?)";
        $paramType = "issss";
        $paramArray = array(
            $mobileId,
            $dateTime,
            $latitude,
            $longitude,
            $accuracy
        );
        $insertId = $db->insert($sqlInsert, $paramType, $paramArray);

        if (!empty($insertId)) {
            $type = "success";
            $message = "CSV Data Imported into the Database";
            array_push($inserted, true);
        } else {
            $type = "error";
            $message = "Problem in Importing CSV Data";
            array_push($inserted, false);
        }
    }
    if (in_array(false, $inserted)) {
        //echo '';
    } //do not delete the file
    else {
        unlink($file);
    }
}


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