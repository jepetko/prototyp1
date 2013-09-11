'use strict';

toolsApp.controller('ToolsCtrl', ['$scope', 'sharedService', function($scope, sharedService) {
    $scope.tools = [ { id : 'zoom', label : 'Zoom', icon : 'icon-zoom-in'},
        { id : 'pick', label : 'Pick', icon : 'icon-map-marker'},
        { id : 'extent', label : 'Draw Extent', icon : 'icon-retweet'} ];

    $scope.toolPicked = function() {
        var self = this;
        $scope.tools.forEach( function(tool) {
            tool.active = (self.tool == tool) ? 'active' : 'inactive';
            if( tool.active === 'active' ) {
                sharedService.setMessage('tool-changed', tool);
            }
        });
    }
}]);