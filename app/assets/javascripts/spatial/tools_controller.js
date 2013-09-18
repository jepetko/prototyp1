'use strict';

toolsApp.controller('ToolsCtrl', ['$scope', '$element', '$attrs', 'sharedService', function($scope, $element, $attrs, sharedService) {
    $scope.tools = [ { id : 'zoom', label : 'Zoom', icon : 'icon-zoom-in'},
        { id : 'pick', label : 'Pick', icon : 'icon-map-marker', group : 1, type : 'selectFeature'},
        { id : 'extent', label : 'Draw Extent', icon : 'icon-retweet', group : 1, type : 'drawExtent'} ];

    $scope.lastActiveTool = null;

    $scope.group = function(tool) {
        return (tool.group === 1);
    };

    $scope.standalone = function(tool) {
        return !tool.group;
    };

    $scope.toolPicked = function() {
        var self = this;
        var noToolActive = true;
        $scope.tools.forEach( function(tool) {
            tool.active = (self.tool == tool && tool !== $scope.lastActiveTool);
            if( tool.active === true ) {
                sharedService.setMessage('tool-changed', tool);
                noToolActive = false;
                $scope.lastActiveTool = tool;
            }
        });
        if( noToolActive ) {
            sharedService.setMessage('tool-changed', null);
            $scope.lastActiveTool = null;
        }
    };

    $scope.toolClicked = function() {
        sharedService.setMessage('tool-clicked',this.tool);
    };
}]);