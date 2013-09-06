'use strict';

/* Controllers */

function LayerListCtrl($scope, Layer, sharedService) {
    $scope.layers = Layer.query();
    $scope.myLayer = 'Bing Maps Road';

    $scope.baseLayerActivityChanged = function() {
        sharedService.setMessage('base-layer-changed', $scope.myLayer ); //this variable is defined in ng-model
    };

    $scope.init = function() {
        console.log('init');
        console.log('layers loaded');
        console.log( $scope.layers);
        sharedService.setMessage('layers-loaded', $scope.layers);
    };

    $scope.moveUp = function() {

    };

    $scope.moveDown = function() {

    };
};


function CesiumMapCtrl($scope, $element, $attrs, sharedService) {

    $scope.baseLayers = {};
    $scope.proxy =  {
        getURL : function(url) {
            return '/proxy?url=' + encodeURIComponent(url);
        }
    };

    $scope.layerFactoryCfg = {
        'Bing Maps Aerial' : function() {
            return new Cesium.BingMapsImageryProvider({
                url: 'http://dev.virtualearth.net',
                mapStyle: Cesium.BingMapsStyle.AERIAL_WITH_LABELS,
                proxy: $scope.proxy
            });
        },
        'Bing Maps Road' : function() {
            return new Cesium.BingMapsImageryProvider({
                url: 'http://dev.virtualearth.net',
                mapStyle: Cesium.BingMapsStyle.ROAD,
                proxy: $scope.proxy
            });
        },
        'ArcGIS World Street Maps' : function() {
            return new Cesium.ArcGisMapServerImageryProvider({
                url : 'http://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer',
                proxy: $scope.proxy
            });
        },
        'OpenStreetMaps' : function() {
            return new Cesium.OpenStreetMapImageryProvider({
                proxy: $scope.proxy
            });
        },
        'MapQuest OpenStreetMaps' : function() {
            return new Cesium.OpenStreetMapImageryProvider({
                url: 'http://otile1.mqcdn.com/tiles/1.0.0/osm/',
                proxy: $scope.proxy
            });
        },
        'Stamen Maps' : function() {
            return new Cesium.OpenStreetMapImageryProvider({
                url: 'http://tile.stamen.com/watercolor/',
                fileExtension: 'jpg',
                proxy: $scope.proxy,
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
            sceneMode : Cesium.SceneMode.COLUMBUS_VIEW,
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
            })
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


    $scope.$on('handleBroadcast', function(evt,msg,obj) {
        console.log(evt);
        console.log(msg);
        console.log(obj);
        switch(msg) {
            case 'base-layer-changed':
                $scope.addLayer(obj);
                break;
        }
    });
};