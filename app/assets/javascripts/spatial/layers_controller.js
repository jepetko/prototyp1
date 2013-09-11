'use strict';

layerApp.controller('LayerListCtrl', ['$scope', 'Layer', 'sharedService', function($scope, Layer, sharedService) {
    $scope.layers = Layer.query();
    $scope.myBaseLayer = null;

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