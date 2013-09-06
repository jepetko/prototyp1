// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require angularjs/angular
//= require angularjs/angular-resource
//= require Cesium/Cesium
//= require spatial/app
//= require spatial/controllers
//= require shared/services

angular.bootstrap($('#layer-app'),['httpServices', 'layerAppDirectives', 'test-service']);
angular.bootstrap($('#map-app'),['test-service']);
angular.bootstrap($('#tools-app'),['test-service']);

/*
var cesiumModule = function() {

    function CesiumDemo() {

        this.viewer = null;

        this.init = function() {

//Initialize the viewer widget with several custom options and mixins.
            this.viewer = new Cesium.Viewer('cesiumContainer', {
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

//Add basic drag and drop functionality
            this.viewer.extend(Cesium.viewerDragDropMixin);

//Allow users to zoom and follow objects loaded from CZML by clicking on it.
            this.viewer.extend(Cesium.viewerDynamicObjectMixin);

//Show a pop-up alert if we encounter an error when processing a dropped file
            this.viewer.onDropError.addEventListener(function(dropHandler, name, error) {
                console.log(error);
                window.alert(error);
            });

            var widget = this.viewer.cesiumWidget;
            var layers = widget.centralBody.getImageryLayers();

            var provider = new Cesium.WebMapServiceImageryProvider({
                url : 'http://data.wien.gv.at/daten/wms',
                layers : 'HUNDEZONEOGD',
                credit : 'Infrared data courtesy Iowa Environmental Mesonet',
                parameters : {
                    transparent : 'TRUE',
                    format : 'image/png'
                },
                proxy : {
                    getURL : function(url) {
                        return '/proxy?url=' + encodeURIComponent(url);
                    }
                }
            });

            //layers.addImageryProvider(provider);
            this.postInit();
        };

        this.postInit = function() {
            var btn = $('#vienna');
            btn.on('click', (function(self) {
                return function() {
                    self.flyTo(16.38006, 48.220685);
                }
            })(this));

            var btn0 = $('#museum');
            btn0.on('click', (function(self) {
                return function() {
                    self.addFromWFS('/proxy?url=' + encodeURIComponent('http://data.wien.gv.at/daten/wfs?service=WFS&request=GetFeature&version=1.1.0&typeName=ogdwien:MUSEUMOGD&srsName=EPSG:4326&outputFormat=json') );
                }
            })(this));

            var btn1 = $('#draw_extent');
            btn1.on('click', (function(self) {

                var scene = this.viewer.scene;

                var myHandler = function(e) {
                    var labels = new Cesium.LabelCollection();
                    label = labels.add();
                    scene.getPrimitives().add(labels);

                    label.setShow(true);
                    label.setText('(' +
                        Cesium.Math.toDegrees(e.west).toFixed(2) + ', ' +
                        Cesium.Math.toDegrees(e.south).toFixed(2) + ', ' +
                        Cesium.Math.toDegrees(e.east).toFixed(2) + ', ' +
                        Cesium.Math.toDegrees(e.north).toFixed(2) + ')');
                    label.setScale(0.7);
                    label.setPosition(widget.centralBody.getEllipsoid().cartographicToCartesian(e.getCenter()));
                    label.setHorizontalOrigin( Cesium.HorizontalOrigin.CENTER );
                };

                var drawExtentHelper = new DrawExtentHelper(scene, myHandler);
                drawExtentHelper.start();
            })(this));

            var widget = this.viewer.cesiumWidget;
            var canvas = this.viewer.scene.getCanvas();
            var handler = new Cesium.ScreenSpaceEventHandler(canvas);
            var flags = {
                looking : false,
                moveForward : false,
                moveBackward : false,
                moveUp : false,
                moveDown : false,
                moveLeft : false,
                moveRight : false
            };

            handler.setInputAction(function(movement) {
                flags.looking = true;
                mousePosition = startMousePosition = Cesium.Cartesian3.clone(movement.position);
                console.log('down:');
                console.log(mousePosition);
            }, Cesium.ScreenSpaceEventType.LEFT_DOWN);

            handler.setInputAction(function(movement) {
                mousePosition = movement.endPosition;
            }, Cesium.ScreenSpaceEventType.MOUSE_MOVE);

            handler.setInputAction(function(position) {
                flags.looking = false;
                console.log('up:');
                console.log(position);
            }, Cesium.ScreenSpaceEventType.LEFT_UP);
        };

        this.setExtent = function(extent) {
            var west = Cesium.Math.toRadians(extent.minx);
            var south = Cesium.Math.toRadians(extent.miny);
            var east = Cesium.Math.toRadians(extent.maxx);
            var north = Cesium.Math.toRadians(extent.maxy);
            var extent = new Cesium.Extent(west, south, east, north);

            var scene = this.widget.scene;
            var camera = scene.getCamera();

            camera.controller.viewExtent(extent, Cesium.Ellipsoid.WGS84);
        };

        this.getLonLat = function(mousePos) {
            var scene = this.viewer.scene;
            var camera = scene.getCamera();
            var ray = camera.controller.getPickRay(mousePos);
            var intersection = Cesium.IntersectionTests.rayEllipsoid(ray, Cesium.Ellipsoid.WGS84);
            console.log(intersection);
        };

        this.reset = function() {
            var ellipsoid = Cesium.Ellipsoid.WGS84;
            var scene = this.widget.scene;
            console.log(scene);

            scene.getPrimitives().removeAll();
            scene.getAnimations().removeAll();

            var camera = scene.getCamera();
            console.log( camera );

            camera.transform = Cesium.Matrix4.IDENTITY;
            camera.controller.constrainedAxis = undefined;
            camera.controller.lookAt(
                new Cesium.Cartesian3(0.0, -2.0, 1.0).normalize().multiplyByScalar(2.0 * ellipsoid.getMaximumRadius()),
                Cesium.Cartesian3.ZERO,
                Cesium.Cartesian3.UNIT_Z);

            var controller = scene.getScreenSpaceCameraController();
            controller.setEllipsoid(ellipsoid);
            controller.enableTilt = true;
        };

        this.flyTo = function(lon,lat) {
            //this.reset();
            var widget = this.viewer.cesiumWidget;
            console.log( widget );
            var scene = this.viewer.scene;
            var destination = Cesium.Cartographic.fromDegrees(lon, lat, 15000.0);

            //hack:
            scene.camera = scene.getCamera();

            var flight = Cesium.CameraFlightPath.createAnimationCartographic(scene, {
                destination : destination
            });
            scene.getAnimations().add(flight);
        };

        this.addFromWFS = function(url) {
            var dataSource = new Cesium.GeoJsonDataSource();
            var defaultPoint = dataSource.defaultPoint;
            defaultPoint.point = undefined;
            var billboard = new Cesium.DynamicBillboard();
            billboard.image = new Cesium.ConstantProperty('/assets/marker.png');
            defaultPoint.billboard = billboard;
            dataSource.loadUrl(url);
            var dataSources = this.viewer.dataSources;
            dataSources.add(dataSource);
        };

        this.destroy = function() {
            //TODO: unregister event handlers?
            this.widget = null;
        };

        this.init();
    };
    return new CesiumDemo();
};

$( function() {
    var module = cesiumModule();
    window.myCesium = module;

    //$('#layertree').layers();
});
      */
/*
function analyze(obj, dataType) {
    console.log('starting analysis on');
    console.log(obj);
    for( var a in obj)  {
        if( typeof obj[a] == 'function' ) continue;
        if( typeof obj[a] == 'undefined' ) continue;
        if( typeof obj[a] == 'string' ) continue;
        console.log( 'a:' + a );
        if(  obj[a] instanceof dataType ) {
            console.warn('FOUND!');
            console.warn(dataType);
            return;
        } else {
            console.warn('going deeper');
            analyze(obj[a], dataType);
        }
    }
}  */