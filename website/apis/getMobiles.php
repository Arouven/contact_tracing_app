<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';


$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $firebaseuid = "";
    if (isset($_POST['firebaseuid'])) {
        $firebaseuid = mysqli_real_escape_string($conn, $_POST['firebaseuid']);
    }
    $selectquery = "SELECT Mobile.mobileId, Mobile.mobileName, Mobile.mobileDescription, Mobile.mobileNumber, Mobile.fcmtoken FROM Mobile INNER JOIN User ON Mobile.userId = User.userId WHERE User.firebaseuid = ?;";
    $selectparamType = "s";
    $selectparamArray = array(
        $firebaseuid
    );
    $data = $db->select($selectquery, $selectparamType, $selectparamArray);
    $outputArray = array();

    if (isset($data) && $data != null) { //if there is something in the result
        $outputArray['msg'] = "data exist";
        $outputArray['mobiles'] = $data;

        print json_encode($outputArray);
    } else {
        $outputArray['msg'] = "data does not exist";
        print json_encode($outputArray);
    }
}
