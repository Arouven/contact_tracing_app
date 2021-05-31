<?php
require '../database.php';
$db = new database();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $nationalIdNumber = "";
    if (isset($_POST['nationalIdNumber'])) {
        $nationalIdNumber = mysqli_real_escape_string($conn, $_POST['nationalIdNumber']);
    }
    $password = "";
    if (isset($_POST['password'])) {
        $password = mysqli_real_escape_string($conn, $_POST['password']);
    }

    $selectquery = "SELECT * FROM User WHERE nationalIdNumber = '?' AND password = '?';";
    $selectparamType = "ss";
    $selectparamArray = array(
        $nationalIdNumber,
        $password,
    );
    $data = $db->select(query: $selectquery, paramType: $insertparamType, paramArray: $selectparamArray);

    if (isset($data) && $data != null) { //if there is something in the result
        echo json_encode($data);
    }
}
