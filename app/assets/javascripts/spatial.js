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

var cesiumWidget = new Cesium.CesiumWidget('cesiumContainer');
cesiumWidget.zoomTo();
var layers = cesiumWidget.centralBody.getImageryLayers();


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