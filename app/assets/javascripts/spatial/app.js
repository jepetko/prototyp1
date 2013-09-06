'use strict';

/* App Module */

angular.module('layerAppDirectives', [])
    .directive('layerCount', ['$timeout', function (timer) {
        return {
            link: function (scope, elem, attrs, ctrl) {
                var callback = $.proxy(function () {
                    console.log('layerCount directive called:');
                    console.log(attrs);
                }, scope);
                timer(callback,2000);
            }
        }
    }]);

angular.module('httpServices', ['ngResource']).
    factory('Layer', function($resource){
        return $resource('/assets/:layerId.json', {}, {
            query: {method:'GET', params:{layerId:'layers'}, isArray:true}
        });
    });