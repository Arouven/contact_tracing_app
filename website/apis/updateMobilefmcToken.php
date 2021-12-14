<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';


$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $mobileId = "";
    if (isset($_POST['mobileId'])) {
        $mobileId = mysqli_real_escape_string($conn, $_POST['mobileId']);
    }

    $fcmtoken = "";
    if (isset($_POST['fcmtoken'])) {
        $fcmtoken = mysqli_real_escape_string($conn, $_POST['fcmtoken']);
    }

    $selectquery = "SELECT Mobile.fcmtoken FROM Mobile WHERE Mobile.fcmtoken = ?;";
    $selectparamType = "s";
    $selectparamArray = array(
        $fcmtoken
    );
    $checkToken = $db->select($selectquery, $selectparamType, $selectparamArray);


    $outputArray = array();
    if (isset($checkToken)) {
        $outputArray['msg'] = "Already Exist";
        $outputArray['error'] = "Your mobile is already in the database";
        print json_encode($outputArray);
    } else {
        $executequery = "UPDATE Mobile SET Mobile.fcmtoken = ? WHERE Mobile.mobileId = ?;";
        $executeparamType = "si";
        $executeparamArray = array($fcmtoken, $mobileId,);
        $db->execute($executequery, $executeparamType, $executeparamArray);
        $outputArray['msg'] = "success";
        print json_encode($outputArray);
    }
}
