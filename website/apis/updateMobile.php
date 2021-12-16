<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';


$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $mobileNumber = "";
    if (isset($_POST['mobileNumber'])) {
        $mobileNumber = mysqli_real_escape_string($conn, $_POST['mobileNumber']);
    }
    $mobileName = "";
    if (isset($_POST['mobileName'])) {
        $mobileName = mysqli_real_escape_string($conn, $_POST['mobileName']);
    }


    $executequery = "UPDATE Mobile SET Mobile.mobileName = ? WHERE Mobile.mobileNumber = ?;";
    $executeparamType = "ss";
    $executeparamArray = array($mobileName, $mobileNumber);
    $db->execute($executequery, $executeparamType, $executeparamArray);



    $outputArray = array();
    $outputArray['msg'] = "success";

    print json_encode($outputArray);
}
