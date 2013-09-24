'use strict';

/* App Module */

var layerApp = angular.module('layerApp', []);

var httpServices = angular.module('httpServices', ['ngResource']);
httpServices.factory('Layer', function($resource){
    return $resource('/layers.json?type=:type', {type:'@type'}, {
        query: {method:'GET', params:{type: '@type'}, isArray:true}
    });
});
httpServices.factory('Tool', function($resource) {
    return $resource('/tools.json?group=:group', {group:'@group'}, {
        query: {method:'GET', params:{group: '@group'}, isArray:true}
    });
});

var mapApp = angular.module('mapApp',[]);
var toolsApp = angular.module('toolsApp', []);
var expandersApp = angular.module('expandersApp', []);
var locationFindersApp = angular.module('locationFindersApp', []);