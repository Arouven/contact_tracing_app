<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/firebase/includes/insert.php';

$mobileNumber = "";
if (isset($_POST['mobileNumber'])) {
    $mobileNumber = mysqli_real_escape_string($conn, $_POST['mobileNumber']);
}
$req = "";
if (isset($_POST['req'])) {
    $req = mysqli_real_escape_string($conn, $_POST['req']);
}

$body = ($req == "reset") ? ("Your status about infected has been reset.") : ("Your status has been changed. You are now marked infected please consult a doctor and perform self isolation.");

new NotifyFirebase(
    $mobileNumber,
    "Status changed!",
    $body
);
