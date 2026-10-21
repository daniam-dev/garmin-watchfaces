import Toybox.Complications;
import Toybox.Lang;
import Toybox.WatchUi;

module StrideTargets {
    function at(x as Number, y as Number) as Complications.Type? {
        var dx = x-195; var dy = y-195;
        if (dx*dx+dy*dy > 195*195) { return null; }
        if (y >= 16 && y <= 51 && x >= 142 && x <= 249) { return Complications.COMPLICATION_TYPE_BATTERY; }
        if (y >= 57 && y <= 92 && x >= 102 && x <= 288) { return Complications.COMPLICATION_TYPE_DATE; }
        if (y >= 235 && y <= 310 && x >= 50 && x < 146) { return Complications.COMPLICATION_TYPE_STEPS; }
        if (y >= 235 && y <= 310 && x >= 146 && x < 244) { return Complications.COMPLICATION_TYPE_BODY_BATTERY; }
        if (y >= 235 && y <= 310 && x >= 244 && x <= 340) { return Complications.COMPLICATION_TYPE_HEART_RATE; }
        if (y >= 315 && y <= 355 && x >= 100 && x <= 290) { return Complications.COMPLICATION_TYPE_CURRENT_WEATHER; }
        if (y >= 60 && y <= 350 && dx*dx+dy*dy >= 178*178) {
            return x < 195 ? Complications.COMPLICATION_TYPE_STEPS : Complications.COMPLICATION_TYPE_BODY_BATTERY;
        }
        return null;
    }
}

class StrideDelegate extends WatchUi.WatchFaceDelegate {
    function initialize() { WatchFaceDelegate.initialize(); }
    function onPress(event as WatchUi.ClickEvent) as Boolean {
        var p = event.getCoordinates();
        var target = StrideTargets.at(p[0],p[1]);
        if (target == null) { return false; }
        try { Complications.exitTo(new Complications.Id(target)); }
        catch (error instanceof Lang.InvalidValueException) { return false; }
        return true;
    }
}
