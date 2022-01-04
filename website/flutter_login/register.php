<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';

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


	$selectquery = "SELECT * FROM User WHERE email = ?;";


	$selectparamType = "s";
	$selectparamArray = array($email);
	$cekData = $db->select($selectquery, $selectparamType, $selectparamArray);

	//print json_encode($cekData);
	$data = array();
	if (isset($cekData)) { // already exist
		$data['msg'] = 'email already existed';
		print json_encode($data);
	} else { //insert it
		$insertquery = "INSERT INTO User (firstName, lastName, address, email, dateOfBirth) VALUES (?, ?, ?, ?, ?);";
		$insertparamType = "sssss";
		$insertparamArray = array(
			$firstName,
			$lastName,
			$address,
			$email,
			$dateOfBirth
		);
		$insertedId = $db->insert($insertquery, $insertparamType, $insertparamArray);
		$data['msg'] = 'user inserted';
		print json_encode($data);
	}
}
