import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Test;
import Toybox.Weather;

(:test)
function modularTypographyFits(logger as Test.Logger) as Boolean {
    // El búfer mínimo permite medir con el motor real de Garmin, sin simular píxeles.
    var bitmap = Graphics.createBufferedBitmap({:width => 1, :height => 1});
    var dc = bitmap.get().getDc();
    var time = Graphics.getVectorFont({:face => "RobotoRegular", :size => Theme.TIME_SIZE});
    var date = Graphics.getVectorFont({:face => "RobotoRegular", :size => Theme.DATE_SIZE});
    var body = Graphics.getVectorFont({:face => "RobotoRegular", :size => Theme.BODY_SIZE});
    var label = Graphics.getVectorFont({:face => "RobotoRegular", :size => Theme.LABEL_SIZE});
    var compact = Graphics.getVectorFont({:face => "RobotoCondensedRegular", :size => Theme.COMPACT_SIZE});
    Test.assert(time != null && date != null && body != null && label != null);
    if (time == null || date == null || body == null || label == null) { return false; }
    Test.assert(compact != null);
    if (compact == null) { return false; }
    Test.assert(dc.getTextWidthInPixels("23:59", time) <= 290);
    Test.assert(dc.getTextWidthInPixels("MIÉ 30 SEPT", date) <= 230);
    Test.assert(dc.getTextWidthInPixels("Body Battery", date) <= 150);
    Test.assert(dc.getTextWidthInPixels("100%", date) <= 52);
    Test.assert(dc.getTextWidthInPixels("100", body) <= 58);
    Test.assert(dc.getTextWidthInPixels(Formatters.steps(999999), label) <= 54);
    Test.assert(dc.getTextWidthInPixels(Formatters.minutes(20160), compact) <= 56);
    logger.debug("Hora: " + dc.getTextWidthInPixels("23:59", time) + " px; alto de fuente: " + Graphics.getFontHeight(time));
    return true;
}

(:test)
function modularRendererHandlesDataStates(logger as Test.Logger) as Boolean {
    // Ejercita el dibujo nativo; este búfer no sustituye una captura visual.
    var bitmap = Graphics.createBufferedBitmap({:width => 1, :height => 1});
    var dc = bitmap.get().getDc();
    var renderer = new FaceRenderer();
    renderer.layout(dc);
    var data = new FaceData();
    renderer.draw(dc, data);
    Test.assertEqual(Formatters.percent(data.battery), "--");
    Test.assertEqual(Formatters.integer(data.bodyBattery), "--");
    Test.assertEqual(Formatters.minutes(data.intensityMinutes), "--");
    data.timeText = "23:59";
    data.weekday = "MIÉ";
    data.day = "30";
    data.month = "SEP";
    data.steps = 123456;
    data.stepGoal = 10000;
    data.intensityMinutes = 300;
    data.intensityGoal = 150;
    data.bodyBattery = 100;
    data.battery = 60;
    data.temperature = -12;
    data.condition = Weather.CONDITION_CLEAR;
    data.precipitation = 100;
    renderer.draw(dc, data);
    data.bodyBattery = 0;
    data.battery = 0;
    data.steps = 0;
    data.intensityMinutes = 0;
    data.precipitation = 0;
    renderer.draw(dc, data);
    // Dibuja las cuatro barras al subir y bajar, incluidos sus extremos reales.
    var levels = [0, 1, 25, 50, 75, 99, 100];
    for (var pass = 0; pass < 2; pass += 1) {
        for (var i = 0; i < levels.size(); i += 1) {
            var level = pass == 0 ? levels[i] : levels[levels.size() - i - 1];
            data.steps = level * 100;
            data.intensityMinutes = level * 2;
            data.intensityGoal = 200;
            data.bodyBattery = level;
            data.battery = level;
            renderer.draw(dc, data);
        }
    }
    Test.assertEqual(Formatters.percent(data.battery), "0%");
    Test.assertEqual(Formatters.integer(data.bodyBattery), "0");
    Test.assertEqual(Formatters.minutes(data.intensityMinutes), "0 min");
    data.intensityMinutes = 90;
    data.intensityGoal = null;
    renderer.draw(dc, data);
    data.intensityGoal = 0;
    renderer.draw(dc, data);
    Test.assertEqual(Formatters.ratio(data.bodyBattery, 100), 0.0f);
    return true;
}

(:test)
function modularRailsClearDials(logger as Test.Logger) as Boolean {
    // Comprueba la separación de superficies completas, incluidos los marcadores.
    // Detecta que un círculo pueda tapar el arco en cualquier porcentaje.
    var dx = Theme.LEFT_X - Theme.CENTER;
    var dy = Theme.DIAL_Y - Theme.CENTER;
    var dialOuterEdge = Math.sqrt(dx * dx + dy * dy) + Theme.DIAL_RADIUS + 0.5f;
    Test.assert(dialOuterEdge + 1 < Theme.ARC_RADIUS - Theme.MARKER_RADIUS);
    Test.assert(dialOuterEdge + 1 < Theme.ARC_RADIUS - Theme.ARC_WIDTH / 2.0f);
    // Los contadores superiores caben dentro de los arcos y quedan sobre la fecha.
    var metricsEdgeX = Theme.CENTER - Theme.STEPS_METRIC_X + 27;
    var metricsEdgeY = Theme.CENTER - (Theme.METRICS_VALUE_Y - Theme.LABEL_SIZE / 2.0f);
    Test.assert(Math.sqrt(metricsEdgeX * metricsEdgeX + metricsEdgeY * metricsEdgeY) + 1 < Theme.ARC_RADIUS - Theme.MARKER_RADIUS);
    var minutesEdgeX = Theme.INTENSITY_METRIC_X - Theme.CENTER + 28;
    Test.assert(Math.sqrt(minutesEdgeX * minutesEdgeX + metricsEdgeY * metricsEdgeY) + 1 < Theme.ARC_RADIUS - Theme.MARKER_RADIUS);
    Test.assert(Theme.METRICS_VALUE_Y + Theme.LABEL_SIZE / 2.0f + 4 < Theme.DATE_Y - Theme.DATE_SIZE / 2.0f);
    Test.assert(Theme.METRICS_ICON_Y + 9 + 2 < Theme.METRICS_VALUE_Y - Theme.LABEL_SIZE / 2.0f);
    return true;
}

(:test)
function modularIntensityProgress(logger as Test.Logger) as Boolean {
    Test.assert(Formatters.nonNegative(null) == null);
    Test.assert(Formatters.nonNegative(-1) == null);
    Test.assertEqual(Formatters.nonNegative(0), 0);
    Test.assertEqual(Formatters.nonNegative(300), 300);
    Test.assertEqual(Formatters.minutes(null), "--");
    Test.assertEqual(Formatters.minutes(0), "0 min");
    Test.assertEqual(Formatters.minutes(300), "300 min");
    Test.assertEqual(Formatters.ratio(90, 150), 0.6f);
    Test.assertEqual(Formatters.ratio(150, 150), 1.0f);
    Test.assertEqual(Formatters.ratio(300, 150), 1.0f);
    Test.assertEqual(Formatters.ratio(0, 150), 0.0f);
    Test.assertEqual(Formatters.ratio(null, 150), 0.0f);
    Test.assertEqual(Formatters.ratio(90, null), 0.0f);
    Test.assertEqual(Formatters.ratio(90, 0), 0.0f);
    return true;
}
