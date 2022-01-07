<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';


class RegisterLogin
{

    private $db;

    function __construct()
    {
        $this->db = new database();
    }


    /**
     * to check if the email already exists
     *
     * @param string $email
     * @return boolean
     */
    public function isEmailExists($email)
    {
        $query = 'SELECT * FROM tbl_member WHERE email = ?';
        $paramType = 's';
        $paramValue = array(
            $email
        );
        $resultArray = $this->db->select($query, $paramType, $paramValue);
        $count = 0;
        if (is_array($resultArray)) {
            $count = count($resultArray);
        }
        if ($count > 0) {
            $result = true;
        } else {
            $result = false;
        }
        return $result;
    }

    /**
     * to signup / register a user
     *
     * @return string[] registration status message
     */
    public function registerAdmin()
    {
        $isEmailExists = $this->isEmailExists($_POST["email"]);
        if ($isEmailExists) {
            $response = array(
                "status" => "error",
                "message" => "Email already exists."
            );
        } else {
            if (!empty($_POST["signup-password"])) {

                // PHP's password_hash is the best choice to use to store passwords
                // do not attempt to do your own encryption, it is not safe
                $hashedPassword = password_hash($_POST["signup-password"], PASSWORD_DEFAULT);
            }
            $query = 'INSERT INTO tbl_member (username, password, email) VALUES (?, ?, ?)';
            $paramType = 'sss';
            $paramValue = array(
                $_POST["username"],
                $hashedPassword,
                $_POST["email"]
            );
            $memberId = $this->db->insert($query, $paramType, $paramValue);
            if (!empty($memberId)) {
                $response = array(
                    "status" => "success",
                    "message" => "You have registered successfully."
                );
            }
        }
        return $response;
    }

    public function getAdmin($email)
    {
        $query = 'SELECT * FROM tbl_member WHERE email = ?';
        $paramType = 's';
        $paramValue = array(
            $email
        );
        $memberRecord = $this->db->select($query, $paramType, $paramValue);
        return $memberRecord;
    }

    /**
     * to login a user
     *
     * @return string
     */
    public function loginAdmin()
    {
        $memberRecord = $this->getAdmin($_POST["email"]);
        $loginPassword = 0;
        if (!empty($memberRecord)) {
            if (!empty($_POST["login-password"])) {
                $password = $_POST["login-password"];
            }
            $hashedPassword = $memberRecord[0]["password"];
            $loginPassword = 0;
            if (password_verify($password, $hashedPassword)) {
                $loginPassword = 1;
            }
        } else {
            $loginPassword = 0;
        }
        if ($loginPassword == 1) {
            // login sucess so store the member's username in
            // the session
            session_start();
            $_SESSION["email"] = $memberRecord[0]["email"];
            session_write_close();
            if ((!empty($_POST["remember"])) && (isset($_POST['check']))) {
                $keepTime = time() + (60 * 60 * 24 * 365);
                setcookie("email", $_POST["email"], $keepTime);
                setcookie("password", $_POST["login-password"], $keepTime);
            }
            header("Location: ./index.php");
        } else if ($loginPassword == 0) {
            $loginStatus = "Invalid email or password.";
            return $loginStatus;
        }
    }
    public function logoutAdmin()
    {
        session_start();
        session_unset();
        session_write_close();
        // unset cookies
        if (isset($_SERVER['HTTP_COOKIE'])) {
            $cookies = explode(';', $_SERVER['HTTP_COOKIE']);
            foreach ($cookies as $cookie) {
                $parts = explode('=', $cookie);
                $name = trim($parts[0]);
                setcookie($name, '', time() - 1000);
                setcookie($name, '', time() - 1000, '/');
            }
        }
        // if (isset($_COOKIE['email'])) {
        //     unset($_COOKIE['email']);
        //     setcookie('email', null, -1);
        // }
        // if (isset($_COOKIE['password'])) {
        //     unset($_COOKIE['password']);
        //     setcookie('password', null, -1);
        // }
        header("Location: ./index.php");
    }
}
