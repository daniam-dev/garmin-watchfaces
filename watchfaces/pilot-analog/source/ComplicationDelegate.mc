import Toybox.Complications;
import Toybox.Lang;
import Toybox.WatchUi;

module PilotTargets {
    function circle(x as Number, y as Number, cx as Number, cy as Number, r as Number) as Boolean {
        return (x-cx)*(x-cx) + (y-cy)*(y-cy) <= r*r;
    }
    function at(x as Number, y as Number) as Complications.Type? {
        if (!circle(x,y,195,195,195)) { return null; }
        if (circle(x,y,PilotTheme.CENTER,PilotTheme.BATTERY_Y,49)) { return Complications.COMPLICATION_TYPE_BATTERY; }
        if (circle(x,y,PilotTheme.WEATHER_X,PilotTheme.CENTER,47)) { return Complications.COMPLICATION_TYPE_CURRENT_WEATHER; }
        if (circle(x,y,PilotTheme.DATE_X,PilotTheme.CENTER,45)) { return Complications.COMPLICATION_TYPE_DATE; }
        if (circle(x,y,PilotTheme.CENTER,PilotTheme.STEPS_Y,48)) { return Complications.COMPLICATION_TYPE_STEPS; }
        return null;
    }
}

class PilotDelegate extends WatchUi.WatchFaceDelegate {
    function initialize() { WatchFaceDelegate.initialize(); }
    function onPress(event as WatchUi.ClickEvent) as Boolean {
        var p = event.getCoordinates();
        var target = PilotTargets.at(p[0],p[1]);
        if (target == null) { return false; }
        try { Complications.exitTo(new Complications.Id(target)); }
        catch (error instanceof Lang.InvalidValueException) { return false; }
        return true;
    }
}
