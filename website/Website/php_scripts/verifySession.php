<?php
session_start();
if (isset($_COOKIE["email"]) && isset($_COOKIE["username"]) && isset($_COOKIE["password"])) {
    $email =    $_SESSION["email"]       =   $_COOKIE["email"];
    $username =  $_SESSION["username"] = $_COOKIE["username"];
    $password =  $_SESSION["password"] = $_COOKIE["password"];
}
if (isset($_SESSION["email"]) && isset($_SESSION["username"]) && isset($_SESSION["password"])) {
    $email =    $_SESSION["email"];
    $username =  $_SESSION["username"];
    $password =  $_SESSION["password"];
    session_write_close();
} else {
    // since the username is not set in session, the user is not-logged-in
    // he is trying to access this page unauthorized
    // so let's clear all session variables and redirect him to index
    session_unset();
    session_write_close();
    $url = ((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on') ? "https" : "http") . "://$_SERVER[HTTP_HOST]" . "/Website/login.php";
    header("Location: $url");
}
