import Toybox.Graphics;
import Toybox.Lang;

class FaceRenderer {
    private var _timeFont as Graphics.FontType = Graphics.FONT_NUMBER_HOT;
    private var _valueFont as Graphics.FontType = Graphics.FONT_SMALL;
    private var _smallFont as Graphics.FontType = Graphics.FONT_XTINY;
    private var _dateFont as Graphics.FontType = Graphics.FONT_TINY;
    private var _compactFont as Graphics.FontType = Graphics.FONT_XTINY;
    private var _dayFont as Graphics.FontType = Graphics.FONT_SMALL;
    function initialize() {}
    function layout(dc as Graphics.Dc) as Void {
        // Official device fonts; no bundled TTF or full-screen bitmap.
        var time = Graphics.getVectorFont({:face => "RobotoCondensedBold", :size => 116});
        var value = Graphics.getVectorFont({:face => "RobotoRegular", :size => 24});
        var small = Graphics.getVectorFont({:face => "RobotoRegular", :size => 20});
        var date = Graphics.getVectorFont({:face => "RobotoRegular", :size => 13});
        var compact = Graphics.getVectorFont({:face => "RobotoCondensedBold", :size => 21});
        var day = Graphics.getVectorFont({:face => "RobotoRegular", :size => 28});
        if (time != null) { _timeFont = time; }
        if (value != null) { _valueFont = value; }
        if (small != null) { _smallFont = small; }
        if (date != null) { _dateFont = date; }
        if (compact != null) { _compactFont = compact; }
        if (day != null) { _dayFont = day; }
    }
    function draw(dc as Graphics.Dc, data as FaceData) as Void {
        dc.setColor(Theme.TEXT, Theme.BACKGROUND);
        dc.clear();
        dc.setAntiAlias(true);
        Components.arc(dc, 195, 195, Theme.ARC_RADIUS, Theme.STEPS_ARC_START, Theme.ARC_SWEEP, false,
                       Formatters.ratio(data.steps, data.stepGoal), Theme.STEPS,
                       Theme.STEPS_TRACK, Theme.ARC_WIDTH, data.steps != null && data.stepGoal != null && data.stepGoal > 0);
        Components.arc(dc, 195, 195, Theme.ARC_RADIUS, Theme.BODY_ARC_START, Theme.ARC_SWEEP, true,
                       Formatters.ratio(data.bodyBattery, 100), Theme.BODY,
                       Theme.BODY_TRACK, Theme.ARC_WIDTH, data.bodyBattery != null);
        Components.circle(dc, Theme.LEFT_X, Theme.TOP_Y, Theme.TOP_RADIUS);
        Components.circle(dc, 195, Theme.WEATHER_Y, Theme.WEATHER_RADIUS);
        Components.circle(dc, Theme.RIGHT_X, Theme.TOP_Y, Theme.TOP_RADIUS);
        dc.setColor(Theme.MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(Theme.LEFT_X, 87, _dateFont, data.weekday, Theme.TEXT_CENTER);
        dc.setColor(Theme.TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(Theme.LEFT_X, 107, _dayFont, data.day, Theme.TEXT_CENTER);
        dc.drawText(Theme.LEFT_X, 127, _dateFont, data.month, Theme.TEXT_CENTER);
        Components.weather(dc, 195, 83, data.condition);
        Components.rain(dc, Theme.RIGHT_X, 96);
        dc.setColor(Theme.TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, 112, _valueFont, Formatters.temperature(data.temperature), Theme.TEXT_CENTER);
        dc.drawText(Theme.RIGHT_X, 124, _valueFont, Formatters.percent(data.precipitation), Theme.TEXT_CENTER);
        dc.drawText(195, Theme.TIME_Y, _timeFont, data.timeText, Theme.TEXT_CENTER);
        dc.setColor(Theme.STEPS, Graphics.COLOR_TRANSPARENT);
        Components.feet(dc, 88, 277);
        var steps = Formatters.steps(data.steps);
        var font = dc.getTextWidthInPixels(steps, _valueFont) > 96 ? _compactFont : _valueFont;
        dc.setColor(Theme.TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(88, 302, font, steps, Theme.TEXT_CENTER);
        dc.setColor(Theme.BODY, Graphics.COLOR_TRANSPARENT);
        Components.energy(dc, 301, 277);
        dc.setColor(Theme.TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(301, 302, _valueFont, Formatters.integer(data.bodyBattery), Theme.TEXT_CENTER);
        Components.circle(dc, 195, Theme.BATTERY_Y, 44);
        Components.arc(dc, 195, Theme.BATTERY_Y, Theme.BATTERY_RADIUS, 90, 360, true,
                       Formatters.ratio(data.battery, 100), Theme.BATTERY, Theme.OUTLINE, 6, false);
        dc.setColor(Theme.TEXT, Graphics.COLOR_TRANSPARENT);
        Components.batteryIcon(dc, 195, 301);
        dc.drawText(195, 326, _smallFont, Formatters.percent(data.battery), Theme.TEXT_CENTER);
        dc.setPenWidth(1);
    }
}
