<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';

$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $email = "";
    if (isset($_POST['email'])) {
        $email = mysqli_real_escape_string($conn, $_POST['email']);
    }

    $selectquery = "CALL `GETUSERINFO`('$email');";
    $data = $db->selectStored($selectquery);
    if (isset($data)) {
        print json_encode($data);
    }
}
