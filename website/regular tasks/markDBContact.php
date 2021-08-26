<?php

require '../database.php';


class markdbcontacted
{
    function __construct()
    {
        $confirmedInfected = $this->getConfirmedInfected(); //t1=>'lat,lon',t2 ....        
        $daysFromContact = (int)$this->getNumber('daysFromContact'); //14
        foreach ($confirmedInfected as $key => $value) {
            $datetimeInfected = $confirmedInfected[$key]['dateTimeCoordinates'];
            $mobileIdInfected = $confirmedInfected[$key]['mobileId'];
            $latitudeInfected = $confirmedInfected[$key]['latitude'];
            $longitudeInfected = $confirmedInfected[$key]['longitude'];
            $nonInfectedAtThatTime = array();
        }
        $daysCoordinates = array(); //t1=>'lat,lon',t2 ....
        $distanceMetres = $this->distanceMetres(1, 2, 3, 4);
        $distanceContact = floatval($this->getNumber('contactDistance'));
        if ($distanceMetres <= $distanceContact) { //mark contact with infected
            ;
        }


        //update contact tracing
        //     $infectedMetres = floatval($data[0]['infected']);
        //if (isset($data) && $data != null) { //if there is something in the result
        //     $outputArray['msg'] = "data exist";
        //     //$outputArray['infected'] = $data[0]['infected'];
        //     $infectedMetres = floatval($data[0]['infected']);

        //     //https://www.php.net/manual/en/function.time.php
        //     $noDays = 1;
        //     $searchFrom = time() - ($noDays * 24 * 60 * 60); // xx days; 24 hours; 60 mins; 60 secs
        //     while ($searchFrom < time()) {
        //         $selectquery = "SELECT * FROM Coordinates;"; //<=2m
        //         $data = $db->select($selectquery);
        //         if (isset($data) && $data != null) { //if there is something in the result
        //             $outputArray['msg'] = "data exist";
        //             //$outputArray['infected'] = $data[0]['infected'];
        //             $infectedMetres = floatval($data[0]['infected']);
        //         }
        //         echo '<br>';
        //         echo  $searchFrom = $searchFrom + 1;
        //     }
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
}
//echo distanceMetres(32.9697, -96.80322, 29.46786, -98.53506) . " meters<br>";
