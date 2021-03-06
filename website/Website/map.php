<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/Website/php_scripts/markers.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/Website/php_scripts/verifySession.php';
?>
<?php
// if (!empty($_GET['submit'])) {
//if ($_SERVER("REQUEST_METHOD") == "POST") {
if (isset($_POST['addTestingCenters'])) {
    $db = new database();
    $conn = $db->getConnection();
    //if (isset($_REQUEST['submit'])) {

    $testingCenterName = "";
    if (isset($_POST['testingCenterName'])) {
        $testingCenterName = mysqli_real_escape_string($conn, $_POST['testingCenterName']);
    }
    $testingCenterAddress = "";
    if (isset($_POST['testingCenterAddress'])) {
        $testingCenterAddress = mysqli_real_escape_string($conn, $_POST['testingCenterAddress']);
    }
    $longitude = "";
    if (isset($_POST['longitude'])) {
        $longitude = mysqli_real_escape_string($conn, $_POST['longitude']);
    }
    $latitude = "";
    if (isset($_POST['latitude'])) {
        $latitude = mysqli_real_escape_string($conn, $_POST['latitude']);
    }
    $insertquery = "INSERT INTO TestingCentres (name, address, latitude, longitude) VALUES (?,?,?,?);";
    $insertparamType = "ssss";
    $insertparamArray = array($testingCenterName, $testingCenterAddress, $latitude, $longitude);
    $db->insert($insertquery, $insertparamType, $insertparamArray);
    unset($db);
    unset($conn);
}
if (isset($_POST['deleteTestingCenter'])) {
    //print 'in elseif';
    $db = new database();
    $conn = $db->getConnection();
    //if (isset($_REQUEST['submit'])) {
    //print 'in if';
    $testingCenterId = "";
    if (isset($_POST['testingCenterId'])) {
        $testingCenterId = mysqli_real_escape_string($conn, $_POST['testingCenterId']);
    }
    //print " <script>alert('this is a " . $testingCenterId . "')</script>";

    $executequery = "DELETE FROM TestingCentres WHERE testingId = ?;";
    $executeparamType = "i";
    $executeparamArray = array($testingCenterId);
    $db->execute($executequery, $executeparamType, $executeparamArray);
    // print  ;
    unset($db);
    unset($conn);
    //  print 'executed';
    //  }
    //}

} // else {
// echo 'else';
//}
//}
$markers = new markers();
$markers->getTestingCenters();
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
    <title>Maps</title>

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
    <!-- <link href="vendor/vector-map/jqvmap.min.css" rel="stylesheet" media="all"> -->

    <!-- Main CSS-->
    <link href="css/theme.css" rel="stylesheet" media="all">

    <!-- map -->
    <!-- bigmap -->
    <link rel="stylesheet" href="openlayers-2.13.1/examples/style.css" type="text/css">
    <script src="openlayers-2.13.1/lib/OpenLayers.js"></script>
    <!-- modalmap -->
    <link rel="stylesheet" href="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.9.0/css/ol.css" type="text/css">
    <script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.9.0/build/ol.js"></script>
    <!-- <script type="text/javascript" src="js/global.js"></script> -->

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
                        <li class="active">
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

            <div class="main-content">
                <div class="section__content section__content--p30">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-12">
                                <!-- MAP DATA-->
                                <div class="map-data m-b-40">
                                    <h3 class="title-3 m-b-30">
                                        <i class="zmdi zmdi-map"></i>map
                                    </h3>
                                    <div class="filters">
                                        <form action="map.php" method="post" id="addTestingCentersForm">
                                            <!-- <div class="rs-select2--dark rs-select2--md m-r-10 rs-select2--border"> -->
                                            <div class="form-group">
                                                <input class="au-input au-input--full" type="text" name="testingCenterName" id="testingCenterName" placeholder="Name">
                                            </div>
                                            <div class="form-group">
                                                <input class="au-input au-input--full" type="text" name="testingCenterAddress" id="testingCenterAddress" placeholder="Address">
                                            </div>

                                            <div class="form-group">
                                                <input class="au-input" style="width:40%" type="text" readonly name="longitude" id="longitude" placeholder="Longitude">
                                                <input class="au-input" style="width:40%" type="text" readonly name="latitude" id="latitude" placeholder="Latitude">
                                                <button type="button" class="btn btn-secondary mb-1" data-toggle="modal" data-target="#largeModal">
                                                    <i class="fas fa-map-marker-alt"></i>
                                                </button>
                                            </div>
                                            <div class="form-group">
                                                <button type="submit" name="addTestingCenters" class="btn btn-primary btn-sm">
                                                    <i class="fa fa-dot-circle-o"></i> Add Testing Center
                                                </button>
                                            </div>
                                            <!-- </div> -->


                                            <!-- <div class="rs-select2--dark rs-select2--sm rs-select2--border">
                                            <select class="js-select2 au-select-dark" name="time">
                                                <option selected="selected">All Time</option>
                                                <option value="">By Month</option>
                                                <option value="">By Day</option>
                                            </select>
                                            <div class="dropDownSelect2"></div>
                                        </div> -->
                                        </form>
                                    </div>

                                    <!--                                    <div id="mapdiv" style="max-width:100%; height: 600px;"></div> -->
                                    <div class="map-wrap m-t-45 m-b-20">
                                        <div id="mapdiv" style="max-width:100%; height: 600px;"></div>
                                        <!-- <div id="vmap" style="height: 284px;"></div> -->
                                    </div>


                                </div>
                                <!-- END MAP DATA-->
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
            <div class="modal-content" style="width: 550px;">
                <div class="modal-header">
                    <h5 class="modal-title" id="largeModalLabel">Select Location</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="map" style="width: 500px; height: 400px; margin: auto;"></div>
                </div>
                <!-- <div class="modal-footer">
                     <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                     <button type="button" class="btn btn-primary">Confirm</button>
                 </div> -->
            </div>
        </div>
    </div>
    <!-- end modal large -->
    <!-- modal medium -->
    <div class="modal fade" id="mediumModal" tabindex="-1" role="dialog" aria-labelledby="mediumModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="mediumModalLabel">Testing Center</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                </div>
                <div class="modal-footer">
                    <form method="POST" onsubmit="return confirm('Are you sure you want to delete?');" action="map.php">
                        <!-- action="map.php" -->
                        <input type="hidden" id="testingCenterId" name="testingCenterId" />
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="submit" name="deleteTestingCenter" class="btn btn-primary">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!-- end modal medium -->


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
    <!-- <script src="vendor/vector-map/jquery.vmap.js"></script>
    <script src="vendor/vector-map/jquery.vmap.min.js"></script>
    <script src="vendor/vector-map/jquery.vmap.sampledata.js"></script>
    <script src="vendor/vector-map/jquery.vmap.world.js"></script>
    <script src="vendor/vector-map/jquery.vmap.brazil.js"></script>
    <script src="vendor/vector-map/jquery.vmap.europe.js"></script>
    <script src="vendor/vector-map/jquery.vmap.france.js"></script>
    <script src="vendor/vector-map/jquery.vmap.germany.js"></script>
    <script src="vendor/vector-map/jquery.vmap.russia.js"></script>
    <script src="vendor/vector-map/jquery.vmap.usa.js"></script> -->
    <!-- <script src="https://www.openlayers.org/api/OpenLayers.js"></script> -->
    <!-- <script src="../layout/scripts/myjs.js"></script> -->

    <!-- Main JS-->
    <script src="js/main.js"></script>
    <!-- User defined JS-->

    <!-- <script src="js/classes.js"></script> -->
    <script src="js/bigMap.js"></script>

    <script type="text/javascript" src="js/global.js"></script>

    <script src="js/modalMap.js"></script>
    <script src="js/jquery.validate.min.js"></script>
    <script src="js/jquery.additional-methods.min.js"></script>
    <script>
        $("#addTestingCentersForm").validate({
            rules: {
                // compound rule
                testingCenterName: {
                    required: true,
                },
                testingCenterAddress: {
                    required: true,
                },
                longitude: {
                    required: true,
                },
                latitude: {
                    required: true,
                },
            }
        });
    </script>
    <script>
        // window.open(url '_blank');
    </script>

</body>

</html>
<!-- end document-->