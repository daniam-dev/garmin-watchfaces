import Toybox.ActivityMonitor;
import Toybox.Complications;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Weather;

class FaceData {
    var timeText as String = "--:--";
    var weekday as String = "--";
    var day as String = "--";
    var month as String = "--";
    var steps as Number?;
    var stepGoal as Number?;
    var intensityMinutes as Number?;
    var intensityGoal as Number?;
    var battery as Numeric?;
    var bodyBattery as Numeric?;
    var temperature as Numeric?;
    var condition as Number?;
    var precipitation as Numeric?;
    function initialize() {}
}

class ClockProvider {
    private var _dateKey as Number = -1;
    function initialize() {}
    function refresh(data as FaceData) as Void {
        var clock = System.getClockTime();
        data.timeText = Formatters.clock(clock.hour, clock.min);
        var date = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var month = date.month as Number;
        var weekday = date.day_of_week as Number;
        var key = date.year * 10000 + month * 100 + date.day;
        if (_dateKey != key) {
            _dateKey = key;
            data.weekday = Formatters.DAYS[weekday - 1];
            data.day = date.day.format("%d");
            data.month = Formatters.MONTHS[month - 1];
        }
    }
}

class ActivityProvider {
    function initialize() {}
    function refresh(data as FaceData) as Void {
        var info = ActivityMonitor.getInfo();
        data.steps = info.steps;
        data.stepGoal = info.stepGoal;
        data.intensityMinutes = null;
        data.intensityGoal = null;
        if (info has :activeMinutesWeek && info.activeMinutesWeek != null) {
            // Garmin ya cuenta cada minuto vigoroso dos veces en total.
            data.intensityMinutes = Formatters.nonNegative(info.activeMinutesWeek.total);
        }
        if (info has :activeMinutesWeekGoal) {
            data.intensityGoal = Formatters.nonNegative(info.activeMinutesWeekGoal);
        }
    }
}

class BatteryProvider {
    function initialize() {}
    function refresh(data as FaceData) as Void {
        data.battery = Formatters.validPercent(System.getSystemStats().battery);
    }
}

class WeatherProvider {
    function initialize() {}
    function refresh(data as FaceData) as Void {
        data.temperature = null;
        data.condition = null;
        data.precipitation = null;
        var current = Weather.getCurrentConditions();
        if (current != null) {
            data.temperature = current.temperature; // Official cache, always Celsius.
            data.condition = current.condition;
            data.precipitation = Formatters.validPercent(current.precipitationChance);
        }
    }
}

class BodyBatteryProvider {
    private var _id as Complications.Id;
    var subscribed as Boolean = false;
    function initialize() {
        // Official native Id constructor excludes third-party complications.
        _id = new Complications.Id(Complications.COMPLICATION_TYPE_BODY_BATTERY);
    }
    function start(callback as Complications.ComplicationChangedCallback) as Void {
        Complications.registerComplicationChangeCallback(callback);
        subscribed = Complications.subscribeToUpdates(_id);
    }
    function stop() as Void {
        Complications.unsubscribeFromUpdates(_id);
        Complications.registerComplicationChangeCallback(null);
        subscribed = false;
    }
    function matches(id as Complications.Id) as Boolean { return _id.equals(id); }
    function refresh(data as FaceData) as Void {
        data.bodyBattery = null;
        try {
            var value = Complications.getComplication(_id).value;
            if (value instanceof Number || value instanceof Float) {
                data.bodyBattery = Formatters.validPercent(value);
            }
        } catch (error instanceof Complications.ComplicationNotFoundException) {
            // Missing complication: preserve the unavailable state.
        }
    }
}
