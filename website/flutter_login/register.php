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
	// $telephone = "";
	// if (isset($_POST['telephone'])) {
	// 	$telephone = mysqli_real_escape_string($conn, $_POST['telephone']);
	// }
	$email = "";
	if (isset($_POST['email'])) {
		$email = mysqli_real_escape_string($conn, $_POST['email']);
	}
	$dateOfBirth = "";
	if (isset($_POST['dateOfBirth'])) {
		$dateOfBirth = mysqli_real_escape_string($conn, $_POST['dateOfBirth']);
	}
	$nationalIdNumber = "";
	if (isset($_POST['nationalIdNumber'])) {
		$nationalIdNumber = mysqli_real_escape_string($conn, $_POST['nationalIdNumber']);
	}
	$username = "";
	if (isset($_POST['username'])) {
		$username = mysqli_real_escape_string($conn, $_POST['username']);
	}
	$password = "";
	if (isset($_POST['password'])) {
		$password = mysqli_real_escape_string($conn, $_POST['password']);
	}
	$selectquery = "SELECT username FROM User WHERE username = ? AND password = ?;";


	$selectparamType = "ss";
	$selectparamArray = array(
		$username,
		$password
	);
	$cekData = $db->select($selectquery, $selectparamType, $selectparamArray);

	//print json_encode($cekData);
	$data = array();
	if (isset($cekData)) { // already exist
		$data['msg'] = 'username already existed';
		print json_encode($data);
	} else { //insert it
		$insertquery = "INSERT INTO User (firstName, lastName, address, email, dateOfBirth, nationalIdNumber, username, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?);";
		$insertparamType = "ssssssss";
		$insertparamArray = array(
			$firstName,
			$lastName,
			$address,
			$email,
			$dateOfBirth,
			$nationalIdNumber,
			$username,
			$password
		);
		$insertedId = $db->insert($insertquery, $insertparamType, $insertparamArray);
		$data['msg'] = 'user inserted';
		$data['userId'] = $insertedId;
		print json_encode($data);
	}
}
