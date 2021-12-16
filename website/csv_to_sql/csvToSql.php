<?php
require $_SERVER['DOCUMENT_ROOT'] . '/database.php';


class csvtosql
{
    function __construct()
    {
        $db = new database();
        $conn = $db->getConnection();

        $files = glob('csvFiles/*.{csv}', GLOB_BRACE);
        foreach ($files as $file) {
            //do your work here
            $inserted = array();
            $f = fopen($file, "r");
            while (($column = fgetcsv($f, 10000, ",")) !== FALSE) {
                $mobileNumber = "";
                if (isset($column[0])) {
                    $mobileNumber = mysqli_real_escape_string($conn, $column[0]);
                }
                $dateTime = "";
                if (isset($column[1])) {
                    $dateTime = mysqli_real_escape_string($conn, $column[1]);
                }
                $latitude = "";
                if (isset($column[2])) {
                    $latitude = mysqli_real_escape_string($conn, $column[2]);
                }
                $longitude = "";
                if (isset($column[3])) {
                    $longitude = mysqli_real_escape_string($conn, $column[3]);
                }
                $accuracy = "";
                if (isset($column[4])) {
                    $accuracy = mysqli_real_escape_string($conn, $column[4]);
                }

                $sqlInsert = "INSERT into Coordinates (mobileNumber,dateTimeCoordinates,latitude,longitude,accuracy)
                        values (?,?,?,?,?)";
                $paramType = "iisss";
                $paramArray = array(
                    $mobileNumber,
                    $dateTime,
                    $latitude,
                    $longitude,
                    $accuracy
                );
                $insertId = $db->insert($sqlInsert, $paramType, $paramArray);

                if (!empty($insertId)) {
                    $type = "success";
                    $message = "CSV Data Imported into the Database";
                    array_push($inserted, true);
                    echo " $type, $message:- $insertId. mobileNumber $mobileNumber, datetime $dateTime, lat $latitude, lon $longitude, acc $accuracy";
                } else {
                    $type = "error";
                    $message = "Problem in Importing CSV Data";
                    array_push($inserted, false);
                }
            }
            if (in_array(false, $inserted)) {
                echo "$file NOT deleted";
            } //do not delete the file
            else {
                unlink($file);
                echo "$file deleted";
            }
        }
    }
}
