'use strict';

toolsApp.controller('ToolsCtrl', ['$scope', 'sharedService', function($scope, sharedService) {
    $scope.tools = [ { id : 'zoom', label : 'Zoom', icon : 'icon-zoom-in'},
        { id : 'pick', label : 'Pick', icon : 'icon-map-marker', group : 1},
        { id : 'extent', label : 'Draw Extent', icon : 'icon-retweet', group : 1} ];

    $scope.group = function(tool) {
        return (tool.group === 1);
    };

    $scope.standalone = function(tool) {
        return !tool.group;
    };

    $scope.toolPicked = function() {
        var self = this;
        $scope.tools.forEach( function(tool) {
            tool.active = (self.tool == tool);
            if( tool.active === 'active' ) {
                sharedService.setMessage('tool-changed', tool);
            }
        });
    };

    $scope.toolClicked = function() {
        sharedService.setMessage('tool-clicked',this.tool);
    };
}]);