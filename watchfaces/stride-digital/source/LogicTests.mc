import Toybox.Complications;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Test;
import Toybox.Weather;
import Toybox.WatchUi;

(:test)
function strideDataContracts(logger as Test.Logger) as Boolean {
    Test.assertEqual(StrideFormat.number(null),"--");
    Test.assertEqual(StrideFormat.number(0),"0");
    Test.assertEqual(StrideFormat.percent(0),"0%");
    Test.assertEqual(StrideFormat.percent(null),"--");
    Test.assert(StrideFormat.validPercent(-1) == null);
    Test.assert(StrideFormat.validPercent(101) == null);
    Test.assertEqual(StrideFormat.validPercent(100),100);
    Test.assert(StrideFormat.nonNegative(-1) == null);
    Test.assertEqual(StrideFormat.temperature(-3.6f),"-4°");
    Test.assertEqual(StrideFormat.steps(123456),"123.456");
    Test.assertEqual(StrideFormat.steps(0),"0");
    Test.assertEqual(StrideFormat.progress(90,150),0.6f);
    Test.assertEqual(StrideFormat.progress(300,150),1.0f);
    Test.assertEqual(StrideFormat.progress(0,150),0.0f);
    Test.assertEqual(StrideFormat.progress(50,null),0.0f);
    Test.assertEqual(StrideFormat.progress(50,0),0.0f);
    return true;
}

(:test)
function strideComplicationTargets(logger as Test.Logger) as Boolean {
    Test.assertEqual(StrideTargets.at(297,58),Complications.COMPLICATION_TYPE_BATTERY);
    Test.assertEqual(StrideTargets.at(252,52),Complications.COMPLICATION_TYPE_BATTERY);
    Test.assertEqual(StrideTargets.at(149,43),Complications.COMPLICATION_TYPE_DATE);
    Test.assertEqual(StrideTargets.at(284,107),Complications.COMPLICATION_TYPE_STEPS);
    Test.assertEqual(StrideTargets.at(284,192),Complications.COMPLICATION_TYPE_BODY_BATTERY);
    Test.assertEqual(StrideTargets.at(284,277),Complications.COMPLICATION_TYPE_HEART_RATE);
    Test.assertEqual(StrideTargets.at(118,344),Complications.COMPLICATION_TYPE_CURRENT_WEATHER);
    Test.assertEqual(StrideTargets.at(260,344),Complications.COMPLICATION_TYPE_CURRENT_WEATHER);
    // El progreso y sus extremos deben abrir el mismo dato que su cifra.
    for (var x = StrideTheme.BAR_X; x < StrideTheme.BAR_X+StrideTheme.BAR_WIDTH; x += 1) {
        for (var row = 0; row < StrideTheme.BAR_HEIGHT; row += 1) {
            Test.assertEqual(StrideTargets.at(x,StrideTheme.STEPS_Y+StrideTheme.BAR_OFFSET+row),Complications.COMPLICATION_TYPE_STEPS);
            Test.assertEqual(StrideTargets.at(x,StrideTheme.BODY_Y+StrideTheme.BAR_OFFSET+row),Complications.COMPLICATION_TYPE_BODY_BATTERY);
        }
    }
    Test.assertEqual(StrideTargets.at(238,219),Complications.COMPLICATION_TYPE_BODY_BATTERY);
    Test.assertEqual(StrideTargets.at(330,304),Complications.COMPLICATION_TYPE_HEART_RATE);
    Test.assert(StrideTargets.at(130,131) == null);
    Test.assert(StrideTargets.at(130,259) == null);
    Test.assert(StrideTargets.at(3,195) == null);
    Test.assert(StrideTargets.at(387,195) == null);
    Test.assert(StrideTargets.at(0,0) == null);
    Test.assert(StrideTargets.at(49,260) == null);
    return true;
}

(:test)
function strideNativeTypographyAndStates(logger as Test.Logger) as Boolean {
    var bitmap = Graphics.createBufferedBitmap({:width => 1,:height => 1});
    var dc = bitmap.get().getDc();
    var font = WatchUi.loadResource(Rez.Fonts.Time) as WatchUi.FontResource;
    var value = WatchUi.loadResource(Rez.Fonts.Value) as WatchUi.FontResource;
    var small = WatchUi.loadResource(Rez.Fonts.Compact) as WatchUi.FontResource;
    var label = Graphics.getVectorFont({:face => "RobotoCondensedRegular",:size => StrideTheme.LABEL_SIZE});
    var date = Graphics.getVectorFont({:face => "RobotoRegular",:size => StrideTheme.DATE_SIZE});
    Test.assert(font != null && small != null && label != null && date != null);
    if (font == null || small == null || label == null || date == null) { return false; }
    var height = Graphics.getFontHeight(font);
    // Las dos líneas deben caber en el círculo físico, incluidas sus esquinas.
    for (var hour = 0; hour < 24; hour += 1) {
        for (var minute = 0; minute < 60; minute += 1) {
            var lines = [hour.format("%02d"),minute.format("%02d")];
            var centers = [StrideTheme.HOURS_Y,StrideTheme.MINUTES_Y];
            for (var line = 0; line < 2; line += 1) {
                var width = dc.getTextWidthInPixels(lines[line],font);
                Test.assert(width <= 166);
                for (var side = -1; side <= 1; side += 2) {
                    for (var end = -1; end <= 1; end += 2) {
                        var dx = StrideTheme.TIME_X+side*width/2.0f-195;
                        var dy = centers[line]+end*height/2.0f-195;
                        Test.assert(dx*dx+dy*dy <= 193*193);
                    }
                }
            }
        }
    }
    Test.assertEqual(dc.getTextWidthInPixels("11",font),dc.getTextWidthInPixels("88",font));
    Test.assert(dc.getTextWidthInPixels("--",font) > 0);
    Test.assert(StrideTheme.MINUTES_Y-StrideTheme.HOURS_Y-height >= 8);
    Test.assert(StrideTheme.HOURS_Y-height/2 > StrideTheme.DATE_Y+StrideTheme.DATE_SIZE/2+10);
    Test.assert(StrideTheme.MINUTES_Y+height/2 < StrideTheme.WEATHER_Y-20);
    Test.assert(dc.getTextWidthInPixels("999.999",small) <= StrideTheme.METRIC_WIDTH);
    Test.assert(dc.getTextWidthInPixels("100.000",small) <= StrideTheme.METRIC_WIDTH);
    Test.assert(dc.getTextWidthInPixels("100%",small) <= 60);
    Test.assert(dc.getTextWidthInPixels("220",value) <= StrideTheme.METRIC_WIDTH);
    Test.assert(Graphics.getFontHeight(value)/2+Graphics.getFontHeight(label)/2+3 <= StrideTheme.LABEL_OFFSET);
    Test.assert(dc.getTextWidthInPixels("BODY BATTERY",label) <= StrideTheme.METRIC_WIDTH);
    Test.assert(dc.getTextWidthInPixels("PULSO / LPM",label) <= StrideTheme.METRIC_WIDTH);
    Test.assert(dc.getTextWidthInPixels("MIÉ 30 SEP",date) <= 120);
    logger.debug("Línea horaria: " + dc.getTextWidthInPixels("88",font) + " px; altura: " + height);
    var renderer = new StrideRenderer(); renderer.layout();
    var data = new StrideData(); renderer.draw(dc,data);
    data.timeText = "23:59"; data.dateText = "MIÉ 30 SEP";
    data.steps = 999999; data.goal = 10000; data.heartRate = 220;
    data.body = 100; data.battery = 100; data.temperature = -12; data.rain = 100;
    data.condition = Weather.CONDITION_PARTLY_CLOUDY; renderer.draw(dc,data);
    data.steps = 0; data.heartRate = null; data.body = 0; data.battery = 0; data.rain = 0;
    data.condition = Weather.CONDITION_RAIN; renderer.draw(dc,data);
    data.goal = null; data.condition = Weather.CONDITION_UNKNOWN; renderer.draw(dc,data);
    data.timeText = "11:11"; renderer.draw(dc,data);
    return true;
}

(:test)
function strideHeartRateAndEvents(logger as Test.Logger) as Boolean {
    Test.assert(StrideFormat.heartRate(null) == null);
    Test.assert(StrideFormat.heartRate(0) == null);
    Test.assert(StrideFormat.heartRate(-1) == null);
    Test.assertEqual(StrideFormat.heartRate(72),72);
    Test.assertEqual(StrideFormat.heartRate(220),220);
    Test.assertEqual(StrideFormat.number(StrideFormat.heartRate(0)),"--");
    var provider = new StrideProvider();
    Test.assert(provider.matches(new Complications.Id(Complications.COMPLICATION_TYPE_BODY_BATTERY)));
    Test.assert(provider.matches(new Complications.Id(Complications.COMPLICATION_TYPE_HEART_RATE)));
    Test.assert(!provider.matches(new Complications.Id(Complications.COMPLICATION_TYPE_BATTERY)));
    return true;
}
