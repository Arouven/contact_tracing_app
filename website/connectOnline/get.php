<?php
require('credentials.php');
$conn = new mysqli(HOST, USERNAME, PASSWORD, DATABASENAME);
if (mysqli_connect_errno()) {
    trigger_error("Problem with connecting to database.");
}

$conn->set_charset("utf8");

$query = 'select * from User;';
$rows = array();
$result = $conn->query($query);
while ($row = $result->fetch_assoc()) {
    //$rows[] = $row;
    $userId = $row["userId"];
    $firstName = $row["firstName"];
    $lastName = $row["lastName"];
    $country = $row["country"];
    $address = $row["address"];
    $telephone = $row["telephone"];
    $email = $row["email"];
    $dateOfBirth = $row["dateOfBirth"];
    $nationalIdNumber = $row["nationalIdNumber"];
    $rows[] = array(
        "userId" => $userId,
        "firstName" => $firstName,
        "lastName" => $lastName,
        "country" => $country,
        "address" => $address,
        "telephone" => $telephone,
        "email" => $email,
        "dateOfBirth" => $dateOfBirth,
        "nationalIdNumber" => $nationalIdNumber
    );
    //echo json_encode($row);
}
print json_encode($rows);
