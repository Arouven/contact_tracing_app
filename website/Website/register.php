<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/Website/php_scripts/adminregisterlogin.php';
if (isset($_POST["signup-btn"])) {
    $admin = new RegisterLogin();
    $registrationResponse = $admin->registerAdmin();
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
    <title>Register</title>

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

    <!-- <link href="css/phppot.css" type="text/css" rel="stylesheet" />
    <link href="css/user-register.css" type="text/css" rel="stylesheet" /> -->
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
                            <form name="sign-up" method="post" onsubmit="return signupValidation();">
                                <!--action="register.php" -->
                                <div class="form-group">
                                    <label>Username<span class="required error" id="username-info"></span></label>
                                    <input class="au-input au-input--full" type="text" name="username" placeholder="Username" id="username">
                                </div>
                                <div class="form-group">
                                    <label>Email Address<span class="required error" id="email-info"></span></label>
                                    <input class="au-input au-input--full" type="email" name="email" placeholder="Email" id="email">
                                </div>
                                <div class="form-group">
                                    <label>Password<span class="required error" id="signup-password-info"></span>
                                    </label>
                                    <input class="au-input au-input--full" type="password" name="signup-password" placeholder="Password" id="signup-password">
                                </div>
                                <div class="login-checkbox">
                                    <label>
                                        <input type="checkbox" name="remember">Remember me
                                    </label>
                                </div>
                                <?php
                                if (!empty($registrationResponse["status"])) {
                                    if ($registrationResponse["status"] == "error") {
                                        echo '<div class="server-response error-msg">';
                                        echo $registrationResponse["message"];
                                        echo '</div>';
                                    } else if ($registrationResponse["status"] == "success") {
                                        echo '<div class="server-response success-msg">';
                                        echo $registrationResponse["message"];
                                        echo '</div>';
                                    }
                                }
                                ?>
                                <button class="au-btn au-btn--block au-btn--green m-b-20" name="signup-btn" id="signup-btn" type="submit">register</button>

                            </form>
                            <div class="register-link">
                                <p>
                                    Already have account?
                                    <a href="login.php">Sign In</a>
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
    <script src="vendor/select2/select2.min.js">
    </script>

    <!-- Main JS-->
    <script src="js/main.js"></script>

    <script>
        function signupValidation() {
            var valid = true;

            $("#username").removeClass("error-field");
            $("#email").removeClass("error-field");
            $("#password").removeClass("error-field");

            var UserName = $("#username").val();
            var email = $("#email").val();
            var Password = $('#signup-password').val();
            var emailRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;

            $("#username-info").html("").hide();
            $("#email-info").html("").hide();

            if (UserName.trim() == "") {
                $("#username-info").html(" - required.").css("color", "#ee0000").show();
                $("#username").addClass("error-field");
                console.log('username invalid');
                valid = false;
            } else if (!((UserName.trim()).match(/^[A-Z]/i))) {
                $("#username-info").html(" - must start with alphabet.").css("color", "#ee0000").show();
                $("#username").addClass("error-field");
                console.log('username does not starts with alphabet');
                valid = false;
            }
            if (email == "") {
                $("#email-info").html(" - required.").css("color", "#ee0000").show();
                $("#email").addClass("error-field");
                console.log('email is empty');
                valid = false;
            } else if (email.trim() == "") {
                $("#email-info").html(" - Invalid email address.").css("color", "#ee0000").show();
                $("#email").addClass("error-field");
                console.log('email contain white space only');
                valid = false;
            } else if (!emailRegex.test(email)) {
                $("#email-info").html(" - Invalid email address.").css("color", "#ee0000")
                    .show();
                $("#email").addClass("error-field");
                console.log('email regular expression invalid');
                valid = false;
            }
            if (Password.trim() == "") {
                $("#signup-password-info").html(" - required.").css("color", "#ee0000").show();
                $("#signup-password").addClass("error-field");
                console.log('password invalid');
                valid = false;
            }
            if (valid == false) {
                $('.error-field').first().focus();
                valid = false;
            }
            console.log(valid);
            return valid;
        }
    </script>
</body>

</html>
<!-- end document-->