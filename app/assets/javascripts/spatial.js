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
                    self.flyTo(48.10,16.5);
                }
            })(this));
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

        this.flyTo = function(lat,lon) {
            //this.reset();
            var scene = this.widget.scene;
            var destination = Cesium.Cartographic.fromDegrees(16.38006, 48.220685, 15000.0);
            //var destination = Cesium.Cartographic.fromDegrees(-117.16, 32.71, 15000.0);

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
    var module = cesiumModule();
});


/*
var blackMarble = layers.addImageryProvider(new Cesium.TileMapServiceImageryProvider({
    url : 'http://cesium.agi.com/blackmarble',
    maximumLevel : 8,
    credit : 'Black Marble imagery courtesy NASA Earth Observatory'
}));
blackMarble.alpha = 0.5;
blackMarble.brightness = 2.0;
layers.addImageryProvider(new Cesium.SingleTileImageryProvider({
    url : '../images/cesium.png',
    extent : new Cesium.Extent(
        Cesium.Math.toRadians(-75.0),
        Cesium.Math.toRadians(28.0),
        Cesium.Math.toRadians(-67.0),
        Cesium.Math.toRadians(29.75))
})); */