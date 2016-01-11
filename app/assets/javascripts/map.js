var map;

var setup_map = function(points, show_popup_on_load, interactive) {
  
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
  var markers = [];

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
    var lat = $(point).data('lat') || point.location[1];
    var lon = $(point).data('lon') || point.location[0];
    var center_name = $(point).data('center_name') || point.center_name;
    var permalink   = $(point).data('permalink') || ('/daycare/' + point.permalink);
    var num_violations = $(point).data('num_violations');
    num_violations = num_violations ? num_violations + ' violations' : '';
    var grade = $(point).data('grade') || point.grade;
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
        "description": num_violations,
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
    var popupContent =  '<a href="' + feature.properties.url + '">' +
                            '<strong>' + feature.properties.title + '</strong>' +
                        '</a>' +
                        '<div>' +
                          feature.properties.description +
                        '</div>';

    marker.bindPopup(popupContent);
    if (show_popup_on_load) {
      marker.openPopup();
    }
    markers[feature.properties.url] = marker;
  });

  markerLayer.setGeoJSON(geojson);
  if (geojson.features.length > 0) {
    map.fitBounds(markerLayer.getBounds());  
  }

  if (interactive) {
    $(".daycare").on("mouseover", function(e) {
      $('.daycare').removeClass("hovering");
      var $daycare  = $(e.currentTarget);
      var permalink = $daycare.data('permalink');
      var marker    = markers[permalink];
      if (marker) {
        marker.openPopup();
      }
      $daycare.addClass("hovering");
    });
  }

  // Map view
  if (window.location.pathname === '/map') {
    // Add all-grades as a menu item in the dropdown list
    $(".grades-filter .dropdown-menu").prepend('<a class="dropdown-item" data-filter="all" href="/">' + 
        '<span>All Grades</span>' + '</a>');
    
    $('a.dropdown-item').on('click', function() {
      var filter = $(this).data('filter');
      
      markerLayer.setFilter(function(f) {
        return (filter === 'all') ? true : f.properties["marker-symbol"] === filter;
      });
      return false;
    });
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
