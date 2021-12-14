<?php
require __DIR__ . '/vendor/autoload.php';

use Kreait\Firebase\Factory;

class SaveNotificationToFirebase
{
    function __construct($fcmtoken = '+23057775794', $title = 'Title', $body = 'Body')
    {

        $factory = (new Factory)
            ->withServiceAccount('contacttracing-2a765-firebase-adminsdk-l6gry-86550a1458.json')
            ->withDatabaseUri('https://contacttracing-2a765-default-rtdb.firebaseio.com/');

        $database = $factory->createDatabase();
        $data = [
            'title' => $title,
            'body' => $body,
            'timestamp' => time(),
            'read' => false,
        ];;
        $ref = "notification/$fcmtoken/";
        $postdata = $database->getReference($ref)->push($data);

        if ($postdata) {
            echo 'inserted';
        } else {
            echo 'problem';
        }
    }
}
