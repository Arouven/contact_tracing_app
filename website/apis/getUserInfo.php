<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';

$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $email = "";
    if (isset($_POST['email'])) {
        $email = mysqli_real_escape_string($conn, $_POST['email']);
    }
    // $email = "";
    // if (isset($_GET['email'])) {
    //     $email = $_GET['email'];
    // }

    // $executequery = "CALL InsertMobile(?,?,?,?);";
    // $executeparamType = "ssss";
    // $executeparamArray = array(
    //     $username,
    //     $mobileName,
    //     $mobileDescription,
    //     $mobileNumber
    // );
    // $db->execute($executequery, $executeparamType, $executeparamArray);



    $selectquery = "CALL `GETUSERINFO`('$email');";
    $data = $db->selectStored($selectquery);
    if (isset($data)) {
        print json_encode($data);
    }
}
