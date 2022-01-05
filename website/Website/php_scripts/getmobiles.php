<?php


require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';
header('Content-Type: application/json; charset=utf-8');

$db = new database();
$conn = $db->getConnection();

$email = "";
if (isset($_GET['email'])) {
    $email = mysqli_real_escape_string($conn, $_GET['email']);
}

$selectquery = "SELECT * FROM Mobile WHERE email=?;";
$selectparamType = "s";
$selectparamArray = array($email);
$data = $db->select($selectquery, $selectparamType, $selectparamArray);


// [mobileId] => 4
// [userId] => 2
// [mobileName] => nokia de james
// [mobileDescription] => nokia de james
// [mobileNumber] => +23012345678
// [contactWithInfected] => 0
// [confirmInfected] => 0
// [dateTimeLastTest] => 

if (isset($data) && $data != null) {
    echo json_encode($data);
} else {
    echo json_encode("No Data Found");
}


unset($db);
unset($conn);
