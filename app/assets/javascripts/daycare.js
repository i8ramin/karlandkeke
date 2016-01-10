var _setup_map = function(points){
  setup_map(points, true);
  var point = points[0];
  var lat = $(point).data('lat');
  var lon = $(point).data('lon');
  fly(lat, lon);
};

$(function(){
  _setup_map($(".daycare"));
});