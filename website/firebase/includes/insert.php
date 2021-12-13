<?php
require __DIR__ . '/vendor/autoload.php';

use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;


$factory = (new Factory)
    ->withServiceAccount('contacttracing-2a765-firebase-adminsdk-l6gry-86550a1458.json')
    ->withDatabaseUri('https://contacttracing-2a765-default-rtdb.firebaseio.com/');

$database = $factory->createDatabase();
$messaging = $factory->createMessaging();



$topic = 'a-topic';
$title = 'Title';
$body =    'Body';
//$message = CloudMessage::withTarget('topic', $topic)
//  ->withNotification(Notification::create($title, $body))
//->withData(['key' => 'value'])
//;

// $message = CloudMessage::fromArray([
//     'topic' => $topic,
//     'notification' => [/* Notification data as array */], // optional
//     'data' => [/* data array */], // optional
// ]);




$data = [
    'title' => $title,
    'body' => $body,
    'timestamp' => time(),
    'read' => false,
];


$phone =  '+23057775794';
$ref = "notification/$phone/";
$postdata = $database->getReference($ref)->push($data);

if ($postdata) {
    // $_SESSION['status'] = "Data Inserted Successfully";
    // header("Location: index.php");
    echo 'inserted';
    // $messaging->send($message);
} else {
    // $_SESSION['status'] = "Data Not Inserted. Something Went Wrong.!";
    // header("Location: index.php");
    echo 'problem';
}
