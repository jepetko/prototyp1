mapApp.controller('OLMapCtrl', ['$scope', '$element', '$attrs', 'sharedService', function($scope, $element, $attrs, sharedService) {
    $scope.proxy =  {
        getURL : function(url) {
            return '/proxy?url=' + encodeURIComponent(url);
        }
    };

    $scope.map = null;

    $scope.layerAdder = {
        base : function(id) {
            //todo
            console.log(id);
        },
        wfs : function(id,url,marker,toggled) {
            //todo
            console.log(id);
        }
    }

    $scope.layerFactory = function() {
        var id = arguments[0], params = Array.prototype.slice.call(arguments,1);

        var f = this.layerFactoryCfg[id];
        if( typeof f == 'function') {
            return f.apply(this,params);
        }
        return f;
    };

    $scope.init = function() {
        $scope.map = new OpenLayers.Map($element.attr('id'));
    };

    $scope.addLayer = function(type,id) {
        $scope.layerAdder[type].call(this,id);
    };

    $scope.toggleLayer = function(type,layer,toggled) {
        var id = layer['id'], url = layer['url'], marker = layer['marker'];
        url = '/proxy?url=' + encodeURIComponent(url);
        $scope.layerAdder[type].call(this,id,url,marker,toggled);
    };

    $scope.$on('handleBroadcast', function(evt,msg,obj) {
        switch(msg) {
            case 'base-layer-changed':
                $scope.addLayer('base',obj);
                break;
            case 'wfs-layer-toggled':
                var toggled = obj['toggled'], layer = obj['layer'];
                $scope.toggleLayer('wfs',layer, toggled);
                break;
            case 'tool-changed':
                if( obj.id == 'zoom') {
                    $scope.flyToOwnLoc();
                } else
                if( obj.id == 'pick' ) {
                    $scope.pickBillboard();
                }
                break;
        }
    });
}]);