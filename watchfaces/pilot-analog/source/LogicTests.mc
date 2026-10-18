import Toybox.Lang;
import Toybox.Test;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Weather;

(:test)
function pilotMissingData(logger as Test.Logger) as Boolean {
    Test.assertEqual(PilotFormat.integer(null),"--");
    Test.assertEqual(PilotFormat.temperature(null),"--°");
    Test.assertEqual(PilotFormat.steps(null),"--");
    Test.assertEqual(PilotFormat.steps(-1),"--");
    Test.assert(PilotFormat.percent(-1) == null);
    Test.assert(PilotFormat.percent(101) == null);
    return true;
}

(:test)
function pilotProgressLimits(logger as Test.Logger) as Boolean {
    Test.assertEqual(PilotFormat.progress(null,100),0.0f);
    Test.assertEqual(PilotFormat.progress(10,null),0.0f);
    Test.assertEqual(PilotFormat.progress(10,0),0.0f);
    Test.assertEqual(PilotFormat.progress(-1,100),0.0f);
    Test.assertEqual(PilotFormat.progress(0,100),0.0f);
    Test.assertEqual(PilotFormat.progress(100,100),1.0f);
    Test.assertEqual(PilotFormat.progress(200,100),1.0f);
    Test.assertEqual(PilotFormat.progress(50,100),0.5f);
    Test.assertEqual(PilotFormat.percent(0),0);
    Test.assertEqual(PilotFormat.percent(100),100);
    return true;
}

(:test)
function pilotBatteryColors(logger as Test.Logger) as Boolean {
    Test.assertEqual(PilotTheme.batteryColor(100),PilotTheme.BATTERY_HIGH);
    Test.assertEqual(PilotTheme.batteryColor(80),PilotTheme.BATTERY_HIGH);
    Test.assertEqual(PilotTheme.batteryColor(79.9f),PilotTheme.BATTERY_MEDIUM);
    Test.assertEqual(PilotTheme.batteryColor(50),PilotTheme.BATTERY_MEDIUM);
    Test.assertEqual(PilotTheme.batteryColor(30),PilotTheme.BATTERY_MEDIUM);
    Test.assertEqual(PilotTheme.batteryColor(29.9f),PilotTheme.BATTERY_LOW);
    Test.assertEqual(PilotTheme.batteryColor(15),PilotTheme.BATTERY_LOW);
    Test.assertEqual(PilotTheme.batteryColor(0),PilotTheme.BATTERY_LOW);
    Test.assertEqual(PilotTheme.batteryColor(null),PilotTheme.WHITE);
    Test.assertEqual(PilotTheme.batteryColor(-1),PilotTheme.WHITE);
    Test.assertEqual(PilotTheme.batteryColor(101),PilotTheme.WHITE);
    return true;
}

(:test)
function pilotSpanishFormatting(logger as Test.Logger) as Boolean {
    Test.assertEqual(PilotFormat.steps(0),"0");
    Test.assertEqual(PilotFormat.steps(999),"999");
    Test.assertEqual(PilotFormat.steps(5275),"5.275");
    Test.assertEqual(PilotFormat.steps(1234567),"1.234.567");
    Test.assertEqual(PilotFormat.temperature(-3.6f),"-4°");
    Test.assertEqual(PilotFormat.temperature(23.6f),"24°");
    Test.assertEqual(PilotFormat.MONTHS[0],"ENE");
    Test.assertEqual(PilotFormat.MONTHS[11],"DIC");
    return true;
}

(:test)
function pilotAnalogAngles(logger as Test.Logger) as Boolean {
    Test.assertEqual(PilotFormat.hourAngle(0,0,0),0.0f);
    Test.assertEqual(PilotFormat.hourAngle(12,0,0),0.0f);
    Test.assertEqual(PilotFormat.hourAngle(3,30,0),105.0f);
    Test.assertEqual(PilotFormat.hourAngle(15,30,0),105.0f);
    Test.assertEqual(PilotFormat.minuteAngle(15,30),93.0f);
    Test.assertEqual(PilotFormat.hourAngle(23,59,0),359.5f);
    return true;
}

(:test)
function pilotRendererSmoke(logger as Test.Logger) as Boolean {
    // This exercises Garmin's renderer; it is not a visual approval test.
    var surface = Graphics.createBufferedBitmap({:width=>390,:height=>390});
    var dc = surface.get().getDc();
    var renderer = new PilotRenderer();
    renderer.layout();
    var data = new PilotData();
    var start = System.getTimer();
    for (var i = 0; i < 60; i += 1) {
        dc.setColor(PilotTheme.BLACK,PilotTheme.BLACK);
        dc.clear();
        renderer.draw(dc,data,10,10,i);
    }
    data.battery = 78;
    data.temperature = 24;
    data.condition = Weather.CONDITION_PARTLY_CLOUDY;
    data.steps = 5275;
    data.goal = 10000;
    data.month = "OCT";
    data.day = "18";
    renderer.draw(dc,data,10,10,37);
    data.battery = 0;
    data.steps = 0;
    data.goal = 0;
    renderer.draw(dc,data,0,0,0);
    data.battery = 15;
    renderer.draw(dc,data,3,30,30);
    data.battery = 100;
    data.steps = 123456;
    data.goal = 100;
    data.temperature = -15;
    renderer.draw(dc,data,23,59,59);
    var stats = System.getSystemStats();
    logger.debug("Render 64 frames ms=" + (System.getTimer()-start).format("%d"));
    logger.debug("Memory used=" + stats.usedMemory.format("%d") + " free=" + stats.freeMemory.format("%d") + " total=" + stats.totalMemory.format("%d"));
    Test.assert(stats.freeMemory > 0);
    return true;
}
