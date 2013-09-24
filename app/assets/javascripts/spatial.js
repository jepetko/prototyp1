// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require angularjs/angular
//= require angularjs/angular-resource
//= require bootstrap-switch/bootstrap-switch.min
//= require OpenLayers-2.13.1/OpenLayers
//= require spatial/app
//= require spatial/directives
//= require spatial/layers_controller
//= require spatial/expanders_controller
//= require spatial/tools_controller
//= require spatial/locationfinders_controller
//= require spatial/providers/ol_map_controller
//= require spatial/shared/services

angular.element(document).ready(function() {
    angular.bootstrap($('#layers-app'), ['layerApp', 'globalBroadcastServices', 'httpServices']);
    angular.bootstrap($('#map-app'),    ['mapApp',   'globalBroadcastServices']);
    angular.bootstrap($('#tools-app'),  ['toolsApp', 'globalBroadcastServices', 'httpServices']);
    angular.bootstrap($('#expanders-app'), ['expandersApp', 'globalBroadcastServices']);
    angular.bootstrap($('#locationfinders-app'), ['locationFindersApp', 'globalBroadcastServices'] );
});