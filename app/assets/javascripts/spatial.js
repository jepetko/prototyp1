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
//= require Cesium/Cesium
//= require jquery-ui/jquery-ui-1.10.3.custom
//= require spatial/layers

var cesiumModule = function() {

    function CesiumDemo() {

        this.widget = null;

        this.init = function() {
            this.widget = new Cesium.CesiumWidget('cesiumContainer');
            var layers = this.widget.centralBody.getImageryLayers();

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

            layers.addImageryProvider(provider);
            this.postInit();
        };

        this.postInit = function() {
            var btn = $('#vienna');
            btn.on('click', (function(self) {
                return function() {
                    self.flyTo(16.38006, 48.220685);
                }
            })(this));

            var canvas = this.widget.scene.getCanvas();
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

        this.loadWFS = function(url) {
            $.ajax(url, function() {

            }).done(function ( data ) {
                    if( console && console.log ) {
                        console.log("Sample of data:", data.slice(0, 100));
                    }
                });
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
            var scene = this.widget.scene;
            var camer = scene.getCamera();
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
            var scene = this.widget.scene;
            var destination = Cesium.Cartographic.fromDegrees(lon, lat, 15000.0);

            //hack:
            scene.camera = scene.getCamera();

            var flight = Cesium.CameraFlightPath.createAnimationCartographic(scene, {
                destination : destination
            });
            scene.getAnimations().add(flight);
        };

        this.destroy = function() {

        }

        this.init();
    };
    return new CesiumDemo();
};

$( function() {
    //var module = cesiumModule();

    $('#layertree').layers();
});