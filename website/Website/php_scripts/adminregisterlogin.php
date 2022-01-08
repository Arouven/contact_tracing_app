<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';


class RegisterLogin
{

    private $db;
    private $urlLogin;
    private $urlHome;

    function __construct()
    {
        $this->db = new database();
        $this->urlLogin = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "://$_SERVER[HTTP_HOST]" . "/Website/login.php";
        $this->urlHome = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "://$_SERVER[HTTP_HOST]" . "/Website/index.php";
    }


    /**
     * to check if the email already exists
     *
     * @param string $email
     * @return boolean
     */
    public function isEmailExists($email)
    {
        $query = 'SELECT * FROM Admin WHERE email = ?';
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
            return  array(
                "status" => "error",
                "message" => "Email already exists."
            );
        } else {
            if (!empty($_POST["signup-password"])) {

                // PHP's password_hash is the best choice to use to store passwords
                // do not attempt to do your own encryption, it is not safe
                $hashedPassword = password_hash($_POST["signup-password"], PASSWORD_DEFAULT);
            }
            $query = 'INSERT INTO Admin (username, password, email) VALUES (?, ?, ?)';
            $paramType = 'sss';
            $paramValue = array(
                $_POST["username"],
                $hashedPassword,
                $_POST["email"]
            );
            $this->db->insert($query, $paramType, $paramValue);
            $this->saveAndRedirect($_POST["email"], $_POST["username"], $_POST["signup-password"]);
            return array(
                "status" => "success",
                "message" => "You have registered successfully."
            );
        }
        //print_r($response);

    }

    public function getAdmin($email)
    {
        $query = 'SELECT * FROM Admin WHERE email = ?';
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
        $username = "";
        if (!empty($memberRecord)) {
            if (!empty($_POST["login-password"])) {
                $password = $_POST["login-password"];
            }
            $hashedPassword = $memberRecord[0]["password"];
            $loginPassword = 0;
            if (password_verify($password, $hashedPassword)) {
                $username = $memberRecord[0]["username"];
                $loginPassword = 1;
            }
        } else {
            $loginPassword = 0;
        }
        if ($loginPassword == 1) {
            // login sucess so store the member's username in
            // the session
            $this->saveAndRedirect($_POST["email"], $username, $_POST["login-password"]);
        } else if ($loginPassword == 0) {
            $loginStatus = "Invalid email or password.";
            return $loginStatus;
        }
    }
    private function saveAndRedirect($email, $username, $password)
    {
        $this->saveSession($email, $username, $password);
        $this->saveCookies($email, $username, $password);
        //echo "<script>alert('$url');</script>";
        header("Location: $this->urlHome");
    }
    private function saveSession($email, $username, $password)
    {
        session_start();
        $_SESSION["email"] = $email;
        $_SESSION["username"] = $username;
        $_SESSION["password"] = $password;
        session_write_close();
    }
    private function saveCookies($email, $username, $password)
    {
        if ((!empty($_POST["remember"])) && (isset($_POST['remember']))) {
            $keepTime = time() + (60 * 60 * 24 * 365);
            setcookie("email", $email, $keepTime);
            setcookie("username", $username, $keepTime);
            setcookie("password", $password, $keepTime);
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
        header("Location: $this->urlLogin");
    }
}
