'use strict';

/* App Module */

angular.module('layerAppDirectives', [])
    .directive('layerCount', ['$timeout', function (timer) {
        return {
            link: function (scope, elem, attrs, ctrl) {
                var hello = $.proxy(function () {
                    console.log( scope.layers );
                }, scope);
                timer(hello,1000);
            }
        }
    }]);

angular.module('httpServices', ['ngResource']).
    factory('Layer', function($resource){
        return $resource('/assets/:layerId.json', {}, {
            query: {method:'GET', params:{layerId:'layers'}, isArray:true}
        });
    });