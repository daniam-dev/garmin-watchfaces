import Toybox.ActivityMonitor;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Weather;

class PilotData {
    var battery as Numeric?;
    var temperature as Numeric?;
    var condition as Number?;
    var steps as Number?;
    var goal as Number?;
    var month as String = "--";
    var day as String = "--";
    function initialize() {}
}

class PilotProviders {
    function initialize() {}
    function refresh(data as PilotData) as Void {
        var date = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        data.month = PilotFormat.MONTHS[(date.month as Number) - 1];
        data.day = date.day.format("%d");
        var activity = ActivityMonitor.getInfo();
        data.steps = activity.steps;
        data.goal = activity.stepGoal;
        if (data.steps != null && data.steps < 0) { data.steps = null; }
        data.temperature = null;
        data.condition = null;
        var weather = Weather.getCurrentConditions();
        if (weather != null) {
            data.temperature = weather.temperature;
            data.condition = weather.condition;
        }
        data.battery = PilotFormat.percent(System.getSystemStats().battery);
    }
}
