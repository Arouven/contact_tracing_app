<?php
require $_SERVER['DOCUMENT_ROOT'] . '/contact_tracing/website/csv_to_sql/csvToSql.php';

require $_SERVER['DOCUMENT_ROOT'] . '/contact_tracing/website/big_regular_tasks/updateDatabase.php';

new csvtosql();
new updateDatabase();
