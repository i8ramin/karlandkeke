$(function(){
  if (!mapboxgl.supported()) {
    alert('Your browser does not support Mapbox GL');
  } else {
  	setup_map($(".daycare"));
  }
});