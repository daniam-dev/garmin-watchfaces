import Toybox.Complications;
import Toybox.Lang;
import Toybox.WatchUi;

module StrideTargets {
    function at(x as Number, y as Number) as Complications.Type? {
        var dx = x-195; var dy = y-195;
        if (dx*dx+dy*dy > 195*195) { return null; }
        if (y >= StrideTheme.BATTERY_Y-22 && y <= StrideTheme.BATTERY_Y+21 &&
            x >= StrideTheme.BATTERY_ICON_X-14 && x <= StrideTheme.BATTERY_X+33) { return Complications.COMPLICATION_TYPE_BATTERY; }
        if (y >= StrideTheme.DATE_Y-22 && y <= StrideTheme.DATE_Y+21 &&
            x >= StrideTheme.DATE_X-63 && x <= StrideTheme.DATE_X+68) { return Complications.COMPLICATION_TYPE_DATE; }
        if (x >= StrideTheme.METRIC_HIT_LEFT && x <= StrideTheme.METRIC_HIT_RIGHT) {
            if (y >= StrideTheme.STEPS_Y+StrideTheme.METRIC_HIT_TOP && y <= StrideTheme.STEPS_Y+StrideTheme.METRIC_HIT_BOTTOM) { return Complications.COMPLICATION_TYPE_STEPS; }
            if (y >= StrideTheme.BODY_Y+StrideTheme.METRIC_HIT_TOP && y <= StrideTheme.BODY_Y+StrideTheme.METRIC_HIT_BOTTOM) { return Complications.COMPLICATION_TYPE_BODY_BATTERY; }
            if (y >= StrideTheme.HEART_Y+StrideTheme.METRIC_HIT_TOP && y <= StrideTheme.HEART_Y+StrideTheme.LABEL_OFFSET+15) { return Complications.COMPLICATION_TYPE_HEART_RATE; }
        }
        if (y >= StrideTheme.WEATHER_Y-21 && y <= StrideTheme.WEATHER_Y+22 && x >= 100 && x <= 292) { return Complications.COMPLICATION_TYPE_CURRENT_WEATHER; }
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
