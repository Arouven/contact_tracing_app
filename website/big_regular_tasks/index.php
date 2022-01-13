<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/csv_to_sql/csvToSql.php';

require_once $_SERVER['DOCUMENT_ROOT'] . '/big_regular_tasks/updateDatabase.php';

new csvtosql();
new updateDatabase();
