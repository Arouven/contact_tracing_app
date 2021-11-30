<?php
//require $_SERVER['DOCUMENT_ROOT'] . '/contact_tracing/website/database.php';

class bigTable
{
    private $db;

    function __construct()
    {
        $this->db = new database();
    }

    function getHeaders($thCss = "")
    {
        $header = array("firstName", "lastName", "username", "nationalIdNumber", "email", "Mobiles");
        foreach ($header as $key => $value) {
            echo ($thCss == "" || $thCss == null) ? "<th>$value</th>" : "<th class='$thCss'>$value</th>";
        }
    }
    function getRecords($trCss = "", $tdCss = "")
    {
        $data = array();
        $data = $this->db->select("SELECT User.userId, User.firstName, User.lastName, User.username, User.nationalIdNumber, User.email, COUNT(Mobile.userId) AS Mobiles FROM User INNER JOIN Mobile ON User.userId = Mobile.userId GROUP BY Mobile.userId;");
        if (isset($data) && $data != null) { //if there is something in the result           
            foreach ($data as $trkey => $trvalue) { //key will return the position in the array
                $userId = $data[$trkey]['userId'];
                $firstName = $data[$trkey]['firstName'];
                $lastName = $data[$trkey]['lastName'];
                $username = $data[$trkey]['username'];
                $nationalIdNumber = $data[$trkey]['nationalIdNumber'];
                $email = $data[$trkey]['email'];
                $Mobiles = $data[$trkey]['Mobiles'];

                //  $button = "<button class='item' data-toggle='modal' name='edituser$userId' title='Edit' data-target='#largeModal' data-userid='$userId'><i class='zmdi zmdi-edit'></i></button>";
                $button = "<button class='item' onclick='mobileDetail($userId)'><i class='zmdi zmdi-edit'></i></button>";

                echo ($trCss == "" || $trCss == null) ? "<tr>" : "<tr class='$trCss'>";
                echo ($tdCss == "" || $tdCss == null) ? "<td>$firstName</td>" : "<td class='$tdCss'>$firstName</td>";
                echo ($tdCss == "" || $tdCss == null) ? "<td>$lastName</td>" : "<td class='$tdCss'>$lastName</td>";
                echo ($tdCss == "" || $tdCss == null) ? "<td>$username</td>" : "<td class='$tdCss'>$username</td>";
                echo ($tdCss == "" || $tdCss == null) ? "<td>$nationalIdNumber</td>" : "<td class='$tdCss'>$nationalIdNumber</td>";
                echo ($tdCss == "" || $tdCss == null) ? "<td>$email</td>" : "<td class='$tdCss'>$firstName</td>";
                echo ($tdCss == "" || $tdCss == null) ? "<td>$Mobiles $button</td>" : "<td class='$tdCss'>$Mobiles $button</td>";
                echo "</tr>";
            }
        }
    }


    function __destruct()
    {
        unset($this->db);
    }
}
