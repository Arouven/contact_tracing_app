<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/Website/php_scripts/bigTable.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/Website/php_scripts/verifySession.php';
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <!-- Required meta tags-->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="au theme template">
    <meta name="author" content="Hau Nguyen">
    <meta name="keywords" content="au theme template">

    <!-- Title Page-->
    <title>Tables</title>

    <!-- Fontfaces CSS-->
    <link href="css/font-face.css" rel="stylesheet" media="all">
    <link href="vendor/font-awesome-4.7/css/font-awesome.min.css" rel="stylesheet" media="all">
    <link href="vendor/font-awesome-5/css/fontawesome-all.min.css" rel="stylesheet" media="all">
    <link href="vendor/mdi-font/css/material-design-iconic-font.min.css" rel="stylesheet" media="all">

    <!-- Bootstrap CSS-->
    <link href="vendor/bootstrap-4.1/bootstrap.min.css" rel="stylesheet" media="all">

    <!-- Vendor CSS-->
    <link href="vendor/animsition/animsition.min.css" rel="stylesheet" media="all">
    <link href="vendor/bootstrap-progressbar/bootstrap-progressbar-3.3.4.min.css" rel="stylesheet" media="all">
    <link href="vendor/wow/animate.css" rel="stylesheet" media="all">
    <link href="vendor/css-hamburgers/hamburgers.min.css" rel="stylesheet" media="all">
    <link href="vendor/slick/slick.css" rel="stylesheet" media="all">
    <link href="vendor/select2/select2.min.css" rel="stylesheet" media="all">
    <link href="vendor/perfect-scrollbar/perfect-scrollbar.css" rel="stylesheet" media="all">
    <link href="vendor/DataTables/datatables.min.css" rel="stylesheet" media="all">

    <!-- Main CSS-->
    <link href="css/theme.css" rel="stylesheet" media="all">

</head>

<body class="animsition">
    <div class="page-wrapper">
        <!-- HEADER MOBILE-->
        <header class="header-mobile d-block d-lg-none">
            <div class="header-mobile__bar">
                <div class="container-fluid">
                    <div class="header-mobile-inner">
                        <a class="logo" href="index.php">
                            <img src="images/icon/logo.png" alt="CoolAdmin" />
                        </a>
                        <button class="hamburger hamburger--slider" type="button">
                            <span class="hamburger-box">
                                <span class="hamburger-inner"></span>
                            </span>
                        </button>
                    </div>
                </div>
            </div>
            <nav class="navbar-mobile">
                <div class="container-fluid">
                    <ul class="navbar-mobile__list list-unstyled">
                        <li>
                            <a href="index.php">
                                <i class="fas fa-tachometer-alt"></i>Dashboard</a>
                        </li>
                        <li>
                            <a href="map.php">
                                <i class="fas fa-map-marker-alt"></i>Testing Centers</a>
                        </li>
                        <li>
                            <a href="table.php">
                                <i class="fas fa-table"></i>User Table</a>
                        </li>
                        <li>
                            <a href="configure.php">
                                <i class="far fa-check-square"></i>Settings</a>
                        </li>
                    </ul>
                </div>
            </nav>
        </header>
        <!-- END HEADER MOBILE-->

        <!-- MENU SIDEBAR-->
        <aside class="menu-sidebar d-none d-lg-block">
            <div class="logo">
                <a href="index.php">
                    <img src="images/icon/logo.png" alt="Cool Admin" />
                </a>
            </div>
            <div class="menu-sidebar__content js-scrollbar1">
                <nav class="navbar-sidebar">
                    <ul class="list-unstyled navbar__list">
                        <li class="has-sub">
                            <a class="js-arrow" href="index.php">
                                <i class="fas fa-tachometer-alt"></i>Dashboard</a>
                        </li>
                        <li>
                            <a href="map.php">
                                <i class="fas fa-map-marker-alt"></i>Testing Centers</a>
                        </li>
                        <li class="active">
                            <a href="table.php">
                                <i class="fas fa-table"></i>User Table</a>
                        </li>
                        <li>
                            <a href="configure.php">
                                <i class="far fa-check-square"></i>Settings</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </aside>
        <!-- END MENU SIDEBAR-->

        <!-- PAGE CONTAINER-->
        <div class="page-container">
            <!-- HEADER DESKTOP-->
            <header class="header-desktop">
                <div class="section__content section__content--p30">
                    <div class="container-fluid">
                        <div class="header-wrap">
                            <form class="form-header">
                            </form>
                            <div class="header-button">
                                <div class="account-wrap">
                                    <div class="account-item clearfix js-item-menu">
                                        <div class="image">
                                            <img src="images/icon/icons8-circled-<?php echo substr(strtolower($username), 0, 1); ?>-50.png" alt="<?php echo $username; ?>" />
                                        </div>
                                        <div class="content">
                                            <a class="js-acc-btn" href="#"><?php echo $username; ?></a>
                                        </div>
                                        <div class="account-dropdown js-dropdown">
                                            <div class="info clearfix">
                                                <div class="image">
                                                    <a href="#">
                                                        <img src="images/icon/icons8-circled-<?php echo substr(strtolower($username), 0, 1); ?>-50.png" alt="<?php echo $username; ?>" />
                                                    </a>
                                                </div>
                                                <div class="content">
                                                    <h5 class="name">
                                                        <a href="#"><?php echo $username; ?></a>
                                                    </h5>
                                                    <span class="email"><?php echo $email; ?></span>
                                                </div>
                                            </div>
                                            <div class="account-dropdown__footer">
                                                <a href="logout.php">
                                                    <i class="zmdi zmdi-power"></i>Logout</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <!-- END HEADER DESKTOP-->

            <!-- MAIN CONTENT-->
            <div class="main-content">
                <div class="section__content section__content--p30">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-12">
                                <!-- DATA TABLE -->
                                <h3 class="title-5 m-b-35">user table</h3>
                                <div class="table-data__tool">
                                    <!-- <div class="table-data__tool-left">
                                        <div class="rs-select2--light rs-select2--md">
                                            <select class="js-select2" name="property">
                                                <option selected="selected">All Properties</option>
                                                <option value="">Option 1</option>
                                                <option value="">Option 2</option>
                                            </select>
                                            <div class="dropDownSelect2"></div>
                                        </div>
                                        <div class="rs-select2--light rs-select2--sm">
                                            <select class="js-select2" name="time">
                                                <option selected="selected">Today</option>
                                                <option value="">3 Days</option>
                                                <option value="">1 Week</option>
                                            </select>
                                            <div class="dropDownSelect2"></div>
                                        </div>
                                        <button class="au-btn-filter">
                                            <i class="zmdi zmdi-filter-list"></i>filters</button>
                                    </div> -->
                                    <!-- <div class="table-data__tool-right">
                                        <button class="au-btn au-btn-icon au-btn--green au-btn--small">
                                            <i class="zmdi zmdi-plus"></i>add item</button>
                                        <div class="rs-select2--dark rs-select2--sm rs-select2--dark2">
                                            <select class="js-select2" name="type">
                                                <option selected="selected">Export</option>
                                                <option value="">Option 1</option>
                                                <option value="">Option 2</option>
                                            </select>
                                            <div class="dropDownSelect2"></div>
                                        </div>
                                    </div> -->
                                </div>
                                <div class="table-responsive table-responsive-data2">
                                    <table class="table table-data2" id="myTable">
                                        <thead>
                                            <tr>
                                                <?php
                                                $table = new bigTable();
                                                $table->getHeaders();
                                                ?>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php
                                            $table->getRecords($trCss = "tr-shadow");
                                            ?>

                                            <!-- <tr class="spacer"></tr> -->

                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="copyright">
                                    <p>Copyright © 2018 Colorlib. All rights reserved. Template by <a href="https://colorlib.com">Colorlib</a>.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <!-- modal large -->
    <div class="modal fade" id="largeModal" tabindex="-1" role="dialog" aria-labelledby="largeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content" style="width: 110%;">
                <div class="modal-header">
                    <h5 class="modal-title" id="largeModalLabel">Mobiles Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="table-responsive table-responsive-data2">
                        <table class="table table-data2">
                            <thead id="tableHead">
                            </thead>
                            <tbody id=tableBody>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Confirm</button>
                </div> -->
            </div>
        </div>
    </div>
    <!-- end modal large -->



    <!-- Jquery JS-->
    <script src="vendor/jquery-3.2.1.min.js"></script>
    <!-- Bootstrap JS-->
    <script src="vendor/bootstrap-4.1/popper.min.js"></script>
    <script src="vendor/bootstrap-4.1/bootstrap.min.js"></script>
    <!-- Vendor JS       -->
    <script src="vendor/slick/slick.min.js">
    </script>
    <script src="vendor/wow/wow.min.js"></script>
    <script src="vendor/animsition/animsition.min.js"></script>
    <script src="vendor/bootstrap-progressbar/bootstrap-progressbar.min.js">
    </script>
    <script src="vendor/counter-up/jquery.waypoints.min.js"></script>
    <script src="vendor/counter-up/jquery.counterup.min.js">
    </script>
    <script src="vendor/circle-progress/circle-progress.min.js"></script>
    <script src="vendor/perfect-scrollbar/perfect-scrollbar.js"></script>
    <script src="vendor/chartjs/Chart.bundle.min.js"></script>
    <script src="vendor/select2/select2.min.js">
    </script>
    <script type="text/javascript" src="vendor/DataTables/datatables.min.js"></script>
    <!-- Main JS-->
    <script src="js/main.js"></script>
    <script>
        $(document).ready(function() {
            $('#myTable').DataTable();
        });

        function mobileDetail(email) {

            console.log("showing mobile details");
            $('#largeModal').find('#tableHead').text('');
            $('#largeModal').find('#tableBody').text('');
            var i = 1;
            // $('#tableHead').append(
            //     '<tr>' +
            //     '<th>#</th>' +
            //     '<th>Name</th>' +
            //     '<th>Number</td>' +
            //     '<th>Contact</th>' +
            //     '<th>Infected</th>' +
            //     '<th>Last Test</th>' +
            //     '<th>Mark Infected</th>' +
            //     '</tr>'
            // );
            $('#tableHead').append(
                '<tr>' +
                '<th>#</th>' +
                '<th>Name</th>' +
                '<th>Number</td>' +
                '<th>Contact</th>' +
                '<th>Infected</th>' +
                '<th>Mark Infected</th>' +
                '</tr>'
            );
            $.ajax({
                type: "GET",
                url: "php_scripts/getmobiles.php?email=" + email,
                dataType: "JSON",
                success: function(data) {
                    $(data).each(
                        function() {
                            var mobileName = this.mobileName;
                            var mobileNumber = this.mobileNumber;
                            var contactWithInfected = this.contactWithInfected;
                            var confirmInfected = this.confirmInfected;
                            var dateTimeLastTest = this.dateTimeLastTest;

                            // $('#tableBody').append(
                            //     '<tr class="tr-shadow">' +
                            //     '<td>' + i + '</td>' +
                            //     '<td>' + mobileName + '</td>' +
                            //     '<td>' + mobileNumber + '</td>' +
                            //     '<td>' + (Boolean(Number(contactWithInfected)) ? '<input disabled readonly type="checkbox" checked />' : '<input disabled readonly type="checkbox" />') + '</td>' +
                            //     '<td>' + (Boolean(Number(confirmInfected)) ? '<input disabled readonly type="checkbox" checked />' : '<input disabled readonly type="checkbox" />') + '</td>' +
                            //     '<td>' + ((dateTimeLastTest == null) ? '-' : (new Date(dateTimeLastTest * 1000)).toLocaleString()) + '</td>' +
                            //     '<td>' + (Boolean(Number(confirmInfected)) ? '<button class="btn btn-success" onclick="updateDB(\'' + mobileNumber + '\', \'reset\',\'' + email + '\');">Reset</button>' : '<button class="btn btn-danger" onclick="updateDB(\'' + mobileNumber + '\', \'infected\', \'' + email + '\');">Infected</button>') + '</td>' +
                            //     '</tr>'
                            // );

                            $('#tableBody').append(
                                '<tr class="tr-shadow">' +
                                '<td>' + i + '</td>' +
                                '<td>' + mobileName + '</td>' +
                                '<td>' + mobileNumber + '</td>' +
                                '<td>' + (Boolean(Number(contactWithInfected)) ? '<input disabled readonly type="checkbox" checked />' : '<input disabled readonly type="checkbox" />') + '</td>' +
                                '<td>' + (Boolean(Number(confirmInfected)) ? '<input disabled readonly type="checkbox" checked />' : '<input disabled readonly type="checkbox" />') + '</td>' +
                                '<td>' + (Boolean(Number(confirmInfected)) ? '<button class="btn btn-success" onclick="updateDB(\'' + mobileNumber + '\', \'reset\',\'' + email + '\');">Reset</button>' : '<button class="btn btn-danger" onclick="updateDB(\'' + mobileNumber + '\', \'infected\', \'' + email + '\');">Infected</button>') + '</td>' +
                                '</tr>'
                            );
                            i++;
                        });
                },
                error: function(data) {
                    alert("error happen please reload");
                }
            });
            $('#largeModal').modal('show');

        }

        function updateDB(mobileNumber, request, email) {
            console.log("updating db");

            // alert(mobileid);
            //var x = "1";
            $.ajax({
                type: "post",
                dataType: "json",
                url: "php_scripts/updateMobile.php",
                data: {
                    mobileNumber: mobileNumber,
                    req: request
                },
                cache: false,
                success: function(Record) {
                    // alert("1");
                    //  console.log(Record);
                    if (Record.inserted == true) {
                        // $('#largeModal').modal('hide');
                        //alert("2" + req);     
                        sendNotification(mobileNumber, request);
                        // console.log(output);
                        mobileDetail(email);

                    } else {
                        alert("An Error happened. Please Retry");
                    }
                },
                Error: function(textMsg) {
                    // alert('2');
                    console.log(textMsg);
                    console.log(Error);
                }
            });

        }

        function sendNotification(mobileNumber, request) {

            console.log("sending notification");

            // alert(mobileid);
            //var x = "1";
            $.ajax({
                type: "post",
                dataType: "json",
                url: "php_scripts/notifyMobile.php",
                data: {
                    mobileNumber: mobileNumber,
                    req: request
                },
                cache: false,
                success: function(Record) {
                    console.log("notifictionSent");
                    // return true;
                },
                Error: function(textMsg) {
                    // alert('2');
                    console.log(Error);
                    console.log(textMsg);
                    //  return false;
                }
            });

        }
    </script>
    <script type="text/javascript">
        // $(document).ready(
        //     function() {
        //         alert("1");
        //         var data = $("#employee").val();
        //         alert("2");
        //         $.ajax({

        //             url: 'http://localhost:8080/online/fecthcourse',
        //             type: 'GET',
        //             dataType: 'JSON',


        //         });
        //     });
    </script>

</body>

</html>
<!-- end document-->