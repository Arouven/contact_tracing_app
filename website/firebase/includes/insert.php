<?php
//require $_SERVER['DOCUMENT_ROOT'] . '/contact_tracing/website/credentials.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/credentials.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';

require __DIR__ . '/vendor/autoload.php';

use Kreait\Firebase\Factory;


class NotifyFirebase
{
    private $url;
    private $token;
    private $title;
    private $body;
    private $sound;
    private $badge;
    private $notification;
    private $priority;
    private $arrayToSend;
    private $mobileNumber;
    private $db;
    function __construct($mobileNumber = "+23057775794", $title = "In Contact", $body = "You may be infected practice self-isolation and perform a test", $url = "https://fcm.googleapis.com/fcm/send", $sound = 'default', $badge = '1', $priority = 'high')
    {
        $this->db = new database();
        $this->url = $url;
        $this->token =  $this->getRespectiveFCMtoken($mobileNumber);
        //$this->token = 'f1RjgXu_SV-7L3ODUOxtTb:APA91bFyJJFcrUpiUE-CcghtpEWo2Sagd4sSYcD9A0AAfdUfziRvh-73CQx_aFyMo0vVfoc750kcJV1OKJrKyQLG9F7To8rEn_3OrVD1m145jTqmx-pmnZSu_qdLe0Dcya3m0cefxV-N', 
        $this->title =  $title;
        $this->body = $body;
        $this->mobileNumber = $mobileNumber;
        $this->sound = $sound;
        $this->badge = $badge;
        $this->priority = $priority;
        $this->notification = array('title' => $this->title, 'body' => $this->body, 'sound' => $this->sound, 'badge' => $this->badge);
        $this->arrayToSend = array('to' => $this->token, 'notification' => $this->notification, 'priority' => $this->priority);
        $this->SaveNotificationToFirebase($this->mobileNumber, $this->title, $this->body);
        $this->sendFCM();
    }
    function SaveNotificationToFirebase($mobileNumber = '+23057775794', $title = 'Title', $body = 'Body')
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
        $ref = "notification/$mobileNumber/";
        $postdata = $database->getReference($ref)->push($data);

        if ($postdata) {
            echo 'inserted';
        } else {
            echo 'problem';
        }
    }
    function getRespectiveFCMtoken($mobileNumber)
    {
        $selectquery = "SELECT Mobile.fcmtoken FROM Mobile WHERE Mobile.mobileNumber = ?;";
        $selectparamType = "s";
        $selectparamArray = array($mobileNumber);
        $data = $this->db->select($selectquery, $selectparamType, $selectparamArray);

        if (isset($data) && $data != null) { //if there is something in the result 
            return $data[0]['fcmtoken'];
        } else { //nothing in result
            return '0';
        }
    }
    function sendFCM()
    {

        // Compile headers in one variable
        $headers = array(
            'Authorization:key=' . SERVERKEY,
            'Content-Type:application/json'
        );

        // Add notification content to a variable for easy reference
        // $notifData = [
        //     'title' => "Test Title",
        //     'body' => "Test notification body",
        //  "image": "url-to-image",//Optional
        // 'click_action' => "activities.NotifHandlerActivity" //Action/Activity - Optional
        // ];

        // $dataPayload = [
        //     'to' => 'My Name',
        //     'points' => 80,
        //     'other_data' => 'This is extra payload'
        // ];

        // Create the api body
        //   $apiBody = [
        //  'notification' => $this->notification, //$notifData,
        //   'data' => $dataPayload, //Optional
        //  'time_to_live' => 600, // optional - In Seconds
        //'to' => '/topics/mytargettopic'
        //'registration_ids' = ID ARRAY
        //    'to' => $this->token
        // ];

        // Initialize curl with the prepared headers and body
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $this->url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($this->arrayToSend)); // curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($apiBody));

        // Execute call and save result
        $result = curl_exec($ch);
        // print($result);
        // Close curl after call
        curl_close($ch);
        //{"multicast_id":4467840198539248234,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"NotRegistered"}]}
        print $result['results'];
        return $result;
    }
}
new NotifyFirebase('+23057775794');
