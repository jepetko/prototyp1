'use strict';

/* App Module */

var layerAppDir = angular.module('layerAppDirectives', []);
layerAppDir.directive('addBootstrapSwitches', function($timeout)  {
    return function(scope, element, attrs) {
        $timeout(function() {
            element.bootstrapSwitch();
            var countRendered = $('.has-switch').length;
            var baseLayers = $('.base-layer');
            var countBase = baseLayers.length;
            if( countRendered == countBase ) {
                baseLayers.on('switch-change', function (e,data) {
                    var value = data.value;
                    if( value === true ) {
                        var $el = $(data.el);
                        var radio = $el.children('input[type="radio"]');
                        console.log(radio);
                    }
                    baseLayers.bootstrapSwitch('toggleRadioState');
                });
            }
        }, 1000);
    }
});

angular.module('httpServices', ['ngResource']).
    factory('Layer', function($resource){
        return $resource('/assets/:layerId.json', {}, {
            query: {method:'GET', params:{layerId:'layers'}, isArray:true}
        });
    });