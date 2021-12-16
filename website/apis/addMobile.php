<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';

$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $email = "";
    if (isset($_POST['email'])) {
        $email = mysqli_real_escape_string($conn, $_POST['email']);
    }
    $mobileName = "";
    if (isset($_POST['mobileName'])) {
        $mobileName = mysqli_real_escape_string($conn, $_POST['mobileName']);
    }
    $mobileNumber = "";
    if (isset($_POST['mobileNumber'])) {
        $mobileNumber = mysqli_real_escape_string($conn, $_POST['mobileNumber']);
    }
    $fcmtoken = "";
    if (isset($_POST['fcmtoken'])) {
        $fcmtoken = mysqli_real_escape_string($conn, $_POST['fcmtoken']);
    }



    $executequery = "INSERT IGNORE INTO `Mobile` (`mobileName`, `mobileNumber`, `email`, `fcmtoken`) VALUES (?, ?, ?, ?);"; //  REPLACE INTO books (id, title, author, year_published) VALUES     (1, 'Green Eggs and Ham', 'Dr. Seuss', 1960);
    $executeparamType = "ssss";
    $executeparamArray = array(
        $mobileName,
        $mobileNumber,
        $email,
        $fcmtoken
    );
    $db->insert($executequery, $executeparamType, $executeparamArray);



    $outputArray = array();
    $outputArray['msg'] = "added";

    print json_encode($outputArray);
}
