<?php

require "credentials.php";
$con = mysqli_connect(HOST, USERNAME, PASSWORD, DATABASENAME) or die('cannot connect to database');
if ($_SERVER['REQUEST_METHOD'] == "POST") {
	$data = array();

	$username = $_POST['username'];
	$password = $_POST['password'];
	$level = $_POST['level'];

	$cek = mysqli_query($con, "SELECT * FROM User WHERE username='$username' AND password='$password'");
	$cekData = mysqli_fetch_array($cek);

	if (isset($cekData)) {
		$data['status'] = 1;
		$data['msg'] = "Data Sudah Ada!";
		echo json_encode($data);
	} else {
		$query = mysqli_query($con, "INSERT INTO User VALUE(null, '$username', '$password', '$level')");

		if (isset($query)) {
			$data['status'] = 2;
			$data['msg'] = "Berhasil Di Inputkan";
			echo json_encode($data);
		} else {
			$data['status'] = 3;
			$data['msg'] = "Cannot Add Your Data!";
			echo json_encode($data);
		}
	}
}
