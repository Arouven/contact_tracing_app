<?php
require_once '../csv to sql/csvToSql.php';
require_once 'markDBContacted.php';
require_once 'updateDatabase.php';

new csvtosql();
new updateDatabase();
new markdbcontacted();
