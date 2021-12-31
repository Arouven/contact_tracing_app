<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/firebase/includes/insert.php';


class updateDatabase
{
    private $noDaysFromContact;
    private $noDaysOfTestValidity;
    private $db;

    function __construct()
    {
        $this->db = new database();
        $this->noDaysFromContact = $this->getNumber("daysFromContact"); //14
        $this->noDaysOfTestValidity = $this->getNumber("daysOfTestValidity"); //7
        $this->deleteOudatedCoordinates();
        $this->updateOudatedTests();

        $confirmedInfected = $this->getConfirmedInfected(); //t1=>'lat,lon',t2 ....  
        $distanceContact = floatval($this->getNumber('contactDistance')); //2
        foreach ($confirmedInfected as $key1 => $value1) {
            $datetimeInfected = $confirmedInfected[$key1]['dateTimeCoordinates'];
            $mobileNumberInfected = $confirmedInfected[$key1]['mobileNumber'];
            $latitudeInfected = floatval($confirmedInfected[$key1]['latitude']);
            $longitudeInfected = floatval($confirmedInfected[$key1]['longitude']);
            $nonInfectedAtThatTime = $this->getAllNonInfectedAtThatTime($datetimeInfected);
            foreach ($nonInfectedAtThatTime as $key2 => $value2) {
                $datetimePossibleContact = $nonInfectedAtThatTime[$key2]['dateTimeCoordinates'];
                $mobileNumberPossibleContact = $nonInfectedAtThatTime[$key2]['mobileNumber'];
                $latitudePossibleContact = floatval($nonInfectedAtThatTime[$key2]['latitude']);
                $longitudePossibleContact = floatval($nonInfectedAtThatTime[$key2]['longitude']);
                $distanceMetres = $this->distanceMetres($latitudeInfected, $longitudeInfected, $latitudePossibleContact, $longitudePossibleContact);
                if ($distanceMetres <= $distanceContact) { //mark contact with infected
                    print "$mobileNumberPossibleContact will be marked as contact, infected by $mobileNumberInfected.";
                    //send message to mobile
                    new NotifyFirebase($mobileNumberPossibleContact);
                    echo 'message sent to ' . $mobileNumberPossibleContact;
                    $this->markAsContact($mobileNumberPossibleContact);
                }
            }
        }
    }
    function markAsContact($mobileNumberContact)
    {
        $updateStatement = "UPDATE Mobile SET contactWithInfected = TRUE WHERE mobileNumber = $mobileNumberContact;";
        $this->db->execute($updateStatement);
    }
    function getAllNonInfectedAtThatTime($datetimeInfected)
    {
        $selectquery = "SELECT Coordinates.dateTimeCoordinates, Coordinates.latitude, Coordinates.longitude, Mobile.mobileNumber, Mobile.mobileNumber FROM Coordinates INNER JOIN Mobile ON Coordinates.mobileNumber = Mobile.mobileNumber WHERE Mobile.confirmInfected = FALSE AND Coordinates.dateTimeCoordinates = $datetimeInfected AND Mobile.dateTimeLastTest IS NULL;";
        $data = $this->db->select($selectquery);
        $array = array();

        if (isset($data) && $data != null) { //if there is something in the result
            $array = $data;
            print 'all non infected at time: ' . $datetimeInfected;
            print_r($array);
        }
        return $array;
    }
    function getConfirmedInfected()
    {
        $selectquery = 'SELECT Coordinates.dateTimeCoordinates, Coordinates.latitude, Coordinates.longitude, Mobile.mobileNumber FROM Coordinates INNER JOIN Mobile ON Coordinates.mobileNumber = Mobile.mobileNumber WHERE Mobile.performCovidTest = TRUE AND Mobile.confirmInfected = TRUE ORDER BY Coordinates.dateTimeCoordinates ASC';
        $data = $this->db->select($selectquery);
        $infected = array();

        if (isset($data) && $data != null) { //if there is something in the result
            $infected = $data;
            print 'confirm infected';
            print_r($infected);
        }
        return $infected;
    }






    function updateOudatedTests()
    {
        $updateFrom = time() - ($this->noDaysFromContact * 24 * 60 * 60); // xx days; 24 hours; 60 mins; 60 secs
        //UPDATE 
        //     t1
        // SET 
        //     t1.c1 = t2.c2,
        //     t1.c2 = expression,
        //     ...   
        // FROM 
        //     t1
        //     [INNER | LEFT] JOIN t2 ON join_predicate
        // WHERE 
        //     where_predicate;
        $updateStatement = "UPDATE Mobile SET Mobile.contactWithInfected = FALSE, Mobile.confirmInfected = FALSE, Mobile.dateTimeLastTest IS NULL FROM Mobile INNER JOIN Coordinates ON Mobile.mobileNumber=Coordinates.mobileNumber WHERE Coordinates.dateTimeCoordinates < " . $updateFrom . ";";
        $this->db->execute($updateStatement);
        print "outdated test resetted";
    }
    function deleteOudatedCoordinates()
    {
        $deleteFrom = time() - ($this->noDaysOfTestValidity * 24 * 60 * 60); // xx days; 24 hours; 60 mins; 60 secs
        $deleteStatement = 'DELETE FROM Coordinates WHERE dateTimeCoordinates < ' . $deleteFrom . ';';
        $this->db->execute($deleteStatement);
        print "outdated coordinates deleted";
    }
    function getNumber($no)
    {
        $selectquery = "SELECT " . $no . " FROM AdminParamters;";

        $data = $this->db->select($selectquery);
        $num = null;

        if (isset($data) && $data != null) { //if there is something in the result
            $num = $data;
            echo $no;
            print_r($num);
        }
        return $num;
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
    //echo distanceMetres(32.9697, -96.80322, 29.46786, -98.53506) . " meters<br>";
}
