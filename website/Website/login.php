<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/Website/php_scripts/adminregisterlogin.php';
if (!empty($_POST["login-btn"])) {
    $admin = new RegisterLogin();
    $loginResult = $admin->loginAdmin();
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <!-- Required meta tags-->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="au theme template">
    <meta name="author" content="Hau Nguyen">
    <meta name="keywords" content="au theme template">

    <!-- Title Page-->
    <title>Login</title>

    <!-- Fontfaces CSS-->
    <link href="css/font-face.css" rel="stylesheet" media="all">
    <link href="vendor/font-awesome-4.7/css/font-awesome.min.css" rel="stylesheet" media="all">
    <link href="vendor/font-awesome-5/css/fontawesome-all.min.css" rel="stylesheet" media="all">
    <link href="vendor/mdi-font/css/material-design-iconic-font.min.css" rel="stylesheet" media="all">

    <!-- Bootstrap CSS-->
    <link href="vendor/bootstrap-4.1/bootstrap.min.css" rel="stylesheet" media="all">

    <!-- Vendor CSS-->
    <link href="vendor/animsition/animsition.min.css" rel="stylesheet" media="all">
    <link href="vendor/bootstrap-progressbar/bootstrap-progressbar-3.3.4.min.css" rel="stylesheet" media="all">
    <link href="vendor/wow/animate.css" rel="stylesheet" media="all">
    <link href="vendor/css-hamburgers/hamburgers.min.css" rel="stylesheet" media="all">
    <link href="vendor/slick/slick.css" rel="stylesheet" media="all">
    <link href="vendor/select2/select2.min.css" rel="stylesheet" media="all">
    <link href="vendor/perfect-scrollbar/perfect-scrollbar.css" rel="stylesheet" media="all">

    <!-- Main CSS-->
    <link href="css/theme.css" rel="stylesheet" media="all">

</head>

<body class="animsition">
    <div class="page-wrapper">
        <div class="page-content--bge5">
            <div class="container">
                <div class="login-wrap">
                    <div class="login-content">
                        <div class="login-logo">
                            <a href="#">
                                <img src="images/icon/logo.png" alt="CoolAdmin">
                            </a>
                        </div>
                        <div class="login-form">
                            <form name="login" action="" method="post" onsubmit="return loginValidation();">
                                <div class="form-group">
                                    <label>Email Address<span class="required error" id="email-info"></span>
                                </div></label>
                                <input class="au-input au-input--full" type="email" name="email" id="email" placeholder="Email" value="<?php if (isset($_COOKIE["email"])) {
                                                                                                                                            echo $_COOKIE["email"];
                                                                                                                                        } ?>" />
                        </div>
                        <div class="form-group">
                            <label>Password<span class="required error" id="login-password-info"></span></label>
                            <input class="au-input au-input--full" type="password" name="login-password" id="login-password" placeholder="Password" value="<?php if (isset($_COOKIE["password"])) {
                                                                                                                                                                echo $_COOKIE["password"];
                                                                                                                                                            } ?>">
                        </div>
                        <div class="login-checkbox">
                            <label>
                                <input type="checkbox" name="remember">Remember Me
                            </label>
                        </div>
                        <button class="au-btn au-btn--block au-btn--green m-b-20" type="submit" name="login-btn" id="login-btn">sign in</button>
                        </form>
                        <div class="error-msg">
                            <?php
                            if (!empty($loginResult)) {
                                echo $loginResult;
                            }
                            ?>
                        </div>
                        <div class="register-link">
                            <p>
                                Don't you have account?
                                <a href="register.php">Sign Up Here</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    </div>

    <!-- Jquery JS-->
    <script src="vendor/jquery-3.2.1.min.js"></script>
    <!-- Bootstrap JS-->
    <script src="vendor/bootstrap-4.1/popper.min.js"></script>
    <script src="vendor/bootstrap-4.1/bootstrap.min.js"></script>
    <!-- Vendor JS       -->
    <script src="vendor/slick/slick.min.js">
    </script>
    <script src="vendor/wow/wow.min.js"></script>
    <script src="vendor/animsition/animsition.min.js"></script>
    <script src="vendor/bootstrap-progressbar/bootstrap-progressbar.min.js">
    </script>
    <script src="vendor/counter-up/jquery.waypoints.min.js"></script>
    <script src="vendor/counter-up/jquery.counterup.min.js">
    </script>
    <script src="vendor/circle-progress/circle-progress.min.js"></script>
    <script src="vendor/perfect-scrollbar/perfect-scrollbar.js"></script>
    <script src="vendor/chartjs/Chart.bundle.min.js"></script>
    <script src="vendor/select2/select2.min.js"></script>

    <!-- Main JS-->
    <script src="js/main.js"></script>
    <script>
        function loginValidation() {
            var valid = true;
            $("#email").removeClass("error-field");
            $("#password").removeClass("error-field");

            var email = $("#email").val();
            var Password = $('#login-password').val();

            $("#email-info").html("").hide();

            if (email.trim() == "") {
                $("#email-info").html("required.").css("color", "#ee0000").show();
                $("#email").addClass("error-field");
                valid = false;
            }
            if (Password.trim() == "") {
                $("#login-password-info").html("required.").css("color", "#ee0000").show();
                $("#login-password").addClass("error-field");
                valid = false;
            }
            if (valid == false) {
                $('.error-field').first().focus();
                valid = false;
            }
            return valid;
        }
    </script>
</body>

</html>
<!-- end document-->