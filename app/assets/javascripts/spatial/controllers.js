'use strict';

/* Controllers */

function LayerListCtrl($scope, Layer, sharedService) {
    $scope.layers = Layer.query();
    $scope.myBaseLayer = 'Bing Maps Road';

    $scope.filterBase = function(layer) {
        return (layer.type == 'base');
    };

    $scope.filterWFS = function(layer) {
        return (layer.type == 'wfs');
    };

    $scope.$watch('myBaseLayer', function(newValue, oldValue) {
        sharedService.setMessage('base-layer-changed', newValue);
    },true);

    $scope.init = function() {
        sharedService.setMessage('layers-loaded', $scope.layers);
    };
};


function CesiumMapCtrl($scope, $element, $attrs, sharedService) {

    $scope.baseLayers = {};
    $scope.proxy =  {
        getURL : function(url) {
            return '/proxy?url=' + encodeURIComponent(url);
        }
    };
    $scope.ellipsoid = Cesium.Ellipsoid.WGS84;

    $scope.layerFactoryCfg = {
        'Bing Maps Aerial' : function() {
            return new Cesium.BingMapsImageryProvider({
                url: 'http://dev.virtualearth.net',
                mapStyle: Cesium.BingMapsStyle.AERIAL_WITH_LABELS//,
                //proxy: $scope.proxy
            });
        },
        'Bing Maps Road' : function() {
            return new Cesium.BingMapsImageryProvider({
                url: 'http://dev.virtualearth.net',
                mapStyle: Cesium.BingMapsStyle.ROAD//,
                //proxy: $scope.proxy
            });
        },
        'ArcGIS World Street Maps' : function() {
            return new Cesium.ArcGisMapServerImageryProvider({
                url : 'http://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer'//,
                //proxy: $scope.proxy
            });
        },
        'OpenStreetMaps' : function() {
            return new Cesium.OpenStreetMapImageryProvider({
                //proxy: $scope.proxy
            });
        },
        'MapQuest OpenStreetMaps' : function() {
            return new Cesium.OpenStreetMapImageryProvider({
                url: 'http://otile1.mqcdn.com/tiles/1.0.0/osm/'//,
                //proxy: $scope.proxy
            });
        },
        'Stamen Maps' : function() {
            return new Cesium.OpenStreetMapImageryProvider({
                url: 'http://tile.stamen.com/watercolor/',
                fileExtension: 'jpg',
                //proxy: $scope.proxy,
                credit: 'Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under CC BY SA.'
            });
        },
        'Natural Earth II (local)' : function() {
            return new Cesium.TileMapServiceImageryProvider({
                url : '/assets/Cesium/Assets/Textures/NaturalEarthII',
                fileExtension: 'jpg'
            });
        },
        'wfs' : function(url,marker) {
            var dataSource = new Cesium.GeoJsonDataSource();
            var defaultPoint = dataSource.defaultPoint;
            //defaultPoint.point = undefined;
            var billboard = new Cesium.DynamicBillboard();
            billboard.image = new Cesium.ConstantProperty(marker);  //doesnt work
            defaultPoint.billboard = billboard;

            dataSource.loadUrl(url);
            return dataSource;
        }
    };

    $scope.layerAdder = {
        base : function(id) {
            var coll = $scope.getImageryColl();
            var layer = coll.get(id);

            if( typeof layer == 'undefined' ) {
                var imageryProvider = $scope.layerFactory(id);
                if (typeof imageryProvider === 'undefined') {
                    var coll = this.getImageryColl();
                    layer = coll.get(0);
                } else {
                    layer = new Cesium.ImageryLayer(imageryProvider);
                }
                layer.name = name;
                $scope.baseLayers[name] = layer;
            }

            var lastLayer = coll.get(0);
            coll.remove( lastLayer, false );
            coll.add( layer );
        },
        wfs : function(id,url,marker) {
            var dataSource = $scope.layerFactory('wfs',url,marker);   //there is unified handling for all wfs layers
            var dataSources = $scope.viewer.dataSources;
            dataSources.add(dataSource);
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
        $scope.viewer = new Cesium.Viewer($element.attr('id'), {
            //Start in Columbus Viewer
            //Note: this will show the layer picker!
            sceneMode : Cesium.SceneMode.SCENE3D,
            baseLayerPicker : false
        });

        this.viewer.extend(Cesium.viewerDragDropMixin);
        this.viewer.extend(Cesium.viewerDynamicObjectMixin);
    };

    $scope.addLayer = function(type,id) {
        $scope.layerAdder[type].call(this,id);
    };

    $scope.toggleLayer = function(type,obj) {
        var id = obj['id'], url = obj['url'], marker = obj['marker'];
        url = '/proxy?url=' + encodeURIComponent(url);
        $scope.layerAdder[type].call(this,id,url,marker);
    };

    $scope.getImageryColl = function() {
        return this.viewer.cesiumWidget.centralBody.getImageryLayers();
    };

    $scope.fly = function() {
        var scene = this.viewer.scene;
        var destination = Cesium.Cartographic.fromDegrees(lon, lat, 15000.0);

        //hack:
        scene.camera = scene.getCamera();

        var flight = Cesium.CameraFlightPath.createAnimationCartographic(scene, {
            destination : destination
        });
        scene.getAnimations().add(flight);
    };

    $scope.flyToOwnLoc = function() {
        function fly(pos) {
            var dest = Cesium.Cartographic.fromDegrees(pos.coords.longitude, pos.coords.latitude, 1000.0);
            dest = $scope.ellipsoid.cartographicToCartesian(dest);

            var scene = $scope.viewer.scene;
            //hack, otherwise : "Cannot read property 'frustum' of undefined "
            scene.camera = scene.getCamera();

            var flight = Cesium.CameraFlightPath.createAnimation(scene, {
                destination : dest
            });

            scene.getAnimations().add(flight);
        }
        navigator.geolocation.getCurrentPosition(fly);
    };

    $scope.pickBillboard = function() {
        // If the mouse is over the billboard, change its scale and color
        var scene = this.viewer.scene;
        var handler = new Cesium.ScreenSpaceEventHandler(scene.getCanvas());
        handler.setInputAction(
            $.proxy(function (evt) {
                var pickedObject = scene.pick(evt.position);
                if(pickedObject && pickedObject.dynamicObject && pickedObject.dynamicObject.geoJson) {
                    var props = pickedObject.dynamicObject.geoJson.properties;
                    var str = '';
                    for( var name in props ) {
                        str += ' ' + props[name];
                    }
                    console.log(str);
                    console.log(unescape(str));
                    console.log(escape(str));

                    var pos = pickedObject.dynamicObject.geoJson.geometry.coordinates;
                    var lon = pos[0], lat = pos[1];

                    var labels = new Cesium.LabelCollection();
                    labels.add({
                        position  : this.ellipsoid.cartographicToCartesian(Cesium.Cartographic.fromDegrees(lon,lat)),
                        text      : str,
                        font      : '24px Helvetica',
                        fillColor : { red : 0.0, blue : 1.0, green : 1.0, alpha : 1.0 },
                        outlineColor : { red : 0.0, blue : 0.0, green : 0.0, alpha : 1.0 },
                        outlineWidth : 2,
                        style : Cesium.LabelStyle.FILL_AND_OUTLINE
                    });
                    scene.getPrimitives().add(labels);
                }
            }, this),
            Cesium.ScreenSpaceEventType.LEFT_CLICK
        );
    };

    $scope.$on('handleBroadcast', function(evt,msg,obj) {
        switch(msg) {
            case 'base-layer-changed':
                $scope.addLayer('base',obj);
                break;
            case 'wfs-layer-toggled':
                $scope.toggleLayer('wfs',obj);
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
};


function ToolsCtrl($scope, sharedService) {
    $scope.tools = [ { id : 'zoom', label : 'Zoom', icon : 'icon-zoom-in'},
                     { id : 'pick', label : 'Pick', icon : 'icon-map-marker'},
                     { id : 'extent', label : 'Draw Extent', icon : 'icon-retweet'} ];

    $scope.toolPicked = function() {
        var self = this;
        $scope.tools.forEach( function(tool) {
            tool.active = (self.tool == tool) ? 'active' : 'inactive';
            if( tool.active === 'active' ) {
                sharedService.setMessage('tool-changed', tool);
            }
        });
    }
};