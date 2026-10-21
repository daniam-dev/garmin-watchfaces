import Toybox.Graphics;
import Toybox.Lang;

class FaceRenderer {
    private var _timeFont as Graphics.FontType = Graphics.FONT_NUMBER_HOT;
    private var _valueFont as Graphics.FontType = Graphics.FONT_SMALL;
    private var _labelFont as Graphics.FontType = Graphics.FONT_XTINY;
    private var _compactFont as Graphics.FontType = Graphics.FONT_XTINY;
    private var _dateFont as Graphics.FontType = Graphics.FONT_TINY;
    private var _calendarFont as Graphics.FontType = Graphics.FONT_TINY;
    private var _bodyFont as Graphics.FontType = Graphics.FONT_SMALL;

    function initialize() {}

    function layout(dc as Graphics.Dc) as Void {
        // Hora dominante, blanca y de peso deportivo; los datos mantienen su escala.
        var time = Graphics.getVectorFont({:face => Theme.TIME_FACE, :size => Theme.TIME_SIZE});
        var value = Graphics.getVectorFont({:face => "RobotoRegular", :size => Theme.VALUE_SIZE});
        var label = Graphics.getVectorFont({:face => "RobotoRegular", :size => Theme.LABEL_SIZE});
        var compact = Graphics.getVectorFont({:face => "RobotoCondensedRegular", :size => Theme.COMPACT_SIZE});
        var date = Graphics.getVectorFont({:face => "RobotoRegular", :size => Theme.DATE_SIZE});
        var calendar = Graphics.getVectorFont({:face => "RobotoRegular", :size => Theme.CALENDAR_SIZE});
        var body = Graphics.getVectorFont({:face => "RobotoRegular", :size => Theme.BODY_SIZE});
        if (time != null) { _timeFont = time; }
        if (value != null) { _valueFont = value; }
        if (label != null) { _labelFont = label; }
        if (compact != null) { _compactFont = compact; }
        if (date != null) { _dateFont = date; }
        if (calendar != null) { _calendarFont = calendar; }
        if (body != null) { _bodyFont = body; }
    }

    function draw(dc as Graphics.Dc, data as FaceData) as Void {
        dc.setColor(Theme.TEXT, Theme.BACKGROUND);
        dc.clear();
        dc.setAntiAlias(true);
        Components.rail(dc, Theme.STEPS_ARC_START, false,
                        Formatters.ratio(data.steps, data.stepGoal), Theme.STEPS,
                        data.steps != null && data.stepGoal != null && data.stepGoal > 0);
        Components.rail(dc, Theme.RIGHT_ARC_START, true,
                        Formatters.ratio(data.intensityMinutes, data.intensityGoal), Theme.INTENSITY,
                        data.intensityMinutes != null && data.intensityGoal != null && data.intensityGoal > 0);

        dc.setColor(Theme.MUTED, Graphics.COLOR_TRANSPARENT);
        var date = data.weekday + " " + data.day + " " + data.month;
        dc.drawText(Theme.CENTER, Theme.DATE_Y, _calendarFont, date, Theme.TEXT_CENTER);
        dc.setColor(Theme.TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(Theme.CENTER, Theme.TIME_Y, _timeFont, data.timeText, Theme.TEXT_CENTER);

        drawBodyPanel(dc, data);
        drawDials(dc, data);
        drawTopMetrics(dc, data);
        dc.setPenWidth(1);
    }

    private function drawTopMetrics(dc as Graphics.Dc, data as FaceData) as Void {
        dc.setColor(Theme.STEPS, Graphics.COLOR_TRANSPARENT);
        Components.feet(dc, Theme.STEPS_METRIC_X, Theme.METRICS_ICON_Y);
        dc.setColor(Theme.INTENSITY, Graphics.COLOR_TRANSPARENT);
        Components.intensity(dc, Theme.INTENSITY_METRIC_X, Theme.METRICS_ICON_Y);
        dc.setColor(Theme.TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(Theme.STEPS_METRIC_X, Theme.METRICS_VALUE_Y, _labelFont, Formatters.steps(data.steps), Theme.TEXT_CENTER);
        var minutes = Formatters.minutes(data.intensityMinutes);
        var minutesFont = dc.getTextWidthInPixels(minutes, _labelFont) > 56 ? _compactFont : _labelFont;
        dc.drawText(Theme.INTENSITY_METRIC_X, Theme.METRICS_VALUE_Y, minutesFont, minutes, Theme.TEXT_CENTER);
    }

    private function drawBodyPanel(dc as Graphics.Dc, data as FaceData) as Void {
        dc.setColor(Theme.SURFACE, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(Theme.PANEL_X, Theme.PANEL_Y, Theme.PANEL_WIDTH,
                                Theme.PANEL_HEIGHT, Theme.PANEL_RADIUS);
        dc.setPenWidth(1);
        dc.setColor(Theme.BODY_OUTLINE, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(Theme.PANEL_X, Theme.PANEL_Y, Theme.PANEL_WIDTH,
                                Theme.PANEL_HEIGHT, Theme.PANEL_RADIUS);
        Components.arc(dc, Theme.GAUGE_X, Theme.GAUGE_Y, Theme.GAUGE_RADIUS,
                       180, 180, true, Formatters.ratio(data.bodyBattery, 100),
                       Theme.BODY, Theme.BODY_TRACK, Theme.GAUGE_WIDTH, false);
        dc.setColor(data.bodyBattery == null ? Theme.MUTED : Theme.BODY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(Theme.GAUGE_X, Theme.BODY_VALUE_Y, _bodyFont, Formatters.integer(data.bodyBattery), Theme.TEXT_CENTER);
        dc.setColor(Theme.TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(169, Theme.BODY_TITLE_Y, _dateFont, "Body Battery", Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(Theme.BODY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(169, Theme.BODY_STATUS_Y, _labelFont, data.bodyBattery == null ? "Sin datos" : "Nivel actual",
                    Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function drawDials(dc as Graphics.Dc, data as FaceData) as Void {
        Components.dial(dc, Theme.LEFT_X, Theme.WEATHER_DIAL, Theme.WEATHER_OUTLINE);
        Components.dial(dc, Theme.CENTER, Theme.RAIN_DIAL, Theme.RAIN_OUTLINE);
        Components.dial(dc, Theme.RIGHT_X, Theme.BATTERY_DIAL, Theme.BATTERY_OUTLINE);
        Components.weather(dc, Theme.LEFT_X, Theme.DIAL_ICON_Y, data.condition);
        Components.rain(dc, Theme.CENTER, Theme.DIAL_ICON_Y);
        dc.setColor(Theme.TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(Theme.LEFT_X, Theme.DIAL_VALUE_Y, _valueFont, Formatters.temperature(data.temperature), Theme.TEXT_CENTER);
        var rain = Formatters.percent(data.precipitation);
        var rainFont = dc.getTextWidthInPixels(rain, _valueFont) > 52 ? _dateFont : _valueFont;
        dc.setColor(data.precipitation == null ? Theme.MUTED : Theme.STEPS, Graphics.COLOR_TRANSPARENT);
        dc.drawText(Theme.CENTER, Theme.DIAL_VALUE_Y, rainFont, rain, Theme.TEXT_CENTER);

        Components.arc(dc, Theme.RIGHT_X, Theme.DIAL_Y, Theme.BATTERY_RADIUS,
                       90, 360, true, Formatters.ratio(data.battery, 100),
                       Theme.batteryColor(data.battery), Theme.OUTLINE, 4, false);
        dc.setColor(Theme.TEXT, Graphics.COLOR_TRANSPARENT);
        Components.batteryIcon(dc, Theme.RIGHT_X, Theme.BATTERY_ICON_Y);
        dc.drawText(Theme.RIGHT_X, Theme.BATTERY_VALUE_Y, _dateFont, Formatters.percent(data.battery), Theme.TEXT_CENTER);
    }
}
