<?php
//require $_SERVER['DOCUMENT_ROOT'] . '/contact_tracing/website/database.php';

// class getmobiles
// {
// }

require $_SERVER['DOCUMENT_ROOT'] . '/contact_tracing/website/database.php';

// if (!empty($_GET['submit'])) {
//if ($_SERVER("REQUEST_METHOD") == "POST") {
$db = new database();
$conn = $db->getConnection();

$userid = "";
if (isset($_GET['userid'])) {
    $userid = mysqli_real_escape_string($conn, $_GET['userid']);
}

$selectquery = "SELECT * FROM Mobile WHERE userId=?;";
$selectparamType = "i";
$selectparamArray = array($userid);
$data = $db->select($selectquery, $selectparamType, $selectparamArray);


// [mobileId] => 4
// [userId] => 2
// [mobileName] => nokia de james
// [mobileDescription] => nokia de james
// [mobileNumber] => +23012345678
// [contactWithInfected] => 0
// [confirmInfected] => 0
// [dateTimeLastTest] => 

if (isset($data) && $data != null) {
    echo '<tr>
        <th>Mobile Name</th>
        <th>Description</th>
        <th>Mobile Number</th>
        <th>Contact With Infected</th>
        <th>Confirm Infected</th>
        <th>Action</th>
    </tr>';
    foreach ($data as $trkey => $trvalue) {
        $userId = $data[$trkey]['userId'];
        $mobileId = $data[$trkey]['mobileId'];
        $mobileName = $data[$trkey]['mobileName'];
        $mobileDescription = $data[$trkey]['mobileDescription'];
        $mobileNumber = $data[$trkey]['mobileNumber'];
        $contactWithInfected = $data[$trkey]['contactWithInfected'];
        $confirmInfected = $data[$trkey]['confirmInfected'];
        $dateTimeLastTest = $data[$trkey]['dateTimeLastTest'];

        $button = "<button class='item' data-toggle='modal' name='edituser$userId' title='Edit' data-target='#largeModal' data-userid='$userId'><i class='zmdi zmdi-edit'></i></button>";

        echo "<tr class='$trCss'>";
        echo "<td class='$tdCss'>$firstName</td>";
        echo  "<td class='$tdCss'>$lastName</td>";
        echo  "<td class='$tdCss'>$username</td>";
        echo  "<td class='$tdCss'>$nationalIdNumber</td>";
        echo  "<td class='$tdCss'>$firstName</td>";
        echo  "<td class='$tdCss'>$Mobiles $button</td>";
        echo "</tr>";
    }
} else {

    echo "No Data Found";
}


unset($db);
unset($conn);
