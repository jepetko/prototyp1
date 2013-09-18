'use strict';

expandersApp.controller('ExpandersCtrl', ['$scope', 'sharedService', function($scope, sharedService) {
    $scope.state = 'collapsed';
    $scope.btnClicked = function() {
        if($scope.state == 'collapsed') {
            $scope.state = 'expanded';
        } else {
            $scope.state = 'collapsed';
        }
        sharedService.setMessage('collapse-status-changed', $scope.state);
    };
}]);