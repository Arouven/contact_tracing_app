
//start building big map

function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition);
    } else {
        alert("Geolocation is not supported by this browser.");
    }
}

function showPosition(position) {
    Location.latitude = position.coords.latitude;
    Location.longitude = position.coords.longitude;
    Location.zoom = 15;
}


function bigMapBuilder() {
    map = new OpenLayers.Map("mapdiv");

    map.addLayer(new OpenLayers.Layer.OSM());
    map.addLayer(new OpenLayers.Layer.OSM("Wikimedia",
        ["https://maps.wikimedia.org/osm-intl/${z}/${x}/${y}.png"], {
        attribution: "&copy; <a href='http://www.openstreetmap.org/'>OpenStreetMap</a> and contributors, under an <a href='http://www.openstreetmap.org/copyright' title='ODbL'>open license</a>. <a href='https://www.mediawiki.org/wiki/Maps'>Wikimedia's new style (beta)</a>",
        "tileOptions": { "crossOriginKeyword": null }
    }));
    map.addControls([
        new OpenLayers.Control.MousePosition(),
        new OpenLayers.Control.ScaleLine(),
        new OpenLayers.Control.LayerSwitcher(),
        new OpenLayers.Control.Permalink({ anchor: true })
    ]);
    var markersLayer = new OpenLayers.Layer.Markers("Testing Centers");
    map.addLayer(markersLayer);
    for (var i = 0; i < markers.length; i++) {
        var lon = markers[i][0];
        var lat = markers[i][1];
        var id = markers[i][2];
        var name = markers[i][3];
        var address = markers[i][4];

        var lonLatMarker = new OpenLayers.LonLat(lon, lat).transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject());
        var marker = new OpenLayers.Marker(lonLatMarker);
        marker.id = id;
        marker.name = name;
        marker.address = address;
        marker.longitude = lon;
        marker.latitude = lat;
        marker.events.register("click", marker, function () {
            console.log(this.id);
            console.log(this.name);
            console.log(this.address);
            console.log(this.longitude);
            console.log(this.latitude);
            openMediumModal(this.id, this.name, this.address, this.longitude, this.latitude);
        });
        markersLayer.addMarker(marker);
    }

    if (!map.getCenter()) {
        map.setCenter(new OpenLayers.LonLat(Location.longitude, Location.latitude).transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject()), Location.zoom);
    }


};
function openMediumModal(id, name, address, longitude, latitude) {
    var text = "Name: " + name + "<br>Address: " + address + "<br>(longitude, latitude): (" + longitude + ", " + latitude + ")";
    $('#mediumModal').on('shown.bs.modal', function () {
        $('#mediumModal').find('.modal-body').text('');
        $('#mediumModal').find('.modal-body').append(text);
        $('#mediumModal').find('#hiddenId').append(id);
    });
    $("#mediumModal").modal('show');
};
$(document).ready(function () {//build the big map 
    getLocation();
    bigMapBuilder();


});
//end building big map


