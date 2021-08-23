<?php
require_once '../csv to sql/csvToSql.php';
require_once 'markDBContacted.php';
require_once 'updateTestValidity.php';
require_once 'deleteCoordinatesAfterIncubation.php';

new csvtosql();
new updateTestValidity();
new deleteCoordinatesAfterIncubation();
new markdbcontacted();
