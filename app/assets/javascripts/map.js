var map;

var setup_map = function(points, show_popup_on_load) {
  
  // setup map
  L.mapbox.accessToken = 'pk.eyJ1IjoiaGsyMyIsImEiOiJjaWg2dDRmOXAwNmNpdWtrdDRvdW1xdzI2In0.F9uULd8DhCkRGltilPPZbg';
  map = L.mapbox.map('map', 'hk23.oljk2o07')
                .setView([40.7127, -74.0059])
                .setZoom(12);
  var hash = L.hash(map);
  L.control.locate().addTo(map);

  map.on('locationfound', function(e) {
    var nearby = [e.longitude, e.latitude].join(",");
    window.location.search = "nearby=" + nearby;
  });

  var markerLayer = L.mapbox.featureLayer().addTo(map);

  var geojson= {
    "type": "FeatureCollection",
    "features": []
  };

  var get_marker_for_grade = function(grade) {
    var marker = {
      "color": "#3ca0d3",
      "symbol": grade
    };
    switch(grade) {
      case 'a':
        marker.color= "#2185D0";
        break;
      case 'b':
        marker.color= "#21BA45";
        break;
      case 'c':
        marker.color= "#FBBD08";
        break;
      case 'd':
        marker.color= "#F2711C";
        break;
      case 'e':
        marker.color= "#DB2828";
        break;
      default:
        marker.color= "#3ca0d3";
        break;
    }
    return marker
  };

  $.each(points, function(index, point) {
    var lat = $(point).data('lat');
    var lon = $(point).data('lon');
    var center_name = $(point).data('center_name');
    var permalink   = $(point).data('permalink');
    var grade = $(point).data('grade');
    var props = get_marker_for_grade(grade);
    if (!lat || !lon || lat === '0.0' || lon === '0.0') {
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
        "url": permalink,
        "description": "<div class=\"image table-cell\"><span class=\"grade grade-"+grade+"\">"+grade+"</span></div>",
        "marker-symbol": props.symbol,
        "marker-color": props.color,
        "marker-size": "large",
      }
    });
  });

  // Add custom popups to each using our custom feature properties
  markerLayer.on('layeradd', function(e) {
    var marker = e.layer,
        feature = marker.feature;

    // Create custom popup content
    var popupContent =  '<a target="_blank" class="popup" href="' + feature.properties.url + '">' +
                            // feature.properties.description +
                            feature.properties.title
                        '</a>';

    marker.bindPopup(popupContent);
    if (show_popup_on_load) {
      marker.openPopup();
    }
  });

  markerLayer.setGeoJSON(geojson);
  if (geojson.features.length > 0) {
    map.fitBounds(markerLayer.getBounds());  
  }
};

var fly = function(lat, lon, speed) {
  map.setView(new L.LatLng(lat, lon), 14);
};

$(function(){
  $('span.show_map').on('click', function(e){
    var daycare = $(e.target).closest(".daycare")[0];
    var lat = $(daycare).data('lat');
    var lon = $(daycare).data('lon');
    if (lat && lon) {
      fly(lat,lon, 10);  
    } else {
      console.log('whoops - no lat/lon available for this daycare!');
    }
    
  });
});
