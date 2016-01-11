$(function(){
  var daycares = $("#all_daycares").data("daycare_json");
  setup_map(daycares);
});