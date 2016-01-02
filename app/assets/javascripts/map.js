var map;

var setup_map = function(points) {
  // setup map
  mapboxgl.accessToken = 'pk.eyJ1IjoiaGsyMyIsImEiOiJjaWg2dDRmOXAwNmNpdWtrdDRvdW1xdzI2In0.F9uULd8DhCkRGltilPPZbg';

  map = new mapboxgl.Map({
    container: 'map', // container id
    style: 'mapbox://styles/hk23/ciimpkraf007n8ulx593l7qze', //stylesheet location
    center: [-74.0059, 40.7127], // starting position 40.7127° N, 74.0059° W
    zoom: 9, // starting zoom
    hash: true
  });

  // Add zoom and rotation controls to the map.
  map.addControl(new mapboxgl.Navigation());

  var geojson= {
    "type": "FeatureCollection",
    "features": []
  };

  // mapbox-gl does not support icon-color for maki icons yet
  // so, for now lets use different icons for different grades
  var get_marker_for_grade = function(grade) {
    var marker = 'building-24';
    switch(grade) {
      case 'a':
        marker = 'marker-24';
        break;
      case 'b':
        marker = 'marker-24';
        break;
      case 'c':
        marker = 'marker-stroked-24';
        break;
      case 'd':
        marker = 'marker-stroked-24';
        break;
      default:
        marker = 'building-24';
        break;
    }
    return marker
  };

  $.each(points, function(index, point) {
    var lat = $(point).data('lat');
    var lon = $(point).data('lon');
    var center_name = $(point).data('center_name');
    var grade = $(point).data('grade');
    if (!lat || !lon) {
      return true;
    }

    geojson.features.push({
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [lon, lat]
      },
      "properties": {
        "title": center_name,
        "description": "<div class=\"marker-title\">"+ center_name +"</div><div class=\"image\"><span class=\"grade grade-"+grade+"\">"+grade+"</span></div>",
        "marker-symbol": get_marker_for_grade(grade)
      }
    });
  });

  map.on('style.load', function () {
    map.addSource("markers", {
      "type": "geojson",
      "data": geojson
    });
    map.addLayer({
      "id": "markers",
      "type": "symbol",
      "source": "markers",
      "interactive": true,
      "layout": {
        "icon-image": "{marker-symbol}"
      }
    });  
  });

  // When a click event occurs near a marker icon, open a popup at the location of
  // the feature, with description HTML from its properties.
  map.on('click', function (e) {
    map.featuresAt(e.point, {layer: 'markers', radius: 10, includeGeometry: true}, function (err, features) {
      if (err || !features.length)
        return;

      var feature = features[0];
      new mapboxgl.Popup()
        .setLngLat(feature.geometry.coordinates)
        .setHTML(feature.properties.description)
        .addTo(map);
    });
  });

  // Use the same approach as above to indicate that the symbols are clickable
  // by changing the cursor style to 'pointer'.
  map.on('mousemove', function (e) {
    map.featuresAt(e.point, {layer: 'markers', radius: 10}, function (err, features) {
      map.getCanvas().style.cursor = (!err && features.length) ? 'pointer' : '';
    });
  });
};

var fly = function(lat, lon) {
  map.flyTo({
    center: [lon, lat]
  });
};

