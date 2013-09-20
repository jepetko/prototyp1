'use strict';

layerApp.controller('LayerListCtrl', ['$scope', '$element', '$attrs', 'Layer', 'sharedService', function($scope, $element, $attrs, Layer, sharedService) {

    var filter = {};
    try {
        filter = $attrs['filter'] ? JSON.parse($attrs['filter']) : {}
    } catch(e) {
        //probably wrong filter passed ; not parseable
    }
    $scope.layers = Layer.query( filter );
    $scope.myBaseLayer = null;
    $scope.hasVectorLayers = false;

    $scope.filterBase = function(layer) {
        return (layer.type == 'base');
    };

    $scope.filterWFS = function(layer) {
        return (layer.type == 'wfs');
    };

    $scope.$watch('myBaseLayer', function(newValue, oldValue) {
        sharedService.setMessage('base-layer-changed', newValue);
    },true);

    $scope.init = function() {
        sharedService.setMessage('layers-loaded', $scope.layers);
    };

    $scope.getLayerByName = function(name) {
        for( var i=0; i<this.layers.length; i++ ) {
            var layer = this.layers[i];
            if( layer.name === name) return layer;
        }
        return null;
    };
}]);