<?php
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
class distanceCalculator
{
    private $lat1;
    private $lon1;
    private $lat2;
    private $lon2;

    function __construct($lat1, $lon1, $lat2, $lon2)
    {
        $this->lat1 = $lat1;
        $this->lon1 = $lon1;
        $this->lat2 = $lat2;
        $this->lon2 = $lon2;
        $this->distanceMetres();
    }


    function distanceMetres()
    {
        if (($this->lat1 == $this->lat2) && ($this->lon1 == $this->lon2)) {
            return 0;
        } else {
            $theta = $this->lon1 - $this->lon2;
            $dist = sin(deg2rad($this->lat1)) * sin(deg2rad($this->lat2)) +  cos(deg2rad($this->lat1)) * cos(deg2rad($this->lat2)) * cos(deg2rad($theta));
            $dist = acos($dist);
            $dist = rad2deg($dist);
            $miles = $dist * 60 * 1.1515;
            return (($miles * 1.609344) / 1000);
        }
    }
}
//echo distance(32.9697, -96.80322, 29.46786, -98.53506) . " meters<br>";