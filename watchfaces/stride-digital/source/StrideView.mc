import Toybox.Complications;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class StrideView extends WatchUi.WatchFace {
    private var _data as StrideData;
    private var _provider as StrideProvider;
    private var _renderer as StrideRenderer;
    private var _minute as Number = -1;
    private var _asleep as Boolean = false;
    private var _visible as Boolean = false;
    function initialize() {
        WatchFace.initialize();
        _data = new StrideData(); _provider = new StrideProvider(); _renderer = new StrideRenderer();
    }
    function onLayout(dc as Graphics.Dc) as Void { _renderer.layout(); }
    function onShow() as Void {
        _visible = true; _asleep = false; _minute = -1;
        _provider.start(method(:onComplicationChanged));
    }
    function onHide() as Void { _visible = false; _provider.stop(); }
    function onComplicationChanged(id as Complications.Id) as Void {
        if (_provider.matches(id)) {
            _provider.health(_data);
            if (_visible && !_asleep) { WatchUi.requestUpdate(); }
        }
    }
    function onUpdate(dc as Graphics.Dc) as Void {
        if (_asleep) { dc.setColor(StrideTheme.BLACK,StrideTheme.BLACK); dc.clear(); return; }
        _provider.clock(_data);
        var minute = Time.now().value()/60;
        if (minute != _minute) { _minute = minute; _provider.refresh(_data); }
        _renderer.draw(dc,_data);
    }
    function onEnterSleep() as Void { _asleep = true; WatchUi.requestUpdate(); }
    function onExitSleep() as Void { _asleep = false; _minute = -1; WatchUi.requestUpdate(); }
}
