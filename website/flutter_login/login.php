<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';

$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {

    $firebaseuid = "";
    if (isset($_POST['firebaseuid'])) {
        $firebaseuid = mysqli_real_escape_string($conn, $_POST['firebaseuid']);
    }
    $selectquery = "SELECT UNIQUE * FROM User WHERE firebaseuid = ?;";


    $selectparamType = "s";
    $selectparamArray = array(
        $password
    );
    $data = $db->select($selectquery, $selectparamType, $selectparamArray);
    $outputArray = array();

    if (isset($data) && $data != null) { //if there is something in the result
        $outputArray['msg'] = "data exist";
        $outputArray['email'] = $data[0]['email'];
        header("Content-Type:application/json");
        print json_encode($outputArray);
    } else {
        $outputArray['msg'] = "data does not exist";
        header("Content-Type:application/json");
        print json_encode($outputArray);
    }
}

// $db = new database();
// $conn = $db->getConnection();

// $email = "";
// if (isset($_Get['email'])) {
//     $email = mysqli_real_escape_string($conn, $_GET['email']);
// }
// $password = "";
// if (isset($_GET['password'])) {
//     $password = mysqli_real_escape_string($conn, $_GET['password']);
// }
// $selectquery = "SELECT nationalIdNumber, email FROM User WHERE email = ? AND password = ?;";


// $selectparamType = "ss";
// $selectparamArray = array(
//     $email,
//     $password
// );
// $data = $db->select($selectquery, $selectparamType, $selectparamArray);
// $outputArray = array();

// if (isset($data) && $data != null) { //if there is something in the result
//     $outputArray['msg'] = "data exist";
//     $outputArray['nationalIdNumber'] = $data[0]['nationalIdNumber'];
//     $outputArray['email'] = $data[0]['email'];
//     header("Content-Type:application/json");
//     print json_encode($outputArray);
// } else {
//     $outputArray['msg'] = "data does not exist";
//     header("Content-Type:application/json");
//     print json_encode($outputArray);
// }
