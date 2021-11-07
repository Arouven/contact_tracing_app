<?php
require $_SERVER['DOCUMENT_ROOT'] . '/contact_tracing/website/database.php';


$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $username = "";
    if (isset($_POST['username'])) {
        $username = mysqli_real_escape_string($conn, $_POST['username']);
    }
    $selectquery = "SELECT Mobile.mobileId, Mobile.mobileName, Mobile.mobileDescription, Mobile.mobileNumber FROM Mobile INNER JOIN User ON Mobile.userId = User.userId WHERE User.username = ?;";
    $selectparamType = "s";
    $selectparamArray = array(
        $username
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
