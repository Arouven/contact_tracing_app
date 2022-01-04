<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';

$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $email = "";
    if (isset($_POST['email'])) {
        $email = mysqli_real_escape_string($conn, $_POST['email']);
    }
    $firstName = "";
    if (isset($_POST['firstName'])) {
        $firstName = mysqli_real_escape_string($conn, $_POST['firstName']);
    }
    $lastName = "";
    if (isset($_POST['lastName'])) {
        $lastName = mysqli_real_escape_string($conn, $_POST['lastName']);
    }

    $executequery = "UPDATE User SET User.firstName = ?, User.lastName = ? WHERE User.email = ?;";
    $executeparamType = "sss";
    $executeparamArray = array($firstName, $lastName, $email);
    $response =  $db->execute($executequery, $executeparamType, $executeparamArray);



    $outputArray = array();
    $outputArray['msg'] = "success";
    $outputArray['response'] = $response;

    print json_encode($outputArray);
}
