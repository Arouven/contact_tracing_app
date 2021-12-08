<?php


require $_SERVER['DOCUMENT_ROOT'] . '/database.php';
header('Content-Type: application/json; charset=utf-8');

$db = new database();
$conn = $db->getConnection();

$userid = "";
if (isset($_GET['userid'])) {
    $userid = mysqli_real_escape_string($conn, $_GET['userid']);
}

$selectquery = "SELECT * FROM Mobile WHERE userId=?;";
$selectparamType = "i";
$selectparamArray = array($userid);
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
