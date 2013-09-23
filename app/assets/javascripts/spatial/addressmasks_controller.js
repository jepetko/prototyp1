'use strict';

addressmaskApp.controller('AddressMasksCtrl', ['$scope', '$element', '$attrs', 'sharedService', function($scope, $element, $attrs, sharedService) {

    $scope.street = '';
    $scope.city = '';
    $scope.zip = '';
    $scope.country = '';

    $scope.init = function() {

    };

}]);