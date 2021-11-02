
//start building big map

var longi = 8.0;
var lati = 50.3;
var zoom = 1;

function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition);
    } else {
        longi = 8.0;
        lati = 50.3;
        zoom = 1;
        alert("Geolocation is not supported by this browser.");
    }
}

function showPosition(position) {
    lati = position.coords.latitude;
    longi = position.coords.longitude;
    zoom = 10;
}



function bigMapBuilder() {
    epsg4326 = new OpenLayers.Projection("EPSG:4326")
    bmap = new OpenLayers.Map({
        div: "mapdiv",
        displayProjection: epsg4326 // With this setting, lat and lon are displayed correctly in MousePosition and permanent anchor
    });

    bmap.addLayer(new OpenLayers.Layer.OSM());
    bmap.addLayer(new OpenLayers.Layer.OSM("Wikimedia",
        ["https://maps.wikimedia.org/osm-intl/${z}/${x}/${y}.png"], {
        attribution: "&copy; <a href='http://www.openstreetmap.org/'>OpenStreetMap</a> and contributors, under an <a href='http://www.openstreetmap.org/copyright' title='ODbL'>open license</a>. <a href='https://www.mediawiki.org/wiki/Maps'>Wikimedia's new style (beta)</a>",
        "tileOptions": {
            "crossOriginKeyword": null
        }
    }));

    bmap.addControls([
        new OpenLayers.Control.MousePosition(),
        new OpenLayers.Control.ScaleLine(),
        new OpenLayers.Control.LayerSwitcher(),
        new OpenLayers.Control.Permalink({
            anchor: true
        })
    ]);

    projectTo = bmap.getProjectionObject(); //The map projection (Spherical Mercator)
    var lonLat = new OpenLayers.LonLat(longi, lati).transform(epsg4326, projectTo);
    if (!bmap.getCenter()) {
        bmap.setCenter(lonLat, zoom);
    }


    var colorList = ["red"];
    var layerName = [markers[0][2]];
    var styleArray = [new OpenLayers.StyleMap({
        pointRadius: 6,
        fillColor: colorList[0],
        fillOpacity: 0.5
    })];
    var vectorLayer = [new OpenLayers.Layer.Vector(layerName[0], {
        styleMap: styleArray[0]
    })]; // First element defines first Layer

    var j = 0;
    for (var i = 1; i < markers.length; i++) {
        if (!layerName.includes(markers[i][2])) {
            j++;
            layerName.push(markers[i][2]); // If new layer name found it is created
            styleArray.push(new OpenLayers.StyleMap({
                pointRadius: 6,
                fillColor: colorList[j % colorList.length],
                fillOpacity: 0.5
            }));
            vectorLayer.push(new OpenLayers.Layer.Vector(layerName[j], {
                styleMap: styleArray[j]
            }));
        }
    }

    //Loop through the markers array
    for (var i = 0; i < markers.length; i++) {
        var lon = markers[i][0];
        var lat = markers[i][1];
        var feature = new OpenLayers.Feature.Vector(
            new OpenLayers.Geometry.Point(lon, lat).transform(epsg4326, projectTo), {
            description: "marker number " + i
        });
        vectorLayer[layerName.indexOf(markers[i][2])].addFeatures(feature);
    }
    for (var i = 0; i < layerName.length; i++) {
        bmap.addLayer(vectorLayer[i]);
    }
};

$(document).ready(function () {//build the big map 

    getLocation();
    bigMapBuilder();
});
//end building big map