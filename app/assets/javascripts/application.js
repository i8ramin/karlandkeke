// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

//= require semantic_ui/semantic_ui
//= require mapbox/mapbox-gl_v0.12.2

$('.ui.dropdown').dropdown();

// setup map
mapboxgl.accessToken = 'pk.eyJ1IjoiaGsyMyIsImEiOiJjaWg2dDRmOXAwNmNpdWtrdDRvdW1xdzI2In0.F9uULd8DhCkRGltilPPZbg';

var map = new mapboxgl.Map({
    container: 'map', // container id
    style: 'mapbox://styles/hk23/ciimpkraf007n8ulx593l7qze', //stylesheet location
    center: [-74.0059, 40.7127], // starting position 40.7127° N, 74.0059° W
    zoom: 9, // starting zoom
    hash: true
});