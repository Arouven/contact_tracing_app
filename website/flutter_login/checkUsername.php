<?php
require $_SERVER['DOCUMENT_ROOT'] . '/contact_tracing/website/database.php';

$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
	$username = "";
	if (isset($_POST['username'])) {
		$username = mysqli_real_escape_string($conn, $_POST['username']);
	}
	$selectquery = "SELECT username FROM User WHERE username = ?;";
	$selectparamType = "s";
	$selectparamArray = array($username);
	$sqlData = $db->select($selectquery, $selectparamType, $selectparamArray);

	$data = array();
	if (isset($sqlData)) { // already exist
		$data['msg'] = 'username already in db';
	} else {
		$data['msg'] = 'username not in db';
	}
	print json_encode($data);
}
