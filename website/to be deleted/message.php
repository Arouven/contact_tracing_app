<?php
// require $_SERVER['DOCUMENT_ROOT'] . '/credentials.php';

// class message
// {
//     private $url;
//     private $postfields;

//     function __construct($numberTo, $messageText)
//     {
//         $this->url = "https://freebulksmsonline.com/api/v1/index.php";
//         $this->postfields = array(
//             'token' => TOKEN,
//             'number' => $numberTo,
//             'message' => $messageText,
//         );
//     }

//     function sendMessage()
//     {
//         if (!$curld = curl_init()) {
//             exit;
//         }

//         curl_setopt($curld, CURLOPT_POST, true);
//         curl_setopt($curld, CURLOPT_POSTFIELDS, $this->postfields);
//         curl_setopt($curld, CURLOPT_URL, $this->url);
//         curl_setopt($curld, CURLOPT_RETURNTRANSFER, true);

//         $curl_output = curl_exec($curld);

//         $response = json_decode($curl_output);
//         //print strval($response);
//         if ($response->success == "true") {
//             return true;
//         }
//         return false;
//     }
// }
// $message = new message(
//     "+23057775794",
//     "You may be infected practice self-isolation and perform a test"
// );
// if ($message->sendMessage()) {
//     echo 'message sent';
// } else {
//     echo  'error';
// }
