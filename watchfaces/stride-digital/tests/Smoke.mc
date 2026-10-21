import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Weather;

// Diagnóstico con el límite normal de memoria de una watchface fr170.
// Solo se incluye desde el Jungle temporal en bin/, nunca en el programa final.
class StrideSmokeApp extends Application.AppBase {
    function initialize() { AppBase.initialize(); }
    function getInitialView() as [Views] or [Views, InputDelegates] { return [new StrideSmokeView()]; }
}
class StrideSmokeView extends WatchUi.WatchFace {
    private var _renderer as StrideRenderer;
    private var _done as Boolean = false;
    function initialize() { WatchFace.initialize(); _renderer = new StrideRenderer(); }
    function onLayout(dc as Graphics.Dc) as Void { _renderer.layout(); }
    function onUpdate(dc as Graphics.Dc) as Void {
        if (_done) { return; }
        _done = true;
        var data = new StrideData();
        _renderer.draw(dc,data);
        data.timeText = "23:59"; data.dateText = "MIÉ 30 SEP";
        data.steps = 999999; data.goal = 10000; data.heartRate = 220;
        data.body = 100; data.battery = 100; data.temperature = -12; data.rain = 100;
        data.condition = Weather.CONDITION_PARTLY_CLOUDY; _renderer.draw(dc,data);
        data.steps = 0; data.heartRate = null; data.body = 0; data.battery = 0; data.rain = 0;
        data.condition = Weather.CONDITION_UNKNOWN; _renderer.draw(dc,data);
        var stats = System.getSystemStats();
        System.println("STRIDE SMOKE PASS: used="+stats.usedMemory+" free="+stats.freeMemory+" total="+stats.totalMemory);
    }
}
