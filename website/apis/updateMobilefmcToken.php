<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';


$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $mobileNumber = "";
    if (isset($_POST['mobileNumber'])) {
        $mobileNumber = mysqli_real_escape_string($conn, $_POST['mobileNumber']);
    }

    $fcmtoken = "";
    if (isset($_POST['fcmtoken'])) {
        $fcmtoken = mysqli_real_escape_string($conn, $_POST['fcmtoken']);
    }


    $executequery = "UPDATE Mobile SET Mobile.fcmtoken = ? WHERE Mobile.mobileNumber = ?;";
    $executeparamType = "ss";
    $executeparamArray = array($fcmtoken, $mobileNumber);
    $output = $db->execute($executequery, $executeparamType, $executeparamArray);

    if (isset($output)) {
        $outputArray['msg'] = "error";
        $outputArray['error'] =  $output;
    } else {
        $outputArray['msg'] = "success";
    }
    print json_encode($outputArray);
}
