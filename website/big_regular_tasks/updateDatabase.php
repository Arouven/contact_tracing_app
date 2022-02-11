<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/firebase/includes/insert.php';

class updateDatabase
{
    private $noDaysFromContact;
    private $db;

    function __construct()
    {
        $this->db = new database();
        $this->noDaysFromContact = $this->getNumber("daysFromContact"); // 14 -life of virus

        $this->deleteOudatedCoordinates();
        $confirmedInfected = $this->getConfirmedInfected(); //t1=>'lat,lon',t2 ...
        $distanceContact = floatval($this->getNumber('contactDistance')); //2


        // here space-time is considered as it is absolute
        // distance and coordinates will represent space
        // start with the lowest time (e.g at t1-which represent 14 days in this case)
        for ($i = 0; $i < count($confirmedInfected); $i++) { //(e.g loop through all infected mobile at t1)
            $datetimeInfected = $confirmedInfected[$i]['dateTimeCoordinates'];
            $mobileNumberInfected = $confirmedInfected[$i]['mobileNumber'];
            $latitudeInfected = floatval($confirmedInfected[$i]['latitude']);
            $longitudeInfected = floatval($confirmedInfected[$i]['longitude']);


            $nextdatetimeInfected = $confirmedInfected[$i + 1]['dateTimeCoordinates'];
            if ($nextdatetimeInfected == null) {
                $nextdatetimeInfected = $datetimeInfected + 1;
            }
            // it is assumed that the mobile stays fixed until the next time from the database
            $nonInfectedAtThatTime = $this->getAllNonInfectedAtThatTime($datetimeInfected, $nextdatetimeInfected); //(e.g get all non infected mobile at t1 to tx - where tx is the value of next time)
            for ($j = 0; $j < count($nonInfectedAtThatTime); $j++) { //(e.g loop through all the non infected mobile at t1)
                $datetimePossibleContact = $nonInfectedAtThatTime[$j]['dateTimeCoordinates'];
                $mobileNumberPossibleContact = $nonInfectedAtThatTime[$j]['mobileNumber'];
                $latitudePossibleContact = floatval($nonInfectedAtThatTime[$j]['latitude']);
                $longitudePossibleContact = floatval($nonInfectedAtThatTime[$j]['longitude']);
                // $distanceMetres = $this->distanceMetres($latitudeInfected, $longitudeInfected, $latitudePossibleContact, $longitudePossibleContact); //(e.g get the distance between the infected mobile and the non infected mobile at t1)
                // print "$distanceMetres --- $distanceContact <br>";
                $distanceMetres = $this->getDistanceBetweenPointsNew($latitudeInfected, $longitudeInfected, $latitudePossibleContact, $longitudePossibleContact); //(e.g get the distance between the infected mobile and the non infected mobile at t1)

                // -20.266454, 57.417569 , -20.266162, 57.415321
                ///-20.266454, 57.417569, -20.266162, 57.415321
                //$floatStr =  substr($distanceMetres, 0, 5);
                //var_dump(round($floatStr, 3));
                //var_dump(round($distanceContact, 3));UPDATE `Mobile` SET `contactWithInfected`=False
                // print($distanceMetres . '<br>' . round($floatStr, 3) . '<br>' . round($distanceContact, 3) . '<br>');
                if (round($distanceMetres, 3) <= round($distanceContact, 3)) {
                    //  if ($distanceMetres <= $distanceContact) { //(e.g if the distance between them is less or equal to 2 meters)
                    //mark contact with infected

                    date_default_timezone_set('Indian/Mauritius');
                    $humandDtetimePossibleContact = date('Y-m-d H:i:s', $datetimePossibleContact);
                    print "$mobileNumberPossibleContact will be marked as contact, infected by $mobileNumberInfected because distance between them is $distanceMetres meters at $humandDtetimePossibleContact ($datetimePossibleContact).<br>";
                    //send message to mobile
                    new NotifyFirebase($mobileNumberPossibleContact);
                    print "message sent to $mobileNumberPossibleContact <br>";
                    $this->markAsContact($mobileNumberPossibleContact);
                } else {
                    #print "$mobileNumberPossibleContact and $mobileNumberInfected are not contactsbecause distance between them is $floatStr meters.<br>";
                }
            }
        }
    }
    function getDistanceBetweenPointsNew($latitude1, $longitude1, $latitude2, $longitude2, $unit = 'meters')
    {
        $theta = $longitude1 - $longitude2;
        $distance = (sin(deg2rad($latitude1)) * sin(deg2rad($latitude2))) + (cos(deg2rad($latitude1)) * cos(deg2rad($latitude2)) * cos(deg2rad($theta)));
        $distance = acos($distance);
        $distance = rad2deg($distance);
        $distance = $distance * 60 * 1.1515;
        switch ($unit) {
            case 'miles':
                break;
            case 'meters':
                $distance = $distance * 1.609344 * 1000;
        }
        return (round($distance, 5));
    }
    function markAsContact($mobileNumberContact)
    {
        $updateStatement = "UPDATE Mobile SET contactWithInfected = TRUE WHERE mobileNumber = $mobileNumberContact;";
        $this->db->execute($updateStatement);
    }
    function getAllNonInfectedAtThatTime($startdatetimeInfected, $enddatetimeInfected)
    {
        //  $selectquery = "SELECT Coordinates.dateTimeCoordinates, Coordinates.latitude, Coordinates.longitude, Mobile.mobileNumber, Mobile.mobileNumber FROM Coordinates INNER JOIN Mobile ON Coordinates.mobileNumber = Mobile.mobileNumber WHERE Mobile.confirmInfected = FALSE AND Coordinates.dateTimeCoordinates = $datetimeInfected AND Mobile.dateTimeLastTest IS NULL;";
        $selectquery = "SELECT Coordinates.dateTimeCoordinates, Coordinates.latitude, Coordinates.longitude, Mobile.mobileNumber FROM Coordinates INNER JOIN Mobile ON Coordinates.mobileNumber = Mobile.mobileNumber WHERE Mobile.confirmInfected = FALSE AND Mobile.contactWithInfected = FALSE AND Coordinates.dateTimeCoordinates >= $startdatetimeInfected AND Coordinates.dateTimeCoordinates < $enddatetimeInfected;";
        $data = $this->db->select($selectquery);
        $array = array();

        if (isset($data) && $data != null) { //if there is something in the result
            $array = $data;
            // print 'all non infected at time: ' . $datetimeInfected;
            //print_r($array);
        }
        return $array;
    }

    /// get all infected mobiles
    /// with their coordinates
    /// in ascending time order
    function getConfirmedInfected()
    {
        $selectquery = 'SELECT Coordinates.dateTimeCoordinates, Coordinates.latitude, Coordinates.longitude, Mobile.mobileNumber FROM Coordinates INNER JOIN Mobile ON Coordinates.mobileNumber = Mobile.mobileNumber WHERE Mobile.confirmInfected = TRUE ORDER BY Coordinates.dateTimeCoordinates ASC';
        $data = $this->db->select($selectquery);
        $infected = array();

        if (isset($data) && $data != null) { //if there is something in the result
            $infected = $data;
            // print 'confirm infected';
            //print_r($infected);
        }
        return $infected;
    }

    /// assuming that the virus live for 14 days.
    /// that means that the person is imune if no syntomes are felt 
    /// therefore the coordinates is considered as outdated and are deleted
    function deleteOudatedCoordinates()
    {
        $deleteFrom = time() - ($this->noDaysFromContact * 24 * 60 * 60); // xx days; 24 hours; 60 mins; 60 secs
        $deleteStatement = "DELETE FROM Coordinates WHERE dateTimeCoordinates < $deleteFrom;";
        $this->db->execute($deleteStatement);
        date_default_timezone_set('Indian/Mauritius');
        $hdate = date('Y-m-d H:i:s', time());
        print "process starts at time:$hdate <br>";
        $hdate = date('Y-m-d H:i:s', $deleteFrom);
        print "outdated coordinates deleted time:$hdate <br>";
    }
    function getNumber($no)
    {
        $selectquery = "SELECT " . $no . " FROM AdminParamters;";

        $data = $this->db->select($selectquery);
        $num = null;

        if (isset($data) && $data != null) { //if there is something in the result
            $num = $data;
            //  echo $no;
            //  print_r($num);
        }
        return $num[0][$no];
    }




    //https://www.geodatasource.com/developers/php
    /*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
    /*::                                                                         :*/
    /*::  This routine calculates the distance between two points (given the     :*/
    /*::  latitude/longitude of those points). It is being used to calculate     :*/
    /*::  the distance between two locations using GeoDataSource(TM) Products    :*/
    /*::                                                                         :*/
    /*::  Definitions:                                                           :*/
    /*::    South latitudes are negative, east longitudes are positive           :*/
    /*::                                                                         :*/
    /*::  Passed to function:                                                    :*/
    /*::    lat1, lon1 = Latitude and Longitude of point 1 (in decimal degrees)  :*/
    /*::    lat2, lon2 = Latitude and Longitude of point 2 (in decimal degrees)  :*/
    /*::    unit = the unit you desire for results                               :*/
    /*::           where: 'M' is statute miles (default)                         :*/
    /*::                  'K' is kilometers                                      :*/
    /*::                  'N' is nautical miles                                  :*/
    /*::  Worldwide cities and other features databases with latitude longitude  :*/
    /*::  are available at https://www.geodatasource.com                          :*/
    /*::                                                                         :*/
    /*::  For enquiries, please contact sales@geodatasource.com                  :*/
    /*::                                                                         :*/
    /*::  Official Web site: https://www.geodatasource.com                        :*/
    /*::                                                                         :*/
    /*::         GeoDataSource.com (C) All Rights Reserved 2018                  :*/
    /*::                                                                         :*/
    /*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
    function distanceMetres(float $lat1, float $lon1, float $lat2, float $lon2)
    {
        if (($lat1 == $lat2) && ($lon1 == $lon2)) {
            return 0;
        } else {
            $theta = $lon1 - $lon2;
            $dist = sin(deg2rad($lat1)) * sin(deg2rad($lat2)) +  cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * cos(deg2rad($theta));
            $dist = acos($dist);
            $dist = rad2deg($dist);
            $miles = $dist * 60 * 1.1515;
            return floatval(($miles * 1.609344) / 1000);
        }
    }
    // function updateOudatedTests()
    // {
    //     $updateFrom = time() - ($this->noDaysFromContact * 24 * 60 * 60); // xx days; 24 hours; 60 mins; 60 secs
    //     //UPDATE 
    //     //     t1
    //     // SET 
    //     //     t1.c1 = t2.c2,
    //     //     t1.c2 = expression,
    //     //     ...   
    //     // FROM 
    //     //     t1
    //     //     [INNER | LEFT] JOIN t2 ON join_predicate
    //     // WHERE 
    //     //     where_predicate;
    //     $updateStatement = "UPDATE Mobile SET Mobile.contactWithInfected = FALSE, Mobile.confirmInfected = FALSE, Mobile.dateTimeLastTest IS NULL FROM Mobile INNER JOIN Coordinates ON Mobile.mobileNumber=Coordinates.mobileNumber WHERE Coordinates.dateTimeCoordinates < " . $updateFrom . ";";
    //     $this->db->execute($updateStatement);
    //     print "outdated test resetted";
    // }
    //echo distanceMetres(32.9697, -96.80322, 29.46786, -98.53506) . " meters<br>";
}
