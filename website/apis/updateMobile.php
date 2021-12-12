<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';


$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $mobileId = "";
    if (isset($_POST['mobileId'])) {
        $mobileId = mysqli_real_escape_string($conn, $_POST['mobileId']);
    }
    $mobileName = "";
    if (isset($_POST['mobileName'])) {
        $mobileName = mysqli_real_escape_string($conn, $_POST['mobileName']);
    }
    $mobileDescription = "";
    if (isset($_POST['mobileDescription'])) {
        $mobileDescription = mysqli_real_escape_string($conn, $_POST['mobileDescription']);
    }
    $mobileNumber = "";
    if (isset($_POST['mobileNumber'])) {
        $mobileNumber = mysqli_real_escape_string($conn, $_POST['mobileNumber']);
    }
    $fcmtoken = "";
    if (isset($_POST['fcmtoken'])) {
        $fcmtoken = mysqli_real_escape_string($conn, $_POST['fcmtoken']);
    }

    $executequery = "UPDATE Mobile SET Mobile.mobileName = ?, Mobile.mobileDescription = ?, Mobile.mobileNumber = ?, Mobile.fcmtoken = ? WHERE Mobile.mobileId = ?;";
    $executeparamType = "ssssi";
    $executeparamArray = array(
        $mobileName,
        $mobileDescription,
        $mobileNumber,
        $fcmtoken,
        $mobileId,
    );
    $db->execute($executequery, $executeparamType, $executeparamArray);



    $outputArray = array();
    $outputArray['msg'] = "success";

    print json_encode($outputArray);
}
