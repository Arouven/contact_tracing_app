<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/Website/php_scripts/adminregisterlogin.php';
$admin = new RegisterLogin();
$loginResult = $admin->logoutAdmin();
