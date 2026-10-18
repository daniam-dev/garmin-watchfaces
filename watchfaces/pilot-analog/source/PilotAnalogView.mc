import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;

class PilotAnalogView extends WatchUi.WatchFace {
    private var _data as PilotData;
    private var _providers as PilotProviders;
    private var _renderer as PilotRenderer;
    private var _asleep as Boolean = false;
    private var _lastMinute as Number = -1;
    function initialize() {
        WatchFace.initialize();
        _data = new PilotData();
        _providers = new PilotProviders();
        _renderer = new PilotRenderer();
    }
    function onLayout(dc as Graphics.Dc) as Void { _renderer.layout(); }
    function onShow() as Void {
        _asleep = false;
        _lastMinute = -1;
    }
    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(PilotTheme.BLACK, PilotTheme.BLACK);
        dc.clear();
        if (_asleep) { return; }
        var minute = (Time.now().value() / 60).toNumber();
        if (minute != _lastMinute) {
            _lastMinute = minute;
            _providers.refresh(_data);
        }
        var clock = System.getClockTime();
        _renderer.draw(dc, _data, clock.hour, clock.min, clock.sec);
    }
    function onEnterSleep() as Void {
        _asleep = true;
        WatchUi.requestUpdate();
    }
    function onExitSleep() as Void {
        _asleep = false;
        _lastMinute = -1;
        WatchUi.requestUpdate();
    }
}
