<?php
require $_SERVER['DOCUMENT_ROOT'] . '/contact_tracing/website/database.php';

class markers
{
    private $markers;
    private $db;

    function __construct()
    {
        $this->db = new database();
    }

    //all virus testing centres
    function getTestingCenters()
    {
        $data = $this->db->select("SELECT name, address, latitude, longitude FROM TestingCentres;");
        if (isset($data) && $data != null) { //if there is something in the result
            foreach ($data as $key => $value) { //key will return the position in the array
                // print_r($data[$key]);
                $name = $data[$key]['name'];
                $address = $data[$key]['address'];
                $longitude = $data[$key]['longitude'];
                $latitude = $data[$key]['latitude'];
                $this->markers = $this->markers . "[$longitude,$latitude],"; //building js var
            }
        }
        $this->getjsMarkers(); //output the js var that has been building
    }

    //echo the javascript markers variables
    function getjsMarkers()
    {
        echo "<script>var markers=[$this->markers];</script>";
    }
}
