<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';


$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $email = "";
    if (isset($_POST['email'])) {
        $email = mysqli_real_escape_string($conn, $_POST['email']);
    }
    $selectquery = "SELECT Mobile.mobileId, Mobile.mobileName, Mobile.mobileDescription, Mobile.mobileNumber FROM Mobile INNER JOIN User ON Mobile.userId = User.userId WHERE User.email = ?;";
    $selectparamType = "s";
    $selectparamArray = array(
        $email
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
