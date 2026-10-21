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
    Test.assertEqual(StrideTargets.at(195,34),Complications.COMPLICATION_TYPE_BATTERY);
    Test.assertEqual(StrideTargets.at(195,74),Complications.COMPLICATION_TYPE_DATE);
    Test.assertEqual(StrideTargets.at(96,258),Complications.COMPLICATION_TYPE_STEPS);
    Test.assertEqual(StrideTargets.at(195,258),Complications.COMPLICATION_TYPE_BODY_BATTERY);
    Test.assertEqual(StrideTargets.at(294,258),Complications.COMPLICATION_TYPE_HEART_RATE);
    Test.assertEqual(StrideTargets.at(118,334),Complications.COMPLICATION_TYPE_CURRENT_WEATHER);
    Test.assertEqual(StrideTargets.at(260,334),Complications.COMPLICATION_TYPE_CURRENT_WEATHER);
    Test.assertEqual(StrideTargets.at(3,195),Complications.COMPLICATION_TYPE_STEPS);
    Test.assertEqual(StrideTargets.at(387,195),Complications.COMPLICATION_TYPE_BODY_BATTERY);
    Test.assert(StrideTargets.at(195,164) == null);
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
    var label = Graphics.getVectorFont({:face => "RobotoCondensedRegular",:size => 16});
    Test.assert(font != null && small != null && label != null);
    if (font == null || small == null || label == null) { return false; }
    // Ancho real de las 1.440 horas posibles; vigila cambios de avance de la fuente.
    for (var hour = 0; hour < 24; hour += 1) {
        for (var minute = 0; minute < 60; minute += 1) {
            var time = hour.format("%02d") + ":" + minute.format("%02d");
            Test.assert(dc.getTextWidthInPixels(time,font) <= 342);
        }
    }
    Test.assert(dc.getTextWidthInPixels("88:88",font) <= 342);
    Test.assert(dc.getTextWidthInPixels("--:--",font) > 0);
    var height = Graphics.getFontHeight(font);
    Test.assert(StrideTheme.TIME_Y + height/2 + 2 < StrideTheme.RULE_Y);
    Test.assert(StrideTheme.TIME_Y - height/2 > StrideTheme.DATE_Y + 16);
    Test.assert(dc.getTextWidthInPixels("999.999",small) <= 82);
    Test.assert(dc.getTextWidthInPixels("100.000",small) <= 82);
    Test.assert(dc.getTextWidthInPixels("100%",small) <= 60);
    Test.assert(dc.getTextWidthInPixels("220",value) <= 82);
    Test.assert(Graphics.getFontHeight(value)/2 + 8 < StrideTheme.LABEL_Y - StrideTheme.VALUE_Y);
    Test.assert(dc.getTextWidthInPixels("BODY BATTERY",label) <= 92);
    Test.assert(dc.getTextWidthInPixels("PULSO / LPM",label) <= 92);
    logger.debug("Hora: " + dc.getTextWidthInPixels("88:88",font) + " px; altura de fuente: " + Graphics.getFontHeight(font));
    var renderer = new StrideRenderer(); renderer.layout();
    var data = new StrideData(); renderer.draw(dc,data);
    data.timeText = "23:59"; data.dateText = "MIÉ 30 SEP";
    data.steps = 999999; data.goal = 10000; data.heartRate = 220;
    data.body = 100; data.battery = 100; data.temperature = -12; data.rain = 100;
    data.condition = Weather.CONDITION_PARTLY_CLOUDY; renderer.draw(dc,data);
    data.steps = 0; data.heartRate = null; data.body = 0; data.battery = 0; data.rain = 0;
    data.condition = Weather.CONDITION_RAIN; renderer.draw(dc,data);
    data.goal = null; data.condition = Weather.CONDITION_UNKNOWN; renderer.draw(dc,data);
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
