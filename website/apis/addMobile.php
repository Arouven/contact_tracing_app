<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';

$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $firebaseuid = "";
    if (isset($_POST['firebaseuid'])) {
        $firebaseuid = mysqli_real_escape_string($conn, $_POST['firebaseuid']);
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


    // -- create stored procedure
    // DELIMITER / / CREATE PROCEDURE InsertMobile(
    //   IN firebaseuid TEXT,
    //   IN mobileName VARCHAR(255),
    //   IN mobileDescription VARCHAR(255),
    //   IN mobileNumber VARCHAR(255),
    //   IN fcmtoken TEXT
    $executequery = "CALL InsertMobile(?,?,?,?,?);";
    $executeparamType = "sssss";
    $executeparamArray = array(
        $firebaseuid,
        $mobileName,
        $mobileDescription,
        $mobileNumber,
        $fcmtoken,
    );
    $db->execute($executequery, $executeparamType, $executeparamArray);



    $outputArray = array();
    $outputArray['msg'] = "added";

    print json_encode($outputArray);
}
