'use strict';

locationFindersApp.controller('LocationFindersCtrl', ['$scope', '$element', '$attrs', '$timeout', 'sharedService', function($scope, $element, $attrs, $timeout, sharedService) {

    $scope.location = { street : '', city : '', zip : '', country : ''};
    $scope.lastUpdated = -1;
    $scope.diff = 1000;
    $scope.running = false;
    $scope.lastLocationSent = null;

    $scope.init = function() {
        this.lastUpdated = this.now();
        $.each($scope.location, function(key) {
            $scope.$watch('location.' + key, $scope.locationPartChanged);
        });
    };

    $scope.locationPartChanged = function(newValue, oldValue) {
        $timeout( function timeoutedFind() {
            var flag = $scope.getPerformFindFlag();
            if( flag === 3 ) {
                $scope.doFind();
            } else {
                if( flag === 1 ) {
                    $timeout( timeoutedFind, $scope.diff );
                }
            }
        }, $scope.diff);
    };

    $scope.now = function() {
        return new Date().getTime();
    };

    $scope.doFind = function() {
        $.ajax({ url : '/locations/find.json', data : this.location })
            .done( function(response) {
                    if(!response) return;
                    if(response.length == 0) return;
                    var result = response[0];
                    var point = 'POINT(' + result['lon'] + ' ' + result['lat'] + ')';
                    sharedService.setMessage('location-changed', point);
                })
            .always( function() {
                $scope.lastUpdated = $scope.now();
                $scope.running = false;
            });
        this.running = true;
        this.lastLocationSent = angular.copy(this.location,{});
    };

    /**
     *
     * @returns {Number} flags 0, 1 or 3
     * 0 = does nothing. There is no input for geolocation or request is running.
     * 1 = there is input for geolocation (which needs to be located) but the time gap hasn't been reached
     * 3 = there is input for geolocation (which needs to be located) and the time gap has been reached. Geocode!
     */
    $scope.getPerformFindFlag = function() {
        if(this.running) return 0;
        var flag = this.isInputGiven() ? 1 : 0;
        var now = this.now();
        var diff = now-this.lastUpdated;
        if( diff >= this.diff) {
            flag |= 2;
        }
        return flag;
    };

    $scope.isInputGiven = function() {
        if( angular.equals(this.location, this.lastLocationSent)) {
            return false;
        }
        var bSuff = false;
        $.each( this.location, function(key,val) {
            if( bSuff ) return;
            switch(key) {
                case 'street':
                    bSuff = val.length > 3;
                    break;
                case 'zip':
                    bSuff = val.length > 1;
                    break;
                case 'city':
                    bSuff = val.length > 1;
                    break;
                case 'country':
                    bSuff = val.length > 0;
            }
        });
        return bSuff;
    };
}]);