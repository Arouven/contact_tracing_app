<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';

$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $email = "";
    if (isset($_POST['email'])) {
        $email = mysqli_real_escape_string($conn, $_POST['email']);
    }
    $dateOfBirth = "";
    if (isset($_POST['dateOfBirth'])) {
        $dateOfBirth = mysqli_real_escape_string($conn, $_POST['dateOfBirth']);
    }

    $executequery = "UPDATE User SET User.dateOfBirth = ? WHERE User.email = ?;";
    $executeparamType = "ss";
    $executeparamArray = array($dateOfBirth, $email);
    $response =  $db->execute($executequery, $executeparamType, $executeparamArray);



    $outputArray = array();
    $outputArray['msg'] = "success";
    $outputArray['response'] = $response;

    print json_encode($outputArray);
}
