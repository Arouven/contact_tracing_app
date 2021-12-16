<?php
// require $_SERVER['DOCUMENT_ROOT'] . '/database.php';

// $db = new database();
// $conn = $db->getConnection();

// if ($_SERVER['REQUEST_METHOD'] == "POST") {
// 	$email = "";
// 	if (isset($_POST['email'])) {
// 		$email = mysqli_real_escape_string($conn, $_POST['email']);
// 	}
// 	$selectquery = "SELECT email FROM User WHERE email = ?;";
// 	$selectparamType = "s";
// 	$selectparamArray = array($email);
// 	$sqlData = $db->select($selectquery, $selectparamType, $selectparamArray);

// 	$data = array();
// 	if (isset($sqlData)) { // already exist
// 		$data['msg'] = 'email already in db';
// 	} else {
// 		$data['msg'] = 'email not in db';
// 	}
// 	print json_encode($data);
// }
