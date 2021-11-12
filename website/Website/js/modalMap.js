//start modal map
var modalmap = new ol.Map({
    layers: [
        new ol.layer.Tile({
            name: 'osm layer',
            source: new ol.source.OSM()
        }),
    ],
    target: 'map',
    view: new ol.View({
        center: ol.proj.transform([Location.longitude, Location.latitude], 'EPSG:4326', 'EPSG:3857'),
        zoom: Location.zoom
    })
});

function addMarker(position) {
    modalmap.getLayers().forEach(function (layer) {
        if (layer.get('name') != undefined && layer.get('name') === 'marker') {
            modalmap.removeLayer(layer);
        }
    });
    var markerlayer = new ol.layer.Vector({
        name: 'marker',
        source: new ol.source.Vector({
            features: [
                new ol.Feature({
                    geometry: new ol.geom.Point(ol.proj.fromLonLat(position)),
                })
            ],
            // style: new ol.style.Style({
            //     fill: new ol.style.Fill({
            //         color: 'rgba(255, 255, 255, 0.2)'
            //     }),
            //     stroke: new ol.style.Stroke({
            //         color: '#ffcc33',
            //         width: 2
            //     }),
            //     image: new ol.style.Circle({
            //         radius: 7,
            //         fill: new ol.style.Fill({
            //             color: '#ffcc33'
            //         })
            //     })
            // })
        })
    });
    modalmap.addLayer(markerlayer);
}

function updatelonlatbox(latitude, longitude) {
    document.getElementById('latitude').value = latitude;
    document.getElementById('longitude').value = longitude;
}
function initializeMap() {
    var mousePosition = new ol.control.MousePosition({
        coordinateFormat: ol.coordinate.createStringXY(2),
        projection: 'EPSG:4326',
        target: document.getElementById('myposition'),
        undefinedHTML: '&nbsp;'
    });
    modalmap.addControl(mousePosition);
    modalmap.on('click', function (evt) {
        var pos = ol.proj.transform(evt.coordinate, 'EPSG:3857', 'EPSG:4326');
        Location.longitude = pos[0];
        Location.latitude = pos[1];
        console.log(pos);
        addMarker(pos);
        updatelonlatbox(pos[1], pos[0]);
    });
}
$(document).ready(function () {
    //initializeMap();
    $('#largeModal').on('shown.bs.modal', function () {
        modalmap.updateSize(); //resize the map accordingly once open in modal
    });
    initializeMap();
    // $('#largeModal').on('show.bs.modal', function (event) {
    //     initializeMap();
    //     $("#map").css("width", "500px");
    //     //  $("#map").css("height", "400px");
    // });
    // $('#largeModal').on('hidden.bs.modal', function () {
    //     $("#map").html(''); //remove the map from the div
    // });
});
//end modal map