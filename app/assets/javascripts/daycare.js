var _setup_map = function(points){
  setup_map(points);
  var point = points[0];
  var lat = $(point).data('lat');
  var lon = $(point).data('lon');
  fly(lat, lon);
};

$(function(){
  if (!mapboxgl.supported()) {
    alert('Your browser does not support Mapbox GL');
  } else {
    _setup_map($(".daycare"));
  }
});