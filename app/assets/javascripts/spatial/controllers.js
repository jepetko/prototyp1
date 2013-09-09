'use strict';

/* Controllers */

function LayerListCtrl($scope, Layer, sharedService) {
    $scope.layers = Layer.query();
    $scope.myBaseLayer = 'Bing Maps Road';
    $scope.countRendered = 0;

    $scope.filterBase = function(layer) {
        return (layer.type == 'base');
    };

    $scope.filterWFS = function(layer) {
        return (layer.type == 'wfs');
    };

    $scope.$watch('myBaseLayer', function() {
        console.log('base layer changed!!!');
    });

    $scope.init = function() {
        console.log('init');
        console.log('layers loaded');
        console.log( $scope.layers);
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
        }
    };

    $scope.layerFactory = function(id) {
        var f = this.layerFactoryCfg[id];
        if( typeof f == 'function') {
            return f();
        }
        return f;
    };

    $scope.init = function() {
        $scope.viewer = new Cesium.Viewer($element.attr('id'), {
            //Start in Columbus Viewer
            //Note: this will show the layer picker!
            sceneMode : Cesium.SceneMode.SCENE3D,
            baseLayerPicker : false /*,
            //Use standard Cesium terrain
            terrainProvider : new Cesium.CesiumTerrainProvider({
                url : 'http://cesium.agi.com/smallterrain',
                credit : 'Terrain data courtesy Analytical Graphics, Inc.'
            }),
            //Hide the base layer picker
            baseLayerPicker : false,
            //Use OpenStreetMaps
            imageryProvider : new Cesium.OpenStreetMapImageryProvider({
                url : 'http://tile.openstreetmap.org/'
            }) */
        });

        this.viewer.extend(Cesium.viewerDragDropMixin);
        this.viewer.extend(Cesium.viewerDynamicObjectMixin);
    };

    $scope.addLayer = function(id) {

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


    $scope.$on('handleBroadcast', function(evt,msg,obj) {
        console.log(evt);
        console.log(msg);
        console.log(obj);
        switch(msg) {
            case 'base-layer-changed':
                $scope.addLayer(obj);
                break;
            case 'tool-changed':
                if( obj.id == 'zoom') {
                    $scope.flyToOwnLoc();
                }
                break;
        }
    });
};


function ToolsCtrl($scope, sharedService) {
    $scope.tools = [ { id : 'zoom', label : 'Zoom'},
                     { id : 'pick', label : 'Pick'},
                     { id : 'extent', label : 'Draw Extent'} ];

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