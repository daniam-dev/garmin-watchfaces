import Toybox.Complications;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class garmin_watchfacesView extends WatchUi.WatchFace {
    private var _data as FaceData;
    private var _clock as ClockProvider;
    private var _activity as ActivityProvider;
    private var _battery as BatteryProvider;
    private var _weather as WeatherProvider;
    private var _body as BodyBatteryProvider;
    private var _renderer as FaceRenderer;
    private var _asleep as Boolean = false;
    private var _visible as Boolean = false;
    private var _lastMinute as Number = -1;

    function initialize() {
        WatchFace.initialize();
        _data = new FaceData();
        _clock = new ClockProvider();
        _activity = new ActivityProvider();
        _battery = new BatteryProvider();
        _weather = new WeatherProvider();
        _body = new BodyBatteryProvider();
        _renderer = new FaceRenderer();
    }
    function onLayout(dc as Graphics.Dc) as Void { _renderer.layout(dc); }
    function onShow() as Void {
        _visible = true;
        _asleep = false;
        _lastMinute = -1;
        _body.start(method(:onComplicationChanged));
    }
    function onHide() as Void {
        _visible = false;
        _body.stop();
    }
    function onComplicationChanged(id as Complications.Id) as Void {
        if (_body.matches(id)) {
            _body.refresh(_data);
            if (_visible && !_asleep) { WatchUi.requestUpdate(); }
        }
    }
    function onUpdate(dc as Graphics.Dc) as Void {
        if (_asleep) {
            dc.setColor(Theme.BACKGROUND, Theme.BACKGROUND);
            dc.clear();
            return;
        }
        _clock.refresh(_data);
        var minute = Time.now().value() / 60;
        if (minute != _lastMinute) {
            _lastMinute = minute;
            _activity.refresh(_data);
            _battery.refresh(_data);
            _weather.refresh(_data);
            _body.refresh(_data);
        }
        _renderer.draw(dc, _data);
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
