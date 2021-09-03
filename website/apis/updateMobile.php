<?php
require '../database.php';

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

    $executequery = "SELECT Mobile.mobileId, Mobile.mobileName, Mobile.mobileDescription FROM Mobile INNER JOIN User ON Mobile.userId = User.userId WHERE User.username = ?;";
    $executeparamType = "iss";
    $executeparamArray = array(
        $mobileId,
        $mobileName,
        $mobileDescription
    );
    $data = $db->execute($executequery, $executeparamType, $executeparamArray);
    print json_encode($data);


    //$outputArray = array();

    // if (isset($data) && $data != null) { //if there is something in the result
    //     $outputArray['msg'] = "data exist";
    //     $outputArray['mobiles'] = $data;

    //     print json_encode($outputArray);
    // } else {
    //     $outputArray['msg'] = "data does not exist";
    //     print json_encode($outputArray);
    // }
}
