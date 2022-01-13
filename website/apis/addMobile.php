<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';

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
    $mobileNumber = "";
    if (isset($_POST['mobileNumber'])) {
        $mobileNumber = mysqli_real_escape_string($conn, $_POST['mobileNumber']);
    }
    $fcmtoken = "";
    if (isset($_POST['fcmtoken'])) {
        $fcmtoken = mysqli_real_escape_string($conn, $_POST['fcmtoken']);
    }



    $selectquery = "SELECT * FROM `Mobile` WHERE mobileNumber=?;";
    $selectparamType = "s";
    $selectparamArray = array($mobileNumber);
    $data = $db->select($selectquery, $selectparamType, $selectparamArray);

    if (isset($data)) {
        $executequery = "UPDATE `Mobile` SET `mobileName`=?, `email`=?, `fcmtoken`=? WHERE `mobileNumber`=?;";
        $executeparamType = "ssss";
        $executeparamArray = array(
            $mobileName,
            $email,
            $fcmtoken,
            $mobileNumber
        );
        $db->execute($executequery, $executeparamType, $executeparamArray);
        $outputArray = array();
        $outputArray['msg'] = "added";
        $outputArray['command'] = 'update';
        print json_encode($outputArray);
    } else {
        $executequery = "INSERT INTO `Mobile` (`mobileName`, `mobileNumber`, `email`, `fcmtoken`) VALUES (?, ?, ?, ?);";
        $executeparamType = "ssss";
        $executeparamArray = array(
            $mobileName,
            $mobileNumber,
            $email,
            $fcmtoken
        );
        $insertedId = $db->insert($executequery, $executeparamType, $executeparamArray);
        $outputArray = array();
        $outputArray['msg'] = "added";
        $outputArray['command'] = 'insert';
        $outputArray['id'] = $insertedId;
        print json_encode($outputArray);
    }
}
