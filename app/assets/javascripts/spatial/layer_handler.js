var LayerHandler = function() {

    this.imageryLayerCollection = null;
    this._baseLayers = [];
};

LayerHandler.prototype.addBaseLayer = function(name, imageryProvider) {

    var layer;
    if (typeof imageryProvider === 'undefined') {
        layer = imageryLayerCollection.get(0);
    } else {
        layer = new Cesium.ImageryLayer(imageryProvider);
    }

    layer.name = name;
    this._baseLayers.push(layer);
};

LayerHandler.prototype.addLayer = function(name, imageryProvider, alpha, show) {
    var layer = this.imageryLayerCollection.addImageryProvider(imageryProvider);
    layer.alpha = Cesium.defaultValue(alpha, 0.5);
    layer.show = Cesium.defaultValue(show, true);
    layer.name = name;
};

LayerHandler.prototype.init = function() {

    // Create all the base layers that this example will support.
    // These base layers aren't really special.  It's possible to have multiple of them
    // enabled at once, just like the other layers, but it doesn't make much sense because
    // all of these layers cover the entire globe and are opaque.
    this.addBaseLayer(
        'Bing Maps Aerial',
        undefined); // the current base layer
    this.addBaseLayer(
        'Bing Maps Road',
        new Cesium.BingMapsImageryProvider({
            url: 'http://dev.virtualearth.net',
            mapStyle: Cesium.BingMapsStyle.ROAD,
            // Some versions of Safari support WebGL, but don't correctly implement
            // cross-origin image loading, so we need to load Bing imagery using a proxy.
            proxy: Cesium.FeatureDetection.supportsCrossOriginImagery() ? undefined : new Cesium.DefaultProxy('/proxy/')
        }));
    this.addBaseLayer(
        'ArcGIS World Street Maps',
        new Cesium.ArcGisMapServerImageryProvider({
            url : 'http://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer',
            proxy: new Cesium.DefaultProxy('/proxy/')
        }));
    this.addBaseLayer(
        'OpenStreetMaps',
        new Cesium.OpenStreetMapImageryProvider({
            proxy: new Cesium.DefaultProxy('/proxy/')
        }));
    this.addBaseLayer(
        'MapQuest OpenStreetMaps',
        new Cesium.OpenStreetMapImageryProvider({
            url: 'http://otile1.mqcdn.com/tiles/1.0.0/osm/',
            proxy: new Cesium.DefaultProxy('/proxy/')
        }));
    this.addBaseLayer(
        'Stamen Maps',
        new Cesium.OpenStreetMapImageryProvider({
            url: 'http://tile.stamen.com/watercolor/',
            fileExtension: 'jpg',
            proxy: new Cesium.DefaultProxy('/proxy/'),
            credit: 'Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under CC BY SA.'
        }));
    this.addBaseLayer(
        'Natural Earth II (local)',
        new Cesium.TileMapServiceImageryProvider({
            url : require.toUrl('Assets/Textures/NaturalEarthII')
        }));

    // Create the additional layers
    this.addLayer(
        'United States GOES infrared',
        new Cesium.WebMapServiceImageryProvider({
            url : 'http://mesonet.agron.iastate.edu/cgi-bin/wms/goes/conus_ir.cgi?',
            layers : 'goes_conus_ir',
            credit : 'Infrared data courtesy Iowa Environmental Mesonet',
            parameters : {
                transparent : 'true',
                format : 'image/png'
            },
            proxy : new Cesium.DefaultProxy('/proxy/')
        }));
    this.addLayer(
        'United States weather radar',
        new Cesium.WebMapServiceImageryProvider({
            url : 'http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi?',
            layers : 'nexrad-n0r',
            credit : 'Radar data courtesy Iowa Environmental Mesonet',
            parameters : {
                transparent : 'true',
                format : 'image/png'
            },
            proxy : new Cesium.DefaultProxy('/proxy/')
        }));
    this.addLayer(
        'TMS Image',
        new Cesium.TileMapServiceImageryProvider({
            url : '../images/cesium_maptiler/Cesium_Logo_Color'
        }),
        0.2);
    this.addLayer(
        'Single image',
        new Cesium.SingleTileImageryProvider({
            url : '../images/Cesium_Logo_overlay.png',
            extent : new Cesium.Extent(
                Cesium.Math.toRadians(-115.0),
                Cesium.Math.toRadians(38.0),
                Cesium.Math.toRadians(-107),
                Cesium.Math.toRadians(39.75))
        }),
        1.0);
    this.addLayer(
        'Grid',
        new Cesium.GridImageryProvider(), 1.0, false);
    this.addLayer(
        'Tile Coordinates',
        new Cesium.TileCoordinatesImageryProvider(), 1.0, false);
};

