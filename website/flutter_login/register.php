<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';

$db = new database();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] == "POST") {
	$firstName = "";
	if (isset($_POST['firstName'])) {
		$firstName = mysqli_real_escape_string($conn, $_POST['firstName']);
	}
	$lastName = "";
	if (isset($_POST['lastName'])) {
		$lastName = mysqli_real_escape_string($conn, $_POST['lastName']);
	}
	$address = "";
	if (isset($_POST['address'])) {
		$address = mysqli_real_escape_string($conn, $_POST['address']);
	}
	$email = "";
	if (isset($_POST['email'])) {
		$email = mysqli_real_escape_string($conn, $_POST['email']);
	}
	$dateOfBirth = "";
	if (isset($_POST['dateOfBirth'])) {
		$dateOfBirth = mysqli_real_escape_string($conn, $_POST['dateOfBirth']);
	}

	$firebaseuid = "";
	if (isset($_POST['firebaseuid'])) {
		$firebaseuid = mysqli_real_escape_string($conn, $_POST['firebaseuid']);
	}

	$selectquery = "SELECT UNIQUE * FROM User WHERE firebaseuid = ?;";


	$selectparamType = "s";
	$selectparamArray = array(
		$firebaseuid
	);
	$cekData = $db->select($selectquery, $selectparamType, $selectparamArray);

	//print json_encode($cekData);
	$data = array();
	if (isset($cekData)) { // already exist
		$data['msg'] = 'email already existed';
		print json_encode($data);
	} else { //insert it
		$insertquery = "INSERT INTO User (firstName, lastName, address, email, dateOfBirth, firebaseuid) VALUES (?, ?, ?, ?, ?, ?);";
		$insertparamType = "ssssss";
		$insertparamArray = array(
			$firstName,
			$lastName,
			$address,
			$email,
			$dateOfBirth,
			$firebaseuid
		);
		$insertedId = $db->insert($insertquery, $insertparamType, $insertparamArray);
		$data['msg'] = 'user inserted';
		$data['userId'] = $insertedId;
		print json_encode($data);
	}
}
