$(function(){
  var daycares = [];
  setup_map(daycares);

  // TODO UI/UX - figure out a neat way to show a spinner or something
  // Call getData() and show spinner when the map is dragged
  // map.on('dragend', function(e) {
  //   var bbox = map.getBounds();
    
  //   // API expects a bounding box that looks like: topLeftLat,topLeftLon,bottomRightLat,bottomRightLon
  //   var coords = [
  //     bbox._northEast.lat, 
  //     bbox._southWest.lng, 
  //     bbox._southWest.lat, 
  //     bbox._northEast.lng
  //   ];
  //   getData(coords.join(","));
  // });
  
  var getData = function(coords) {
    var url_base = "/daycare"; //?bbox=" + coords;
    var page = 0;
    var getNextPage = function(page) {
      var url = url_base + "?per_page=750&page=" + page;
      $.getJSON(url, function(data){
        if (data.length > 0) {
          addPointsToMap(data, true);
          getNextPage(page+1);  
        }
      });  
    };
    getNextPage(page+1);
  };

  getData();
});
