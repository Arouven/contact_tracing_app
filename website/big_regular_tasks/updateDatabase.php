<?php
require '../database.php';

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
            $mobileIdInfected = $confirmedInfected[$key1]['mobileId'];
            $latitudeInfected = floatval($confirmedInfected[$key1]['latitude']);
            $longitudeInfected = floatval($confirmedInfected[$key1]['longitude']);
            $nonInfectedAtThatTime = $this->getAllNonInfectedAtThatTime($datetimeInfected);
            foreach ($nonInfectedAtThatTime as $key2 => $value2) {
                $datetimePossibleContact = $nonInfectedAtThatTime[$key2]['dateTimeCoordinates'];
                $mobileIdPossibleContact = $nonInfectedAtThatTime[$key2]['mobileId'];
                $latitudePossibleContact = floatval($nonInfectedAtThatTime[$key2]['latitude']);
                $longitudePossibleContact = floatval($nonInfectedAtThatTime[$key2]['longitude']);
                $distanceMetres = $this->distanceMetres($latitudeInfected, $longitudeInfected, $latitudePossibleContact, $longitudePossibleContact);
                if ($distanceMetres <= $distanceContact) { //mark contact with infected
                    $this->markAsContact($mobileIdPossibleContact);
                }
            }
        }
    }
    function markAsContact($mobileIdContact)
    {
        $updateStatement = 'UPDATE Mobile SET contactWithInfected = TRUE WHERE mobileId = ' . $mobileIdContact . ';';
        $this->db->execute($updateStatement);
        print "updated at $mobileIdContact";
    }
    function getAllNonInfectedAtThatTime($datetimeInfected)
    {
        $selectquery = 'SELECT Coordinates.dateTimeCoordinates, Coordinates.latitude, Coordinates.longitude,Mobile.mobileId FROM Coordinates INNER JOIN Mobile ON Coordinates.mobileId = Mobile.mobileId WHERE Mobile.confirmInfected = FALSE AND Coordinates.dateTimeCoordinates = ' . $datetimeInfected . '  AND Mobile.dateTimeLastTest IS NULL;';
        $data = $this->db->select($selectquery);
        $array = array();

        if (isset($data) && $data != null) { //if there is something in the result
            $array = $data;
            print $array;
        }
        return $array;
    }
    function getConfirmedInfected()
    {
        $selectquery = 'SELECT Coordinates.dateTimeCoordinates, Coordinates.latitude, Coordinates.longitude,Mobile.mobileId FROM Coordinates INNER JOIN Mobile ON Coordinates.mobileId = Mobile.mobileId WHERE Mobile.performCovidTest = TRUE AND Mobile.confirmInfected = TRUE ORDER BY Coordinates.dateTimeCoordinates ASC';
        $data = $this->db->select($selectquery);
        $infected = array();

        if (isset($data) && $data != null) { //if there is something in the result
            $infected = $data;
            print $infected;
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
        $updateStatement = "UPDATE Mobile SET Mobile.contactWithInfected= FALSE, Mobile.confirmInfected= FALSE, Mobile.dateTimeLastTest IS NULL FROM Mobile INNER JOIN Coordinates ON Mobile.mobileId=Coordinates.mobileId WHERE Coordinates.dateTimeCoordinates < " . $updateFrom . ";";
        $this->db->execute($updateStatement);
        print "updated";
    }
    function deleteOudatedCoordinates()
    {
        $deleteFrom = time() - ($this->noDaysOfTestValidity * 24 * 60 * 60); // xx days; 24 hours; 60 mins; 60 secs
        $deleteStatement = 'DELETE FROM Coordinates WHERE dateTimeCoordinates < ' . $deleteFrom . ';';
        $this->db->execute($deleteStatement);
        print "deleted";
    }
    function getNumber($no)
    {
        $selectquery = "SELECT " . $no . " FROM AdminParamters;";

        $data = $this->db->select($selectquery);
        $num = null;

        if (isset($data) && $data != null) { //if there is something in the result
            $num = $data;
            print $num;
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
