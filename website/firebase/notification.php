<?php
require $_SERVER['DOCUMENT_ROOT'] . '/credentials.php';
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';
require __DIR__ . 'includes/insert.php';


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
    private $db;
    function __construct($mobileId = "1", $url = "https://fcm.googleapis.com/fcm/send", $token = 'f1RjgXu_SV-7L3ODUOxtTb:APA91bFyJJFcrUpiUE-CcghtpEWo2Sagd4sSYcD9A0AAfdUfziRvh-73CQx_aFyMo0vVfoc750kcJV1OKJrKyQLG9F7To8rEn_3OrVD1m145jTqmx-pmnZSu_qdLe0Dcya3m0cefxV-N', $title = "Title3", $body = "Body", $sound = 'default', $badge = '1', $priority = 'high')
    {
        $this->db = new database();
        $this->url = $url;
        $this->token =  $this->getRespectiveFCMtoken($mobileId);
        $this->title =  $title;
        $this->body = $body;
        $this->sound = $sound;
        $this->badge = $badge;
        $this->priority = $priority;
        $this->notification = array('title' => $this->title, 'body' => $this->body, 'sound' => $this->sound, 'badge' => $this->badge);
        $this->arrayToSend = array('to' => $this->token, 'notification' => $this->notification, 'priority' => $this->priority);
        new SaveNotificationToFirebase($this->token, $this->title, $this->body);
        $this->sendFCM();
    }
    function getRespectiveFCMtoken($mobileId)
    {
        $selectquery = "SELECT Mobile.fcmtoken FROM Mobile WHERE Mobile.mobileId = ?;";
        $selectparamType = "i";
        $selectparamArray = array($mobileId);
        $data = $this->db->select($selectquery, $selectparamType, $selectparamArray);

        if (isset($data) && $data != null) { //if there is something in the result 
            return $data[0]['fcmtoken'];
        } else { //nothing in result
            return 'd61hZ9MvRyupiaG4r9BfbO:APA91bEUY1QgnIJjCknSOx82aks9tiye9XIIeOQTkzZzVp4Koau3Y-DiC5HWDaQZRrXQQ9C_3CBW_Ng1c5v7aBoYJ1tmLID3UlGZtS49z-GcFm9QDnA0Jz9kr2BS6vR5Sd4ZZD7cIi-0';
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
        // curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($apiBody));
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($this->arrayToSend));

        // Execute call and save result
        $result = curl_exec($ch);
        // print($result);
        // Close curl after call
        curl_close($ch);

        return $result;
    }
}
new NotifyFirebase(9);
