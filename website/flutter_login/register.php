<?php

require '../database.php';
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
	$country = "";
	if (isset($_POST['country'])) {
		$country = mysqli_real_escape_string($conn, $_POST['country']);
	}
	$address = "";
	if (isset($_POST['address'])) {
		$address = mysqli_real_escape_string($conn, $_POST['address']);
	}
	$telephone = "";
	if (isset($_POST['telephone'])) {
		$telephone = mysqli_real_escape_string($conn, $_POST['telephone']);
	}
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
	$password = "";
	if (isset($_POST['password'])) {
		$password = mysqli_real_escape_string($conn, $_POST['password']);
	}

	$selectquery = "SELECT * FROM User WHERE nationalIdNumber = ? AND password = ?;";
	$selectparamType = "ss";
	$selectparamArray = array(
		$nationalIdNumber,
		$password
	);


	$cekData = $db->select(query: $selectquery, paramType: $insertparamType, paramArray: $selectparamArray);
	if (isset($cekData)) { // already exist
		echo json_encode('nic already existed in database');
	} else { //insert it
		$insertquery = "INSERT INTO User (firstName, lastName, country, address, telephone,email, dateOfBirth, nationalIdNumber, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);";
		$insertparamType = "sssssssss";
		$insertparamArray = array(
			$firstName,
			$lastName,
			$country,
			$address,
			$telephone,
			$email,
			$dateOfBirth,
			$nationalIdNumber,
			$password
		);
		$insertedId = $db->insert(query: $insertquery, paramType: $insertparamType, paramArray: $insertparamArray);
		echo json_encode($insertedId);
	}
}