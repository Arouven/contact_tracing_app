<?php
require '../database.php';


$output = array();
$selectquery = "SELECT name, address, latitude, longitude FROM TestingCentres;";
$title = 'testingcentres';
$output = array_merge(getArray($selectquery, $title), $output);
$selectquery = 'SELECT mt.mobileId, ct.longitude, ct.latitude, ct.MaxDateTime FROM Mobile mt INNER JOIN( SELECT mobileId, longitude, latitude, MAX(dateTimeCoordinates) AS MaxDateTime FROM Coordinates GROUP BY mobileId ) ct ON mt.mobileId = ct.mobileId WHERE mt.contactWithInfected = TRUE';
$title = 'contactWithInfected';
$output = array_merge(getArray($selectquery, $title), $output);
$selectquery = 'SELECT mt.mobileId, ct.longitude, ct.latitude, ct.MaxDateTime FROM Mobile mt INNER JOIN( SELECT mobileId, longitude, latitude, MAX(dateTimeCoordinates) AS MaxDateTime FROM Coordinates GROUP BY mobileId ) ct ON mt.mobileId = ct.mobileId WHERE mt.confirmInfected = TRUE';
$title = 'confirmInfected';
$output = array_merge(getArray($selectquery, $title), $output);
if (isset($output) && $output != null) { //if there is something in the result
    $item1 = array('status' => "200", 'msg' => "OK");
    $output = array_merge($item1, $output);
} else {
    $item1 = array('status' => "400", 'msg' => "missing parameters");
    $output = array_merge($item1, $output);
}
header("Content-Type:application/json");
//header("HTTP/1.1 $status $statusMessage");
print json_encode($output);



function getArray($selectquery, $outputTitle)
{
    $db = new database();
    $data = $db->select($selectquery);
    $outputArray = array();

    if (isset($data) && $data != null) { //if there is something in the result
        $outputArray[$outputTitle] = $data;
    }
    return $outputArray;
};