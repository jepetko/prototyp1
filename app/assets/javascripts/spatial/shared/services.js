'use strict';

/* for communication among the controllers; independent from the particular application */
angular.module('globalBroadcastServices', []).service('sharedService', function($rootScope, $window) {
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


var httpServices = angular.module('httpServices', ['ngResource']);
httpServices.factory('Layer', function($resource){
    return $resource('/layers.json?type=:type', {type:'@type'}, {
        query: {method:'GET', params:{type: '@type'}, isArray:true}
    });
});
httpServices.factory('Tool', function($resource) {
    return $resource('/tools.json?group=:group', {group:'@group'}, {
        query: {method:'GET', params:{group: '@group'}, isArray:true}
    });
});
httpServices.factory('QueryResult', function($resource) {
    return $resource('/customers.json?geom=:geom', {geom:'@geom'}, {
        query: {method:'GET', params:{geom: '@geom'}, isArray:true}
    });
});