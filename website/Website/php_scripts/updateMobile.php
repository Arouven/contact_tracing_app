<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';


// $data = array();
// if (isset($_POST['mobileId'])) {
//     $data['mobileId'] = $_POST['mobileId'];
//     $data['request'] = $_POST['req'];
//     echo json_encode($data);
// } else {
//     echo '<script>alert("else")</script>';
// }
$db = new database();
$conn = $db->getConnection();

$mobileNumber = "";
if (isset($_POST['mobileNumber'])) {
    $mobileNumber = mysqli_real_escape_string($conn, $_POST['mobileNumber']);
}
$req = "";
if (isset($_POST['req'])) {
    $req = mysqli_real_escape_string($conn, $_POST['req']);
}

$executequery = ($req == "reset") ? ("UPDATE Mobile SET Mobile.contactWithInfected = 0, Mobile.confirmInfected = 0, Mobile.dateTimeLastTest = ? WHERE Mobile.mobileNumber = ?;") : ("UPDATE Mobile SET Mobile.contactWithInfected = 1, Mobile.confirmInfected = 1, Mobile.dateTimeLastTest = ? WHERE Mobile.mobileNumber = ?;");
$executeparamType = "is";
$executeparamArray = array(
    time(),
    $mobileNumber
);
$db->execute($executequery, $executeparamType, $executeparamArray);




$outputArray = array();
$outputArray['mobileNumber'] = $mobileNumber;
$outputArray['req'] =   $req;
$outputArray['inserted'] = true;

print json_encode($outputArray);

unset($db);
unset($conn);
