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

    $scope.wfsEventHandlers = {
        'featureselected': function (evt) {
            var feature = evt.feature;

            var info = '';
            for(var name in feature.attributes) {
                var value = feature.attributes[name];
                info += name + ': ' + value + '<br>';
            }

            var clazz = OpenLayers.Class( OpenLayers.Popup.Anchored, {'autoSize': true});
            clazz.prototype.calculateRelativePosition = function(px) {
                var lonlat = this.map.getLonLatFromLayerPx(px);

                var extent = this.map.getExtent();
                var quadrant = extent.determineQuadrant(lonlat);

                var str = OpenLayers.Bounds.oppositeQuadrant(quadrant);

                var popover = $(this.div).find('.popover');
                popover.addClass('map-bubble-' + str);

                return str;
            };

            var content =   '<div class="map-bubble-root">\
                            <div><div class="popover fade in" style="display: block;">\
                            <h3 class="popover-title">Popover on top</h3>\
                            <div class="popover-content">\
                            </div>';
            content += info;
            content += '</div></div>';

            var svgObj = $('#' + feature.geometry.id);
            var dim = svgObj[0].getBoundingClientRect();

            var popup = new clazz("popup",
                OpenLayers.LonLat.fromString(feature.geometry.toShortString()),
                new OpenLayers.Size(400,400), //note: this will be affected by autoSize = true
                content,
                { size : new OpenLayers.Size(0,0), offset : new OpenLayers.Pixel(5,5) },
                false
            );
            feature.popup = popup;
            $scope.map.addPopup(popup);
        },
        'featureunselected': function (evt) {
            var feature = evt.feature;
            $scope.map.removePopup(feature.popup);
            feature.popup.destroy();
            feature.popup = null;
        }
    };

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
        wfs : function(layer,toggled) {

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
                    }),
                    eventListeners : $scope.wfsEventHandlers
                });
                $scope.map.addLayer(olLayer);
                var selectFeatureControl = new OpenLayers.Control.SelectFeature(olLayer,{
                    autoActivate:true
                });
                $scope.map.addControl(selectFeatureControl);
            } else {
                olLayer = olLayer[0];
            }
            olLayer.setVisibility(toggled);
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