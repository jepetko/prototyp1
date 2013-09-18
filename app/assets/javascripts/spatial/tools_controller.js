'use strict';

toolsApp.controller('ToolsCtrl', ['$scope', 'Tool', 'sharedService', function($scope, Tool, sharedService) {
    $scope.tools = Tool.query();
    $scope.lastActiveTool = null;

    $scope.group = function(tool) {
        return (tool.group === 1);
    };

    $scope.standalone = function(tool) {
        return !tool.group;
    };

    $scope.toolPicked = function() {
        var self = this;
        //note: noToolActive takes care about the situation that a tool is deactivated and from now on no tool is active
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