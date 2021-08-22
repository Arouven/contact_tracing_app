<?php
require '../database.php';

$db = new database();
$conn = $db->getConnection();

$testingcenter = null;


$potential = null;
$outputArray = null;
$outputArray = array();

if (isset($_GET['potential'])) {
    $selectquery = "SELECT UNIQUE MAX(dateTimeCoordinates), latitude, longitude FROM Coordinates INNER JOIN Mobile ON Coordinates.mobileId=Mobile.mobileId WHERE Mobile.contactWithInfected=TRUE;";
}

if (isset($_GET['confirmInfected'])) {
    $selectquery = "SELECT UNIQUE MAX(dateTimeCoordinates), latitude, longitude FROM Coordinates INNER JOIN Mobile ON Coordinates.mobileId=Mobile.mobileId WHERE Mobile.confirmInfected=TRUE;";
    $data = $db->select($selectquery);
    if (isset($data) && $data != null) { //if there is something in the result

        $outputArray['msg'] = "data about confirm infected";
        $outputArray['confirmInfected'] = $data; //[0]['confirmInfected'];
        //print json_encode($outputArray);
    } else {
        $outputArray['msg'] = "data does not exist";
        print json_encode($outputArray);
    }
}
if (isset($_GET['testingcenter'])) {
    $selectquery = "SELECT name, address, latitude, longitude FROM TestingCentres;";
    $data = $db->select($selectquery);
    if (isset($data) && $data != null) { //if there is something in the result

        $outputArray['msg'] = "data about testing centres";
        $outputArray['testingcentres'] = $data; //[0]['confirmInfected'];
        //print json_encode($outputArray);
    } else {
        $outputArray['msg'] = "data does not exist";
        print json_encode($outputArray);
    }
}
