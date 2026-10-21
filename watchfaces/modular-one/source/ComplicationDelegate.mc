import Toybox.Complications;
import Toybox.Lang;
import Toybox.WatchUi;

module ModularTargets {
    function circle(x as Number, y as Number, cx as Number, cy as Number, r as Number) as Boolean {
        return (x-cx)*(x-cx) + (y-cy)*(y-cy) <= r*r;
    }
    function at(x as Number, y as Number) as Complications.Type? {
        if (!circle(x,y,195,195,195)) { return null; }
        if (x >= Theme.PANEL_X && x <= Theme.PANEL_X + Theme.PANEL_WIDTH &&
            y >= Theme.PANEL_Y && y <= Theme.PANEL_Y + Theme.PANEL_HEIGHT) {
            return Complications.COMPLICATION_TYPE_BODY_BATTERY;
        }
        if (circle(x,y,Theme.LEFT_X,Theme.DIAL_Y,35) || circle(x,y,Theme.CENTER,Theme.DIAL_Y,35)) {
            return Complications.COMPLICATION_TYPE_CURRENT_WEATHER;
        }
        if (circle(x,y,Theme.RIGHT_X,Theme.DIAL_Y,35)) { return Complications.COMPLICATION_TYPE_BATTERY; }
        if (y >= 24 && y <= 72 && x >= 128 && x < 195) { return Complications.COMPLICATION_TYPE_STEPS; }
        if (y >= 24 && y <= 72 && x >= 195 && x <= 262) { return Complications.COMPLICATION_TYPE_INTENSITY_MINUTES; }
        if (y >= 74 && y <= 100 && x >= 110 && x <= 280) { return Complications.COMPLICATION_TYPE_DATE; }
        if (y >= 70 && y <= 350 && !circle(x,y,195,195,168)) {
            return x < 195 ? Complications.COMPLICATION_TYPE_STEPS : Complications.COMPLICATION_TYPE_INTENSITY_MINUTES;
        }
        return null;
    }
}

class ModularDelegate extends WatchUi.WatchFaceDelegate {
    function initialize() { WatchFaceDelegate.initialize(); }
    function onPress(event as WatchUi.ClickEvent) as Boolean {
        var p = event.getCoordinates();
        var target = ModularTargets.at(p[0],p[1]);
        if (target == null) { return false; }
        try { Complications.exitTo(new Complications.Id(target)); }
        catch (error instanceof Lang.InvalidValueException) { return false; }
        return true;
    }
}
