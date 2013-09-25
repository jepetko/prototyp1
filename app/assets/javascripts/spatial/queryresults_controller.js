'use strict';

queryResultsApp.controller('QueryResultsCtrl', ['$scope', '$element', '$attrs', 'QueryResult', 'sharedService', function($scope, $element, $attrs, QueryResult, sharedService) {

    $scope.results = [];
    $scope.running = false;

    $scope.query = function(geom) {
        $scope.running = true;
        $scope.results = QueryResult.query({geom: geom}, this.success, this.error);
    };

    $scope.success = function() {
        $scope.done();
    };

    $scope.error = function() {
        $scope.done();
    };

    $scope.done = function() {
        $scope.running = false;
    };

    $scope.$on('handleBroadcast', function(evt,msg,obj) {
        switch(msg) {
            case 'feature-added':
                $scope.query(obj);
                break;
        }
    });
}]);