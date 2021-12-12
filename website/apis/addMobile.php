<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';

$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $email = "";
    if (isset($_POST['email'])) {
        $email = mysqli_real_escape_string($conn, $_POST['email']);
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

    $executequery = "CALL InsertMobile(?,?,?,?);";
    $executeparamType = "ssss";
    $executeparamArray = array(
        $email,
        $mobileName,
        $mobileDescription,
        $mobileNumber
    );
    $db->execute($executequery, $executeparamType, $executeparamArray);



    $outputArray = array();
    $outputArray['msg'] = "added";

    print json_encode($outputArray);
}
