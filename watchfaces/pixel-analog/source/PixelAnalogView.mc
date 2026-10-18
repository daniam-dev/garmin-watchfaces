import Toybox.Graphics;
import Toybox.WatchUi;

class PixelAnalogView extends WatchUi.WatchFace {
    function initialize() {
        WatchFace.initialize();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        // Base compilable; el diseño de Pixel Analog está pendiente.
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
    }
}
