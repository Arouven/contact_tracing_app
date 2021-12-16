<?php
// require $_SERVER['DOCUMENT_ROOT'] . '/database.php';
// require $_SERVER['DOCUMENT_ROOT'] . '/encryptDecrypt.php';
// require $_SERVER['DOCUMENT_ROOT'] . '/PHPMailer/PHPMailerAutoload.php';

// $db = new database();
// $conn = $db->getConnection();

// if ($_SERVER['REQUEST_METHOD'] == "POST") {
//     $email = "";
//     if (isset($_POST['email'])) {
//         $email = mysqli_real_escape_string($conn, $_POST['email']);
//     }
//     $selectquery = "SELECT email FROM User WHERE email = ?;";


//     $selectparamType = "s";
//     $selectparamArray = array($email);
//     $data = $db->select($selectquery, $selectparamType, $selectparamArray);
//     $outputArray = array();

//     if (isset($data) && $data != null) { //if there is something in the result
//         $email = $data[0]['email'];
//         $outputArray['msg'] = "Please follow the steps sent on " . $email . ".";

//         $ed = new encryptDecrypt($email);
//         $encrypted = $this->encrypt();

//         $to_email =  $email;
//         $subject = 'Password Reset';
//         $reseturl = $_SERVER['SERVER_NAME'] . '/Website/reset.php?reset=' . $encrypted;
//         $link = "<a href='" . $reseturl . "'>Click Here!</a>";
//         $message = '
//         <head>
//             <title>Steps to reset your password.</title>
//         </head>
//         <body>
//             <p>This mail is sent using due to your request to change password.</p>
//             <br>
//             <p>Click on the link to reset your password.</p>
//             <br>' . $link . '<br>
//         </body>  
//         ';
//         // $headers  = 'MIME-Version: 1.0' . "\r\n";
//         // $headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
//         // $headers .= 'From: contact-tracing-utm.000webhostapp.com' . "\r\n";
//         mail($email, $to_email, $subject, $message);

//         print json_encode($outputArray);
//     } else {
//         $outputArray['msg'] = "data does not exist";
//         print json_encode($outputArray);
//     }
// }
// function mail($email, $to_email, $subject, $message)
// {
//     try {
//         date_default_timezone_set('Etc/UTC');
//         $mail = new PHPMailer;
//         $mail->isSMTP();


//         //vars to change
//         // $sendername = 'OpenJobs';
//         // $sendermailaddress = 'internetprogramming2019@gmail.com';
//         // $receivermailaddress = $to_email;

//         // Choose to send either a simple text email...
//         $mail->Body = $message; // Set a plain text body.
//         $mail->Subject = $subject; // The subject of the message.
//         $mail->email = "internetprogramming2019@gmail.com"; // Your Gmail address.
//         $mail->Password = "IP0123456789"; // Your Gmail login password or App Specific Password.


//         $mail->Host = 'smtp.gmail.com'; // Which SMTP server to use.
//         $mail->Port = 587; // Which port to use, 587 is the default port for TLS security.
//         $mail->SMTPSecure = 'tls'; // Which security method to use. TLS is most secure.
//         $mail->SMTPAuth = true; // Whether you need to login. This is almost always required.


//         $mail->isHTML(true);
//         $mail->setFrom('contact-tracing-utm.000webhostapp.com', 'Contact Tracing'); // Set the sender of the message.
//         $mail->addAddress($to_email, $email); // Set the recipient of the message.
//         $mail->send();
//         // echo "Your message was sent successfully!";
//     } catch (Exception $e) {
//         // echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
//     }
// }
