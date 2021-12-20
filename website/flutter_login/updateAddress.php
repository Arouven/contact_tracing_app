<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';

$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $email = "";
    if (isset($_POST['email'])) {
        $email = mysqli_real_escape_string($conn, $_POST['email']);
    }
    $address = "";
    if (isset($_POST['address'])) {
        $address = mysqli_real_escape_string($conn, $_POST['address']);
    }


    $executequery = "UPDATE User SET User.address = ? WHERE User.email = ?;";
    $executeparamType = "ss";
    $executeparamArray = array($address, $email);
    $response =  $db->execute($executequery, $executeparamType, $executeparamArray);



    $outputArray = array();
    $outputArray['msg'] = "success";
    $outputArray['response'] = $response;

    print json_encode($outputArray);
}
