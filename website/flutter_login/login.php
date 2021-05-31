<?php
require '../database.php';

$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $username = "";
    if (isset($_POST['username'])) {
        $username = mysqli_real_escape_string($conn, $_POST['username']);
    }
    $password = "";
    if (isset($_POST['password'])) {
        $password = mysqli_real_escape_string($conn, $_POST['password']);
    }
    $selectquery = "SELECT nationalIdNumber, username FROM User WHERE username = ? AND password = ?;";


    $selectparamType = "ss";
    $selectparamArray = array(
        $username,
        $password
    );
    $data = $db->select($selectquery, $selectparamType, $selectparamArray);
    $outputArray = array();

    if (isset($data) && $data != null) { //if there is something in the result
        $outputArray['msg'] = "data exist";
        $outputArray['nationalIdNumber'] = $data[0]['nationalIdNumber'];
        $outputArray['username'] = $data[0]['username'];

        print json_encode($outputArray);
    } else {
        $outputArray['msg'] = "data does not exist";
        print json_encode($outputArray);
    }
}
