'use strict';

expandersApp.controller('ExpandersCtrl', ['$scope', 'sharedService', function($scope, sharedService) {
    $scope.state = 'collapsed';
    $scope.btnClicked = function() {

        $('#map-tools').removeClass($scope.state);
        if($scope.state == 'collapsed') {
            $scope.state = 'expanded';
        } else {
            $scope.state = 'collapsed';
        }
        $('#map-tools').addClass($scope.state);
    };
}]);