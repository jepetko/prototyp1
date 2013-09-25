'use strict';

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

                //notification to update the activity state, its executed just once
                $.each(scope.$parent.layers, function(idx, layer) {
                    if( !scope.$parent.filterBase(layer)) return;
                    if( layer.checked === 'checked' ) {
                        scope.$parent.myBaseLayer = layer;
                    }
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

layerApp.directive('hasVectorLayers', function($timeout) {
    return function(scope,element, attrs) {
        $timeout(function() {
            var found = false;
            $.each(scope.layers, function(idx,layer) {
                if (found === true) return;
                if( scope.filterWFS(layer)) {
                    scope.hasVectorLayers = true;
                    found = true;
                }
            });
        }, 1000);
    }
});

queryResultsApp.directive('addSlimScroll', function($timeout) {
    return function(scope,element,attrs) {
        $timeout(function() {
            element.slimScroll({
                color: '#006ccc',
                size: '10px',
                height: '200px'
            });
        });
    }
});