<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/database.php';
//require_once $_SERVER['DOCUMENT_ROOT'] . '/Website/php_scripts/verifySession.php';
?>
<?php
session_start();
if (isset($_COOKIE["email"]) && isset($_COOKIE["username"]) && isset($_COOKIE["password"])) {
    $email =    $_SESSION["email"]       =   $_COOKIE["email"];
    $username =  $_SESSION["username"] = $_COOKIE["username"];
    $password =  $_SESSION["password"] = $_COOKIE["password"];
}
if (isset($_SESSION["email"]) && isset($_SESSION["username"]) && isset($_SESSION["password"])) {
    $email =    $_SESSION["email"];
    $username =  $_SESSION["username"];
    $password =  $_SESSION["password"];
    $loggedin = true;
    $db = new database();
    session_write_close();
} else {
    // since the username is not set in session, the user is not-logged-in
    // he is trying to access this page unauthorized
    // so let's clear all session variables and redirect him to index
    session_unset();
    session_write_close();
}
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
    <title>Dashboard</title>

    <!-- Fontfaces CSS-->
    <link href="css/font-face.css" rel="stylesheet" media="all">
    <link href="vendor/font-awesome-4.7/css/font-awesome.min.css" rel="stylesheet" media="all">
    <link href="vendor/font-awesome-5/css/fontawesome-all.min.css" rel="stylesheet" media="all">
    <link href="vendor/font-awesome-5/css/all.min.css" rel="stylesheet" media="all">
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
                        <li class="active">
                            <a class="js-arrow" href="index.php">
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
                                        <?php
                                        if ($loggedin) {
                                            print '
                                            <div class="image">
                                                <img src="images/icon/icons8-circled-' . substr(strtolower($username), 0, 1) . '-50.png" alt="' . $username . '" />
                                            </div>
                                            <div class="content">
                                                <a class="js-acc-btn" href="#">' . $username . '</a>
                                            </div>
                                            <div class="account-dropdown js-dropdown">
                                                <div class="info clearfix">
                                                    <div class="image">
                                                        <a href="#">
                                                            <img src="images/icon/icons8-circled-' . substr(strtolower($username), 0, 1) . '-50.png" alt="' . $username . '" />
                                                        </a>
                                                    </div>
                                                    <div class="content">
                                                        <h5 class="name">
                                                            <a href="#">' . $username . '</a>
                                                        </h5>
                                                        <span class="email">' . $email . '</span>
                                                    </div>
                                                </div>
                                                <div class="account-dropdown__footer">
                                                    <a href="logout.php">
                                                        <i class="zmdi zmdi-power"></i>Logout</a>
                                                </div>
                                            </div>
                                            ';
                                        } else {
                                            print '<button class="btn btn-dark" onclick="window.location.href = \'login.php\';">Login</button>';
                                        }
                                        ?>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <!-- HEADER DESKTOP-->

            <!-- MAIN CONTENT-->
            <div class="main-content">
                <div class="section__content section__content--p30">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="overview-wrap">
                                    <h2 class="title-1">overview</h2>
                                    <!-- <button class="au-btn au-btn-icon au-btn--blue">
                                        <i class="zmdi zmdi-plus"></i>add item</button> -->
                                </div>
                            </div>
                        </div>
                        <br>
                        <?php
                        if ($loggedin) {
                            $selectquery =
                                'SELECT COUNT(*) as active_mobiles FROM Mobile mt INNER JOIN( SELECT mobileNumber, longitude, latitude, MAX(dateTimeCoordinates) AS MaxDateTime FROM Coordinates GROUP BY mobileNumber ) ct ON mt.mobileNumber = ct.mobileNumber;';
                            $data = $db->select($selectquery);
                            if (isset($data) && $data != null) { //if there is something in the result
                                $active_mobile = $data[0]['active_mobiles'];
                            }


                            $selectquery =
                                'SELECT COUNT(*) as concact_trace FROM Mobile WHERE contactWithInfected = TRUE AND dateTimeLastTest IS NULL;';
                            $data = $db->select($selectquery);
                            if (isset($data) && $data != null) { //if there is something in the result
                                $concact_trace = $data[0]['concact_trace'];
                            }


                            $selectquery =
                                'SELECT COUNT(*) as infected_person FROM Mobile WHERE confirmInfected = TRUE;';
                            $data = $db->select($selectquery);
                            if (isset($data) && $data != null) { //if there is something in the result
                                $infected_person = $data[0]['infected_person'];
                            }




                            print '
                            <div class="row m-t-25">
                                <div class="col-sm-6 col-lg-3">
                                    <div class="overview-item overview-item--c1">
                                        <div class="overview__inner" style="height: 200px;">
                                            <div class="overview-box clearfix">
                                                <div class="icon">
                                                    <i class="fas fa-mobile"></i>
                                                </div>
                                                <div class="text">
                                                    <h2>' . $active_mobile . '</h2>
                                                    <span>active mobiles</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6 col-lg-3">
                                    <div class="overview-item overview-item--c2">
                                        <div class="overview__inner" style="height: 200px;">
                                            <div class="overview-box clearfix">
                                                <div class="icon">
                                                    <i class="fas fa-users"></i>
                                                </div>
                                                <div class="text">
                                                    <h2>' . $concact_trace . '</h2>
                                                    <span>contact trace</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6 col-lg-3">
                                    <div class="overview-item overview-item--c3">
                                        <div class="overview__inner" style="height: 200px;">
                                            <div class="overview-box clearfix">
                                                <div class="icon">
                                                    <i class="fas fa-viruses"></i>
                                                </div>
                                                <div class="text">
                                                    <h2>' . $infected_person . '</h2>
                                                    <span>infected person</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6 col-lg-3">
                                    <div class="overview-item overview-item--c4">
                                        <div class="overview__inner" style="height: 200px;">
                                            <div class="overview-box clearfix">
                                                <div class="icon">
                                                    <i class="fas fa-shield-virus"></i>
                                                </div>
                                                <div class="text">
                                                    <h2 id="fullyVaccinated">
                                                    </h2>
                                                    <span>fully vaccinated mauritian</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>';
                        }
                        ?>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="au-card recent-report">
                                    <div class="au-card-inner">
                                        <h3 class="title-2">Death in Mauritius</h3>
                                        <div class="recent-report__chart">
                                            <canvas id="death-chart"></canvas>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="au-card chart-percent-card">
                                    <div class="au-card-inner">
                                        <h3 class="title-2 tm-b-5">Mauritius Covid Statistics</h3>
                                        <div class="row no-gutters">
                                            <div class="col-xl-4">
                                                <div class="chart-note-wrap">
                                                    <div class="chart-note mr-0 d-block">
                                                        <span class="dot" id="dot-non-inf"></span>
                                                        <span>Non-infected population</span>
                                                    </div>
                                                    <div class="chart-note mr-0 d-block">
                                                        <span class="dot" id="dot-case"></span>
                                                        <span>Positive cases</span>
                                                    </div>
                                                    <div class="chart-note mr-0 d-block">
                                                        <span class="dot" id="dot-death"></span>
                                                        <span>Death</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-xl-8">
                                                <div class="percent-chart">
                                                    <canvas id="percent-chart-covid"></canvas>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-9">
                                <h2 class="title-1 m-b-25">Death world-wide</h2>
                                <div class="recent-report__chart">
                                    <canvas id="death-chart-world"></canvas>
                                </div>
                            </div>
                            <div class="col-lg-3">
                                <h2 class="title-1 m-b-25">Highest Deaths</h2>
                                <div class="au-card au-card--bg-blue au-card-top-countries m-b-40">
                                    <div class="au-card-inner">
                                        <div class="table-responsive">
                                            <table class="table table-top-countries" id="top_country">
                                            </table>
                                        </div>
                                    </div>
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
            <!-- END MAIN CONTENT-->
            <!-- END PAGE CONTAINER-->
        </div>

    </div>

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
    </script>
    <script src="vendor/jquery-csv/jquery.csv-0.71.js"></script>
    </script>

    <!-- Main JS-->
    <script src="js/main.js"></script>

</body>

</html>
<!-- end document-->
<script>
    function tableCreate(arraytable) {
        var tbl = document.getElementById('top_country');
        var tbdy = document.createElement('tbody');
        arraytable.forEach(element => {
            var tr = document.createElement('tr');
            for (var i = 0; i < element.length; i++) {
                var td = document.createElement('td');
                td.appendChild(document.createTextNode(element[i]));
                (i == (element.length - 1)) ? td.setAttribute('class', "text-right"): null;
                tr.appendChild(td);
            }
            tbdy.appendChild(tr);
            tbl.appendChild(tbdy);
        });
    }



    function buildChart(array_death_mauritius, elementId, labelString, ctxheight) {
        var myLabels = [];
        var myData = [];
        for (var i = 0; i < array_death_mauritius.length; i++) {
            var row = array_death_mauritius[i];
            var datestr = row[1];
            var result = datestr.substring(0, datestr.length - 3);
            myLabels.push(result);
            myData.push(Math.ceil(row[0]));
        }
        try {
            var ctx = document.getElementById(elementId);
            if (ctx) {
                if (ctxheight === undefined) {} else {
                    ctx.height = ctxheight;
                }
                var myChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: myLabels, //["2010", "2011", "2012", "2013", "2014", "2015", "2016"],
                        type: 'line',
                        defaultFontFamily: 'Poppins',
                        datasets: [{
                            label: "Deaths due to covid",
                            data: myData, //[0, 30, 10, 120, 50, 63, 10],
                            backgroundColor: 'transparent',
                            borderColor: 'rgba(220,53,69,0.75)',
                            borderWidth: 3,
                            pointStyle: 'circle',
                            pointRadius: 5,
                            pointBorderColor: 'transparent',
                            pointBackgroundColor: 'rgba(220,53,69,0.75)',
                        }]
                    },
                    options: {
                        responsive: true,
                        tooltips: {
                            mode: 'index',
                            titleFontSize: 12,
                            titleFontColor: '#000',
                            bodyFontColor: '#000',
                            backgroundColor: '#fff',
                            titleFontFamily: 'Poppins',
                            bodyFontFamily: 'Poppins',
                            cornerRadius: 3,
                            intersect: false,
                        },
                        legend: {
                            display: false,
                            labels: {
                                usePointStyle: true,
                                fontFamily: 'Poppins',
                            },
                        },
                        scales: {
                            xAxes: [{
                                display: true,
                                gridLines: {
                                    display: false,
                                    drawBorder: false
                                },
                                scaleLabel: {
                                    display: false,
                                    labelString: 'Month'
                                },
                                ticks: {
                                    fontFamily: "Poppins"
                                }
                            }],
                            yAxes: [{
                                display: true,
                                gridLines: {
                                    display: false,
                                    drawBorder: false
                                },
                                scaleLabel: {
                                    display: true,
                                    labelString: labelString,
                                    fontFamily: "Poppins"

                                },
                                ticks: {
                                    fontFamily: "Poppins"
                                }
                            }]
                        },
                        title: {
                            display: false,
                            text: 'Normal Legend'
                        }
                    }
                });
            }


        } catch (error) {
            console.log(error);
        }
    }

    function buildPercentChart(arr, elementId, ctxheight) {
        // Percent Chart
        var ctx = document.getElementById(elementId);
        if (ctx) {
            //ctx.height = 280;
            if (ctxheight === undefined) {
                ctx.height = 300;
            } else {
                ctx.height = ctxheight;
            }
            var myChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    datasets: [{
                        label: "My First dataset",
                        data: [arr[0][1], arr[1][1], arr[2][1]],
                        backgroundColor: [
                            arr[0][2],
                            arr[1][2],
                            arr[2][2]
                        ],
                        hoverBackgroundColor: [
                            arr[0][2],
                            arr[1][2],
                            arr[2][2]
                        ],
                        borderWidth: [
                            0, 0
                        ],
                        hoverBorderColor: [
                            'transparent',
                            'transparent',
                            'transparent'
                        ]
                    }],
                    labels: [
                        arr[0][0],
                        arr[1][0],
                        arr[2][0]
                    ]
                },
                options: {
                    maintainAspectRatio: false,
                    responsive: true,
                    cutoutPercentage: 55,
                    animation: {
                        animateScale: true,
                        animateRotate: true
                    },
                    legend: {
                        display: false
                    },
                    tooltips: {
                        titleFontFamily: "Poppins",
                        xPadding: 15,
                        yPadding: 10,
                        caretPadding: 0,
                        bodyFontSize: 16
                    }
                }
            });
        }


    }
    $(document).ready(function() {

        $.ajax({
            type: "GET",
            url: "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/latest/owid-covid-latest.csv",
            // url: "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/country_data/Mauritius.csv",
            dataType: "text",
            success: function(response) {
                var data = $.csv.toArrays(response);
                var findPeople = data[0].indexOf("people_fully_vaccinated");
                var findLocation = data[0].indexOf("location");
                var findPopulation = data[0].indexOf("population");
                var findTotalDeath = data[0].indexOf("total_deaths");
                var findTotalCase = data[0].indexOf("total_cases");
                var arr_total_deaths = [];
                for (var i = 1; i < data.length; i++) {
                    var row = data[i];
                    var areEqual = row[findLocation].toUpperCase() === ("mauritius").toUpperCase();
                    if (areEqual) {
                        var people_fully_vaccinated = Math.ceil(parseFloat(row[findPeople]));
                        $('#fullyVaccinated ').text(people_fully_vaccinated);
                        var population = row[findPopulation];
                        var total_cases = row[findTotalCase];
                        var total_deaths = row[findTotalDeath];
                        //proportion
                        var full_pop = parseFloat(population) + parseFloat(total_deaths); //represent 100%
                        var percentage_cases = parseFloat(100 / full_pop) * parseFloat(total_cases); //represent % cases
                        var percentage_deaths = parseFloat(percentage_cases / full_pop) * parseFloat(total_deaths); //represent % deaths in cases
                        var remaining_non_infected = 100 - parseFloat(percentage_cases);

                        var deathcol = '#fa4251';
                        var casecol = '#F9BF00';
                        var noninfcol = '#39FF1B';
                        var deatharr = ["Deaths (" + Math.ceil(total_deaths) + ")", percentage_deaths, deathcol];
                        var casearr = ["Positive Cases (" + Math.ceil(total_cases) + ")", percentage_cases, casecol];
                        var noninfarr = ["Non-Infected (" + Math.ceil(parseFloat(population) - parseFloat(total_cases)) + ")", remaining_non_infected, noninfcol];
                        var arr = [deatharr, casearr, noninfarr];
                        buildPercentChart(arr, "percent-chart-covid");
                        document.getElementById("dot-death").style.background = deathcol;
                        document.getElementById("dot-case").style.background = casecol;
                        document.getElementById("dot-non-inf").style.background = noninfcol;
                    }
                    arr_total_deaths.push([row[findLocation], row[findTotalDeath]]);
                }
                arr_total_deaths.sort(function(a, b) {
                    return b - a;
                });
                tableCreate(arr_total_deaths.slice(0, 8));

            }
        });
        $.ajax({
            type: "GET",
            url: "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/jhu/total_deaths.csv",
            dataType: "text",
            success: function(response) {
                var data = $.csv.toArrays(response);
                var findMauritius = data[0].indexOf("Mauritius");
                var findWorld = data[0].indexOf("World");
                var findDate = data[0].indexOf("date");
                var array_death_mauritius = [];
                var array_death_world = [];
                for (var i = 1; i < data.length; i++) {
                    var row = data[i];
                    try {
                        var text = row[findDate];
                        var result = text.substring(text.length - 2, text.length);
                        if (result == "01") {
                            var mauritiusnum = (row[findMauritius] == '') ? '0.0' : row[findMauritius];
                            array_death_mauritius.push([mauritiusnum, row[findDate]]);
                            var worldnum = (row[findWorld] == '') ? '0.0' : row[findWorld];
                            array_death_world.push([worldnum, row[findDate]]);
                        }
                    } catch (e) {
                        console.log(e);
                    }
                }
                buildChart(array_death_mauritius, "death-chart", "Death in Mauritius");
                buildChart(array_death_world, "death-chart-world", "Death Worldwide");
            }
        });
    });
</script>