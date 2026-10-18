import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

// Only included by tests/run.ps1 in a temporary diagnostic build.
class PilotSmokeApp extends Application.AppBase {
    function initialize() { AppBase.initialize(); }
    function getInitialView() as [Views] or [Views,InputDelegates] {
        return [new PilotSmokeView()];
    }
}

class PilotSmokeView extends PilotAnalogView {
    private var _frames as Number = 0;
    function initialize() { PilotAnalogView.initialize(); }
    function onUpdate(dc as Graphics.Dc) as Void {
        if (_frames >= 3) { return; }
        var start = System.getTimer();
        PilotAnalogView.onUpdate(dc);
        var stats = System.getSystemStats();
        System.println("SMOKE frame=" + _frames.format("%d") + " renderMs=" + (System.getTimer()-start).format("%d") +
                       " used=" + stats.usedMemory.format("%d") + " free=" + stats.freeMemory.format("%d") +
                       " total=" + stats.totalMemory.format("%d"));
        if (stats.usedMemory >= 131072) { System.println("SMOKE FAIL memory"); }
        _frames += 1;
        if (_frames == 3) {
            // Ejercitar reposo y despertar de la vista real.
            onEnterSleep();
            PilotAnalogView.onUpdate(dc);
            onExitSleep();
            PilotAnalogView.onUpdate(dc);
            System.println("SMOKE PASS");
            // The command-line runner closes this diagnostic session.
        }
    }
}
