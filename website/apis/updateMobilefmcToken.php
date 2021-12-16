<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';


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

    // $selectquery = "SELECT Mobile.fcmtoken FROM Mobile WHERE Mobile.fcmtoken = ?;";
    // $selectparamType = "s";
    // $selectparamArray = array(
    //     $fcmtoken
    // );
    // $checkToken = $db->select($selectquery, $selectparamType, $selectparamArray);


    // $outputArray = array();
    // if (isset($checkToken)) {
    //     $outputArray['msg'] = "Already Exist";
    //     $outputArray['error'] = "Your mobile is already in the database";
    //     print json_encode($outputArray);
    // } else {
    $executequery = "UPDATE Mobile SET Mobile.fcmtoken = ? WHERE Mobile.mobileNumber = ?;";
    $executeparamType = "ss";
    $executeparamArray = array($fcmtoken, $mobileNumber);
    $output = $db->execute($executequery, $executeparamType, $executeparamArray);
    $outputArray['msg'] = "success";
    $outputArray['error'] =  $output;
    print json_encode($outputArray);
    // }
}
