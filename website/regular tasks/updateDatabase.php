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
        $this->noDaysFromContact = $this->getNoDays("daysFromContact"); //14
        $this->noDaysOfTestValidity = $this->getNoDays("daysOfTestValidity"); //7
        $this->deleteOudatedCoordinates();
        $this->updateOudatedTests();
    }
    function deleteOudatedCoordinates()
    {
        $deleteFrom = time() - ($this->noDaysOfTestValidity * 24 * 60 * 60); // xx days; 24 hours; 60 mins; 60 secs
        $deleteStatement = 'DELETE FROM Coordinates WHERE dateTimeCoordinates < ' . $deleteFrom . ';';
        $this->db->execute($deleteStatement);
        print "deleted";
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
        $updateStatement = "UPDATE Mobile SET Mobile.contactWithInfected= FALSE, Mobile.performCovidTest= FALSE, Mobile.confirmInfected= FALSE, Mobile.dateTimeLastTest = NULL FROM Mobile INNER JOIN Coordinates ON Mobile.mobileId=Coordinates.mobileId WHERE Coordinates.dateTimeCoordinates < " . $updateFrom . ";";
        $this->db->execute($updateStatement);
        print "updated";
    }
    function getNoDays($column)
    {
        $selectquery = "SELECT " . $column . " FROM AdminParamters;";

        $data = $this->db->select($selectquery);
        $noDays = null;

        if (isset($data) && $data != null) { //if there is something in the result
            $noDays = $data;
            print $noDays;
        }
        return (int)$noDays;
    }
}
