<?php
require $_SERVER['DOCUMENT_ROOT'] . '/csv_to_sql/csvToSql.php';

require $_SERVER['DOCUMENT_ROOT'] . '/big_regular_tasks/updateDatabase.php';

new csvtosql();
new updateDatabase();
