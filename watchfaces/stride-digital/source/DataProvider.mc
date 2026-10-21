import Toybox.ActivityMonitor;
import Toybox.Complications;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Weather;

class StrideData {
    var timeText as String = "--:--";
    var dateText as String = "--";
    var steps as Number?;
    var goal as Number?;
    var heartRate as Number?;
    var body as Numeric?;
    var battery as Numeric?;
    var temperature as Numeric?;
    var rain as Numeric?;
    var condition as Number?;
    function initialize() {}
}

class StrideProvider {
    private var _bodyId as Complications.Id;
    private var _heartId as Complications.Id;
    private var _bodySubscribed as Boolean = false;
    private var _heartSubscribed as Boolean = false;
    function initialize() {
        _bodyId = new Complications.Id(Complications.COMPLICATION_TYPE_BODY_BATTERY);
        _heartId = new Complications.Id(Complications.COMPLICATION_TYPE_HEART_RATE);
    }
    function start(callback as Complications.ComplicationChangedCallback) as Void {
        Complications.registerComplicationChangeCallback(callback);
        try { _bodySubscribed = Complications.subscribeToUpdates(_bodyId); }
        catch (error instanceof Complications.ComplicationNotFoundException) { _bodySubscribed = false; }
        try { _heartSubscribed = Complications.subscribeToUpdates(_heartId); }
        catch (error instanceof Complications.ComplicationNotFoundException) { _heartSubscribed = false; }
    }
    function stop() as Void {
        if (_bodySubscribed) { Complications.unsubscribeFromUpdates(_bodyId); }
        if (_heartSubscribed) { Complications.unsubscribeFromUpdates(_heartId); }
        Complications.registerComplicationChangeCallback(null);
        _bodySubscribed = false;
        _heartSubscribed = false;
    }
    function matches(id as Complications.Id) as Boolean { return _bodyId.equals(id) || _heartId.equals(id); }
    function clock(data as StrideData) as Void {
        var clock = System.getClockTime();
        data.timeText = clock.hour.format("%02d") + ":" + clock.min.format("%02d");
        var date = Gregorian.info(Time.now(),Time.FORMAT_SHORT);
        data.dateText = StrideFormat.DAYS[(date.day_of_week as Number)-1] + " " + date.day.format("%d") + " " + StrideFormat.MONTHS[(date.month as Number)-1];
    }
    function health(data as StrideData) as Void {
        data.body = null;
        try {
            var value = Complications.getComplication(_bodyId).value;
            if (value instanceof Number || value instanceof Float) { data.body = StrideFormat.validPercent(value); }
        } catch (error instanceof Complications.ComplicationNotFoundException) {}
        data.heartRate = null;
        try {
            var value = Complications.getComplication(_heartId).value;
            if (value instanceof Number) { data.heartRate = StrideFormat.heartRate(value); }
        } catch (error instanceof Complications.ComplicationNotFoundException) {}
    }
    function refresh(data as StrideData) as Void {
        var activity = ActivityMonitor.getInfo();
        data.steps = StrideFormat.nonNegative(activity.steps);
        data.goal = StrideFormat.nonNegative(activity.stepGoal);
        data.battery = StrideFormat.validPercent(System.getSystemStats().battery);
        data.temperature = null; data.rain = null; data.condition = null;
        var weather = Weather.getCurrentConditions();
        if (weather != null) {
            data.temperature = weather.temperature;
            data.rain = StrideFormat.validPercent(weather.precipitationChance);
            data.condition = weather.condition;
        }
        health(data);
    }
}
