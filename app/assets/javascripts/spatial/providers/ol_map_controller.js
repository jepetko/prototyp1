mapApp.controller('OLMapCtrl', ['$scope', '$element', '$attrs', 'sharedService', function($scope, $element, $attrs, sharedService) {
    $scope.proxy =  {
        getURL : function(url) {
            return '/proxy?url=' + encodeURIComponent(url);
        }
    };

    $scope.projection = {
        projection: new OpenLayers.Projection("EPSG:102113"),
        units: "m",
        numZoomLevels: 18,
        maxResolution: 156543.0339,
        maxExtent: new OpenLayers.Bounds(   -20037508, -20037508,
            20037508, 20037508.34)
    };

    $scope.map = null;

    $scope.layerAdder = {
        base : function(layer) {
            var name = layer.name;
            var olLayer = $scope.map.getLayersByName(name);
            if( olLayer.length === 0 ) {
                var clazz = window['OpenLayers']['Layer'][layer.clazz];
                if( !clazz ) {
                    return; //TODO: throw Exception?
                }
                olLayer = new clazz( { name : name, type : layer.clazz_type, key : layer.key } )
                $scope.map.addLayer(olLayer);
            } else {
                olLayer = olLayer[0];
            }
            $scope.map.setBaseLayer(olLayer);
            olLayer.setVisibility(true);
        },
        wfs : function(layer) {

            var name = layer.name;
            var url = layer['url'];
            if(layer['use_proxy']) {
                url = '/proxy?url=' + encodeURIComponent(url);
            }
            var olLayer = $scope.map.getLayersByName(name);
            if( olLayer.length === 0 ) {
                var clazz = window['OpenLayers']['Layer'][layer.clazz];
                if( !clazz ) {
                    return; //TODO: throw Exception?
                }
                olLayer = new clazz(layer.name, {
                    projection: "EPSG:4326", //$scope.map.getProjection(),
                    strategies: [new OpenLayers.Strategy.Fixed()],
                    protocol: new OpenLayers.Protocol.HTTP({
                        url: url,
                        format: new OpenLayers.Format.GeoJSON()
                    })
                });
                $scope.map.addLayer(olLayer);
            } else {
                olLayer = olLayer[0];
            }
            olLayer.setVisibility(true);
        }
    };

    $scope.layerFactory = function() {
        var id = arguments[0], params = Array.prototype.slice.call(arguments,1);

        var f = this.layerFactoryCfg[id];
        if( typeof f == 'function') {
            return f.apply(this,params);
        }
        return f;
    };

    $scope.init = function() {
        $scope.map = new OpenLayers.Map($element.attr('id'),this.options);
    };

    $scope.addLayer = function(type,layer) {
        $scope.layerAdder[type].call(this,layer);
    };

    $scope.toggleLayer = function(type,layer,toggled) {
        $scope.layerAdder[type].call(this,layer,toggled);
    };

    $scope.flyToOwnLoc = function() {
        function fly(geopos) {
            var coords = geopos.coords;
            var lonLat = new OpenLayers.LonLat(coords.longitude,coords.latitude);

            var fromProjection = new OpenLayers.Projection("EPSG:4326");   // Transform from WGS 1984
            var toProjection   = $scope.map.getProjection();
            var tgtPos       = lonLat.transform( fromProjection, toProjection);

            var acc = 5;
            var lvl = $scope.map.numZoomLevels/acc*(acc-1);
            $scope.map.setCenter(tgtPos, lvl);
        }
        navigator.geolocation.getCurrentPosition(fly);
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
            case 'tool-clicked':
                if( obj.id == 'zoom') {
                    $scope.flyToOwnLoc();
                }
                break;
            case 'tool-changed':
                if( obj.id == 'pick' ) {
                } else
                if( obj.id == 'zoom') {

                }
                break;
        }
    });
}]);