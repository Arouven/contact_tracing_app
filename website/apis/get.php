<?php
require '../database.php';

$db = new database();
$query = 'select * from User;';
$result = $db->select($query);
print json_encode($result);
