'use strict';

/* App Module */

var layerApp = angular.module('layerApp', []);

layerApp.directive('addBootstrapRadioSwitches', function($timeout)  {
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
                        scope.$parent.myBaseLayer = scope.getLayerByName($el.attr('value'));
                        scope.$parent.$apply();
                    }
                    baseLayers.bootstrapSwitch('toggleRadioState');
                });
            }
        }, 1000);
    }
});
layerApp.directive('addBootstrapCheckboxSwitches', function($timeout,sharedService) {
    return function(scope,element, attrs) {
        $timeout(function() {
            element.bootstrapSwitch();
            element.on('switch-change', function(e,data) {
                var $el = $(data.el);
                var layer = scope.getLayerByName($el.attr('value'));
                sharedService.setMessage('wfs-layer-toggled', { toggled : data.value, layer : layer } );
            });
        }, 1000);
    }
});


angular.module('httpServices', ['ngResource']).
    factory('Layer', function($resource){
        return $resource('/assets/:layerId.json', {}, {
            query: {method:'GET', params:{layerId:'ol_layers'}, isArray:true}
        });
    });

var mapApp = angular.module('mapApp',[]);

var toolsApp = angular.module('toolsApp', []);
