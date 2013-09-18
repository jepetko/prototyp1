mapApp.controller('OLMapCtrl', ['$scope', '$element', '$attrs', 'sharedService', function($scope, $element, $attrs, sharedService) {
    $scope.proxy =  {
        getURL : function(url) {
            return '/proxy?url=' + encodeURIComponent(url);
        }
    };

    /* projection is webmercator */
    $scope.projection = {
        projection: new OpenLayers.Projection("EPSG:102113"),
        units: "m",
        numZoomLevels: 18,
        maxResolution: 156543.0339,
        maxExtent: new OpenLayers.Bounds(   -20037508, -20037508,
            20037508, 20037508.34)
    };

    $scope.map = null;

    $scope.DRAW_EXTENT_LAYER_NAME = 'drawExtent';

    $scope.drawExtentHandlers = {
        /**
         * remove all rectangles from the layer when the control is deactivated
         */
        'deactivate' : function() {
            this.layer.destroyFeatures();
        }
    };

    $scope.selectFeatureHandlers = {
        /**
         * remove all bubbles (popups) from the map AND also unselect all features from the layer when
         * the layer is deactivated
         */
        'deactivate' : function() {
            while( $scope.map.popups.length > 0 ) {
                $scope.map.removePopup($scope.map.popups[0]);
            }
            this.unselectAll();
        }
    };

    $scope.wfsEventHandlers = {
        'featureselected': function (evt) {
            var feature = evt.feature;

            var info = '';
            for(var name in feature.attributes) {
                var value = feature.attributes[name];
                info += name + ': ' + value + '<br>';
            }

            // create own class which is autoSized per default and
            // defines a specific css class
            var clazz = OpenLayers.Class( OpenLayers.Popup.Anchored, {'autoSize': true});
            clazz.prototype.calculateRelativePosition = function(px) {
                var lonlat = this.map.getLonLatFromLayerPx(px);

                var extent = this.map.getExtent();
                var quadrant = extent.determineQuadrant(lonlat);

                var str = OpenLayers.Bounds.oppositeQuadrant(quadrant);

                //custom code
                var popover = $(this.div).find('.popover');
                popover.addClass('map-bubble-' + str);

                return str;
            };

            var content =   '<div class="map-bubble-root">\
                            <div class="popover fade in" style="display: block;">\
                            <h3 class="popover-title">Info</h3>\
                            <div class="popover-content">';
            content += info;
            content += '</div></div></div>';

            var popup = new clazz("popup",
                OpenLayers.LonLat.fromString(feature.geometry.toShortString()),
                new OpenLayers.Size(400,200), //note: this will be affected by autoSize = true
                content,
                { size : new OpenLayers.Size(0,0), offset : new OpenLayers.Pixel(0,0) },
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
            } else {
                olLayer = olLayer[0];
            }
            olLayer.setVisibility(toggled);
        }
    };

    $scope.toolAdder = {
        'selectFeature' : function() {
            var olLayers = $scope.map.getLayersBy('CLASS_NAME', 'OpenLayers.Layer.Vector');

            console.log('layers selected for selectFeatre:');
            console.log(olLayers);

            $.each(olLayers, function($idx,olLayer) {

                if( $scope.isDrawLayer(olLayer)) return;

                var controls = $scope.getToolsBy('layer', olLayer);

                console.log('controls: ');
                console.log( controls );

                if( controls.length == 0 ) {
                    var control = new OpenLayers.Control.SelectFeature(olLayer,{
                        autoActivate: true,
                        eventListeners : $scope.selectFeatureHandlers
                    });
                    $scope.map.addControl(control);
                } else {
                    $.each(controls, function(idx,control) {
                        control.activate();
                    });
                }
            });
        },
        'drawExtent' : function() {
            var name = $scope.DRAW_EXTENT_LAYER_NAME;
            var olLayer = $scope.map.getLayersByName(name);

            console.log('layers selected for drawExtent');
            console.log(olLayer);

            if( olLayer.length == 0 ) {
                olLayer = new OpenLayers.Layer.Vector(name);
                olLayer.preFeatureInsert = function() {
                    this.destroyFeatures();
                };
                $scope.map.addLayer(olLayer);
            } else {
                olLayer = olLayer[0];
            }

            var controls = $scope.getToolsBy('layer', olLayer);

            console.log('controls: ');
            console.log( controls );

            if( controls.length == 0) {
                var control = new OpenLayers.Control.DrawFeature(olLayer,
                    OpenLayers.Handler.RegularPolygon,
                    { handlerOptions: {sides:4, irregular: true},
                      autoActivate: true,
                      eventListeners : $scope.drawExtentHandlers
                    });
                $scope.map.addControl(control);
            } else {
                $.each(controls, function(idx,control) {
                    control.activate();
                });
            }
        }
    };

    $scope.init = function() {
        $scope.map = new OpenLayers.Map($element.attr('id'),this.options);
    };

    $scope.addLayer = function(type,layer) {
        var adder = $scope.layerAdder[type];
        if(!adder) return;
        adder.call(this,layer);
    };

    $scope.toggleLayer = function(type,layer,toggled) {
        var adder = $scope.layerAdder[type];
        if(!adder) return;
        adder.call(this,layer,toggled);
    };

    $scope.changeTool = function(tool) {
        $scope.deactivateTools();
        if( tool ) {
            var adder = $scope.toolAdder[tool.type];
            if(!adder) return;
            adder.call(this,tool);
        }
    };

    $scope.deactivateTools = function() {
        var arr = ['SelectFeature', 'DrawFeature'];
        var controls = $scope.map.controls;
        $.each(controls, function(idx,control) {
            var pos = control.CLASS_NAME.lastIndexOf('.');
            var subClazzName = control.CLASS_NAME.substr(pos+1);
            if($.inArray(subClazzName, arr) != -1 ) {
                control.deactivate();
            }
        });
    };

    $scope.getToolsBy = function(propertyName, value) {
        var controls = $scope.map.controls;
        var result = [];
        $.each(controls, function(idx,control) {
            if( control[propertyName] === value) {
                result.push(control);
            }
        });
        return result;
    };

    $scope.isDrawLayer = function(olLayer) {
        return $.inArray( olLayer.name, [$scope.DRAW_EXTENT_LAYER_NAME] ) != -1;
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
                $scope.changeTool(obj);
                break;
        }
    });
}]);