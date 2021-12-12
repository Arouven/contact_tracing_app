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

    $executequery = "UPDATE Mobile SET Mobile.fcmtoken = ? WHERE Mobile.mobileId = ?;";
    $executeparamType = "si";
    $executeparamArray = array(
        $fcmtoken,
        $mobileId,
    );
    $db->execute($executequery, $executeparamType, $executeparamArray);



    $outputArray = array();
    $outputArray['msg'] = "success";

    print json_encode($outputArray);
}
