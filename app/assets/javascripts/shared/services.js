'use strict';

/* Services */

/* for communication among the controllers; independent from the particular application */
angular.module('test-service', []).service('sharedService', function($rootScope, $window) {
    $window.rootScopes = $window.rootScopes || [];
    $window.rootScopes.push($rootScope);

    var sharedService = {
        setMessage : function() {
            this.sendBroadcast.apply(this,arguments);
        },
        sendBroadcast : function() {
            var args = Array.prototype.concat.apply(['handleBroadcast'],arguments);
            for( var i=0; i<$window.rootScopes.length; i++) {
                var rs = $window.rootScopes[i];
                rs.$broadcast.apply(rs,args);
            }
        }
    }
    return sharedService;
});