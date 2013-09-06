// If the mouse is over the billboard, change its scale and color
handler = new Cesium.ScreenSpaceEventHandler(scene.getCanvas());
handler.setInputAction(
    function (movement) {
        var pickedObject = scene.pick(movement.endPosition);
        if (billboard && pickedObject === billboard) {
            billboard.setScale(2.0);
            billboard.setColor({ red : 1.0, green : 1.0, blue : 0.0, alpha : 1.0 });
        }
        else if (billboard) {
            billboard.setScale(1.0);
            billboard.setColor({ red : 1.0, green : 1.0, blue : 1.0, alpha : 1.0 });
        }
    },
    Cesium.ScreenSpaceEventType.MOUSE_MOVE
);