<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';


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

$mobileId = "";
if (isset($_POST['mobileId'])) {
    $mobileId = mysqli_real_escape_string($conn, $_POST['mobileId']);
}
$req = "";
if (isset($_POST['req'])) {
    $req = mysqli_real_escape_string($conn, $_POST['req']);
}

$executequery = ($req == "reset") ? ("UPDATE Mobile SET Mobile.contactWithInfected = 0, Mobile.confirmInfected = 0, Mobile.dateTimeLastTest = ? WHERE Mobile.mobileId = ?;") : ("UPDATE Mobile SET Mobile.contactWithInfected = 1, Mobile.confirmInfected = 1, Mobile.dateTimeLastTest = ? WHERE Mobile.mobileId = ?;");
$executeparamType = "ii";
$executeparamArray = array(
    time(),
    $mobileId
);
$db->execute($executequery, $executeparamType, $executeparamArray);




$outputArray = array();
$outputArray['mobileid'] = $mobileId;
$outputArray['req'] =   $req;
$outputArray['inserted'] = true;

print json_encode($outputArray);

unset($db);
unset($conn);
