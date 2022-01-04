<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';

class bigTable
{
    private $db;

    function __construct()
    {
        $this->db = new database();
    }

    function getHeaders($thCss = "")
    {
        $header = array("firstName", "lastName", "email", "Mobiles");
        foreach ($header as $key => $value) {
            echo ($thCss == "" || $thCss == null) ? "<th>$value</th>" : "<th class='$thCss'>$value</th>";
        }
    }
    function getRecords($trCss = "", $tdCss = "")
    {
        $data = array();
        $data = $this->db->select("SELECT User.firstName, User.lastName, User.email, COUNT(Mobile.email) AS Mobiles FROM User INNER JOIN Mobile ON User.email = Mobile.email GROUP BY Mobile.email;");
        if (isset($data) && $data != null) { //if there is something in the result           
            foreach ($data as $trkey => $trvalue) { //key will return the position in the array
                $firstName = $data[$trkey]['firstName'];
                $lastName = $data[$trkey]['lastName'];
                $email = $data[$trkey]['email'];
                $Mobiles = $data[$trkey]['Mobiles'];
                //  $button = "<button class='item' data-toggle='modal' name='edituser$userId' title='Edit' data-target='#largeModal' data-userid='$userId'><i class='zmdi zmdi-edit'></i></button>";
                $button = "<button class='item' onclick='mobileDetail($email)'><i class='zmdi zmdi-edit'></i></button>";

                echo ($trCss == "" || $trCss == null) ? "<tr>" : "<tr class='$trCss'>";
                echo ($tdCss == "" || $tdCss == null) ? "<td>$firstName</td>" : "<td class='$tdCss'>$firstName</td>";
                echo ($tdCss == "" || $tdCss == null) ? "<td>$lastName</td>" : "<td class='$tdCss'>$lastName</td>";
                echo ($tdCss == "" || $tdCss == null) ? "<td>$email</td>" : "<td class='$tdCss'>$firstName</td>";
                echo ($tdCss == "" || $tdCss == null) ? "<td><div style='width: 100%;overflow: hidden;'><div style='width: 80%;float:left;'>$Mobiles </div><div style='width: 10%; text-align:right; float:right; overflow: hidden;'>$button </div></div></td>" : "<td class='$tdCss'> <div style='width: 100%;overflow: hidden;'><div style='width: 80%;float:left;'>$Mobiles </div><div style='width: 10%; text-align:right; float:right; overflow: hidden;'>$button </div></div></td>";
                echo "</tr>";
            }
        }
    }


    function __destruct()
    {
        unset($this->db);
    }
}
