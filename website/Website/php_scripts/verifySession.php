<?php
session_start();
if (isset($_COOKIE["email"])) {
    $_SESSION["email"] = $_COOKIE["email"];
}
if (isset($_SESSION["email"])) {
    session_write_close();
} else {
    // since the username is not set in session, the user is not-logged-in
    // he is trying to access this page unauthorized
    // so let's clear all session variables and redirect him to index
    session_unset();
    session_write_close();
    $url = $_SERVER['HTTP_HOST'] . "/Website/login.php";
    header("Location: $url");
}
