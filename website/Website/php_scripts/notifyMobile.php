<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/firebase/includes/insert.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';

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

$body = ($req == "reset") ? ("Your status about infected has been reset.") : ("Your status has been changed. You are now marked infected please consult a doctor and perform self isolation.");

$result = new NotifyFirebase(
    $mobileNumber,
    "Status changed!",
    $body
);
//new NotifyFirebase($mobileNumber);
print json_encode($result);
