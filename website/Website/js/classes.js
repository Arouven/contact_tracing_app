
//start building big map

class buildMap {
  longi;
  lati;
  zoom;
  constructor() {
    this.longi = 8.0;
    this.lati = 50.3;
    this.zoom = 1;
    this.getLocation();
  }

  // var longi = 8.0;
  // var lati = 50.3;
  // var zoom = 1;

  getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(this.showPosition);
    } else {
      alert("Geolocation is not supported by this browser.");
    }
  }

  showPosition(position) {
    this.lati = position.coords.latitude;
    this.longi = position.coords.longitude;
    this.zoom = 10;
  }



  bigMapBuilder(mapId = "mapdiv") {
    epsg4326 = new OpenLayers.Projection("EPSG:4326")
    bmap = new OpenLayers.Map({
      div: mapId,
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
    var lonLat = new OpenLayers.LonLat(this.longi, this.lati).transform(epsg4326, projectTo);
    if (!bmap.getCenter()) {
      bmap.setCenter(lonLat, this.zoom);
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
  }
}